
source("common.R")

guide.myth <- function() {
    
    guidecols <- 3:4
    datacols <- 1:2

    grid.newpage()

    ## Overall size
    pushViewport(viewport(width=unit(4, "in"),
                          name="topvp"))

    ## Layout
    pushViewport(viewport(layout=grid.layout(3, 4,
                                             widths=c(5,1,1,5),
                                             heights=unit(3:2, "lines")),
                          name="layvp"))
    ## Backgrounds
    pushViewport(viewport(layout.pos.col=guidecols, layout.pos.row=1))
    grid.text("guide", x=unit(1, "npc") + unit(0, "mm"), hjust=1,
              y=unit(1, "npc") + unit(.5, "lines"), 
              gp=gpar(col=adjustcolor(guidecol, alpha=.7), fontface="bold"))
    upViewport()
    pushViewport(viewport(layout.pos.col=guidecols, layout.pos.row=1:3,
                          name="guidevp"))
    grid.rect(gp=gpar(col=NA, fill=NA), name="guidebg")
    setLoc("guidebg", 0)
    setLoc("guidebg", 90)
    setLoc("guidebg", 180)
    setLoc("guidebg", 270)
    fill <- radialGradient(c(adjustcolor(guidecol, alpha=.1),
                             adjustcolor(guidecol, alpha=.7)),
                           r1=.2)
    fillGrob <-
        rectGrob(gp=gpar(col=NA, fill=fill))
    pushViewport(viewport(width=unit(1, "snpc")))
    grid.define(fillGrob, name="fill")
    upViewport()
    grid.use("fill")
    upViewport()
    pushViewport(viewport(layout.pos.col=datacols, layout.pos.row=1:3,
                          name="datavp"))
    grid.rect(gp=gpar(col=NA, fill=NA), name="databg")
    setLoc("databg", 0)
    setLoc("databg", 90)
    setLoc("databg", 180)
    setLoc("databg", 270)
    upViewport()
    pushViewport(viewport(layout.pos.col=datacols, layout.pos.row=1))
    grid.rect(gp=gpar(col=NA, fill=adjustcolor(datacol, alpha=.7)))
    grid.text("data symbols", x=unit(0, "mm"), hjust=0,
              y=unit(1, "npc") + unit(1, "mm"), vjust=0,
              gp=gpar(col=adjustcolor(datacol, alpha=.7), fontface="bold"))
    upViewport()
    pushViewport(viewport(layout.pos.col=datacols, layout.pos.row=2:3))
    grid.rect(gp=gpar(col=NA, fill=adjustcolor(datacol, alpha=.5)))
    upViewport()

    ## Nodes
    pushViewport(viewport(layout.pos.col=datacols[1], layout.pos.row=1))
    node("data value 2", label="data value")
    upViewport()
    pushViewport(viewport(layout.pos.col=datacols[1], layout.pos.row=2))
    grid.text(" encode", y=unit(1, "npc") - unit(1, "lines"), hjust=0,
              gp=gpar(fontsize=10))
    upViewport()
    pushViewport(viewport(layout.pos.col=datacols[1], layout.pos.row=3))
    node("geom feature")
    upViewport()
    pushViewport(viewport(layout.pos.col=guidecols, layout.pos.row=2))
    grid.text("decode", y=unit(1, "npc") - unit(1, "lines"), hjust=.5,
              gp=gpar(fontsize=10))
    upViewport()

    ## Layout
    upViewport()

    ## Overall size
    upViewport()

    ## Edges
    edge("data value 2", 270, "geom feature", 90)
    x <- unit.c(unit(getLoc("geom feature", 0, "x"), "in"),
                unit(getLoc("geom feature", 0, "x"), "in") +
                unit(2.5, "in"),
                unit(getLoc("data value 2", 0, "x"), "in") +
                unit(2.5, "in"),
                unit(getLoc("data value 2", 0, "x"), "in"))
    y <- unit.c(unit(getLoc("geom feature", 0, "y"), "in"),
                unit(getLoc("geom feature", 0, "y"), "in"),
                unit(getLoc("data value 2", 0, "y"), "in"),
                unit(getLoc("data value 2", 0, "y"), "in"))
    grid.segments(unit(getLoc("data value 2", 0, "x"), "in") +
                  unit(3, "mm"),
                  unit(getLoc("data value 2", 0, "y"), "in"),
                  unit(getLoc("data value 2", 0, "x"), "in"),
                  unit(getLoc("data value 2", 0, "y"), "in"),
                  gp=gpar(fill=black, lwd=1, lty="solid"),
                  arrow=arr("last"))
    maskfill <- radialGradient(c(adjustcolor(guidecol, alpha=0),
                                 adjustcolor(guidecol, alpha=.7)),
                               r1=.2)
    mask <- grobTree(rectGrob(getLoc("databg", 180, "x"),
                              getLoc("databg", 270, "y"),
                              getLoc("databg", 0, "x") - 
                              getLoc("databg", 180, "x"),
                              getLoc("databg", 90, "y") -
                              getLoc("databg", 270, "y"),
                              default.units="in",
                              just=c("left", "bottom"),
                              gp=gpar(fill=datacol)),
                     rectGrob(getLoc("guidebg", 180, "x"),
                              getLoc("guidebg", 270, "y"),
                              getLoc("guidebg", 0, "x") - 
                              getLoc("guidebg", 180, "x"),
                              getLoc("guidebg", 90, "y") -
                              getLoc("guidebg", 270, "y"),
                              default.units="in",
                              just=c("left", "bottom"),
                              gp=gpar(fill=maskfill)))
    pushViewport(viewport(mask=mask))
    grid.bezier(x, y, gp=gpar(fill=black, lwd=1, lty="dashed"))
    upViewport()
}
