
library(grid)
library(vwline)
library(gridGeometry)

black <- rgb(.2,.2,.2)

horizBrush <- list(x=c(-1, 0, 0, -1), y=c(-.125, -.125, .125, .125))
    
locations <- data.frame(name=character(),
                        angle=numeric(),
                        x=numeric(),
                        y=numeric())

datacol <- 3
guidecol <- 4

setLoc <- function(name, angle) {
    xy <- deviceLoc(grobX(name, angle), grobY(name, angle), valueOnly=TRUE)
    locations <<- rbind(locations,
                        data.frame(name=name, angle=angle,
                                   x=xy$x, y=xy$y))
}

getLoc <- function(name, angle, which) {
    result <- locations[locations$name == name & locations$angle == angle, ]
    if (nrow(result) == 1) {
        result[[which]]
    } else {
        stop(paste("Location for", name, "unknown"))
    }
}

node <- function(name, label=name, face="plain",
                 col="white", fill=black) {
    if (grepl("absolute", label)) {
        label <- substitute(bold(absolute)*txt,
                            list(txt=gsub("absolute", "", label)))
    } else if (grepl("relative", label)) {
        label <- substitute(bold(relative)*txt,
                            list(txt=gsub("relative", "", label)))
    } 
    tg <- textGrob(label, 
                   gp=gpar(col=col, fontface=face)) 
    grid.roundrect(width=grobWidth(tg) + unit(4, "mm"),
                   height=unit(1.5, "lines"),
                   r=unit(2, "mm"),
                   gp=gpar(col=fill, fill=fill, lwd=1),
                   name=name)
    grid.draw(editGrob(tg, gp=gpar(col="white")))
    grid.draw(tg)
    setLoc(name, 0)
    setLoc(name, 90)
    setLoc(name, 180)
    setLoc(name, 270)
}

arr <- function(end) {
    arrow(angle=30, length=unit(3, "mm"), type="closed", ends=end)
}

edge <- function(from, fromAngle, to, toAngle,
                 fromdx=0, todx=0, 
                 lty="solid", curv=1, inflect=FALSE, ends="last") {
    x <- unit.c(unit(getLoc(from, fromAngle, "x"), "in") +
                unit(fromdx, "mm"),
                unit(getLoc(to, toAngle, "x"), "in") +
                unit(todx, "mm"))
    y <- unit.c(unit(getLoc(from, fromAngle, "y"), "in"),
                unit(getLoc(to, toAngle, "y"), "in"))
    if (lty == "solid") {
        if (inflect) {
            grid.curve(unit(getLoc(from, fromAngle, "x"), "in") +
                       unit(fromdx, "mm"),
                       getLoc(from, fromAngle, "y"),
                       unit(getLoc(to, toAngle, "x"), "in") + unit(todx, "mm"),
                       getLoc(to, toAngle, "y"),
                       default.units="in",
                       curvature=curv,
                       inflect=inflect,
                       arrow=arr(ends),
                       gp=gpar(lty=lty, lwd=1, col=black, fill=black,
                               lineend="butt"))
        } else {
            grid.lines(x, y, default.units="in",
                       gp=gpar(lty=lty, lwd=1, col=black, fill=black,
                               lineend="butt"))
        }
    } else if (lty == "dashed") {
        grid.brushXspline(horizBrush, x, y, 
                          w=unit(1.5, "mm"),
                          spacing=unit(2, "mm"),
                          gp=gpar(col=black))
    } else if (lty == "dotted") {
        grid.brushXspline(circleBrush(), x, y, 
                          w=unit(.5, "mm"),
                          spacing=unit(1.5, "mm"),
                          gp=gpar(col=black))
    } else {
        stop("we should not be here")
    }
    if (!inflect && ends %in% c("last", "both")) {
        end <- trim(linesGrob(x, y), from=unit(-3, "mm"), to=1)
        grid.lines(end[[1]]$x, end[[1]]$y, default.units="in",
                   gp=gpar(col=black, fill=black), arrow=arr("last"))
    }
    if (!inflect && ends %in% c("first", "both")) {
        end <- trim(linesGrob(x, y), from=unit(3, "mm"), to=0)
        grid.lines(end[[1]]$x, end[[1]]$y, default.units="in",
                   gp=gpar(col=black, fill=black), arrow=arr("first"))
    }
}

