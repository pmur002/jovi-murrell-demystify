## -----------------------------------------------------------------------------
#| echo: FALSE
knitr::opts_chunk$set(
    dev="svg"
)


## -----------------------------------------------------------------------------
#| echo: FALSE
#| message: FALSE
library(knitr)
library(reshape2)
library(dplyr)
library(grid)
library(scales)
library(ggplot2)
library(gggrid)
library(colorspace)
library(bullseye)
library(geomtextpath)


## -----------------------------------------------------------------------------
#| echo: FALSE
#| message: FALSE
trade <- subset(read.csv("trade-years.csv"), !(year %in% c(2014, 2025)))
tradeTotals <- aggregate(trade["amount"],
                         list(year=trade$year, 
                              account=trade$account, 
                              category=trade$category),
                         sum)
goods2024 <- subset(trade, 
                      year == 2024 & category == "Goods" & 
                      country != "Total all countries")
goods2024wide <- dcast(goods2024, year + country ~ account)
top10export <- 
    goods2024wide[order(goods2024wide$Exports, decreasing=TRUE)[1:10], ]
top10export$country <- 
    recode_values(top10export$country,
                  "China, People's Republic of" ~ "China",
                  "United States of America" ~ "USA",
                  "United Kingdom" ~ "UK",
                  "Korea, Republic of" ~ "Korea",
                  default = as.character(top10export$country))
top10export$country <- reorder(top10export$country,
                               top10export$Exports,
                               max)
top10 <- melt(top10export, id.vars=c("year", "country"), 
              variable.name="account", value.name="amount")
top10$account <- factor(top10$account, levels=c("Imports", "Exports"))


## -----------------------------------------------------------------------------
#| label: fig-trade-bars
#| echo: FALSE
#| fig-keep: last
#| fig-cap: "A bar plot of international trade between New Zealand and its major partners in 2024."
ggBar <- function(data=top10) {
    ggplot(data) +
    geom_col(aes(amount, country, fill=account), position="dodge") +
    scale_x_continuous(expand=expansion(c(0, .05)),
                       breaks=1e9*seq(0, 15, 5),
                       labels=paste(seq(0, 15, 5), c("", "", "", "$billion"))) +
    scale_fill_discrete(name=NULL) +
    labs(title="Top 10 New Zealand Trade Partners in 2024", x=NULL, y=NULL) +
    theme(aspect.ratio=1, plot.margin=margin(0, 0, 0, 0),
          plot.background=element_blank(),
          panel.background=element_blank(),
          panel.grid.minor=element_blank(),
          panel.grid.major.y=element_blank(),
          panel.grid.major.x=element_line(colour="grey", linewidth=.1),
          axis.ticks=element_blank(),
          axis.text.x=element_text(hjust=0),
          legend.text=element_text(colour="black"))
}
margin <- unit(30, "mm")
grid.rect(gp=gpar(col="grey"))
pushViewport(viewport(width=unit(1, "npc") - margin,
                      height=unit(1, "npc") - margin,))
print(ggBar(), newpage=FALSE)
grid.force()
legend <- grid.get("guide-box-right", grep=TRUE)


## -----------------------------------------------------------------------------
#| label: fig-guide-myth
#| echo: FALSE
#| out-width: 4.1in
#| fig.cap: It is commonly agreed that the data symbols in a data visualisation arise from encoding information as the visual features of geometric shapes and the purpose of a guide is to allow us to decode that information. However, the mechanism by which the guide allows that decoding to happen is a little hazy.
include_graphics("Diagrams/guide-myth.svg")


## -----------------------------------------------------------------------------
#| label: fig-text-guide
#| echo: FALSE
#| out-width: 4.1in
#| fig.cap: The simplest sort of guide consists only of text labels, like the y-axis in @fig-trade-bars.  Data values are encoded as the shape of text labels just as data values are encoded as the visual features of data symbols. The difference is that absolute values can be decoded from text labels, whereas only relative values can be decoded from data symbols.  A value decoded from the text label is associated with a data symbol, and values decoded from the data symbol, through the proximity of the text label to the data symbol.
include_graphics("Diagrams/text-guide.svg")


## -----------------------------------------------------------------------------
#| label: fig-trade-bars-annotation
#| echo: FALSE
#| fig-keep: last
#| fig-cap: "A bar plot of international trade between New Zealand and its major partners in 2024 with an annotation indicating New Zealand's largest trading partner in 1924."
ann <- function(data, coords) {
    i <- which(data$y == 4)[2]
    lab <- textGrob("largest trade partner in 1924",
                    x=.5, y=.2, hjust=0,
                    gp=gpar(lineheight=.9))
    curve <- curveGrob(unit(.5, "npc") - unit(1, "mm"), .2, 
                       unit(coords$x[i], "npc") + unit(1, "mm"),
                       coords$y[i], inflect=TRUE,
                       curvature=-1,
                       arrow=arrow(angle=15, length=unit(2, "mm"), 
                                   type="closed"),
                       gp=gpar(fill="black"))
    grobTree(lab, curve)
}
ggAnn <- ggBar() +
    grid_panel(ann, aes(amount, country)) +
    coord_cartesian(clip="off")
grid.rect(gp=gpar(col="grey"))
pushViewport(viewport(width=unit(1, "npc") - margin,
                      height=unit(1, "npc") - margin,))
print(ggAnn, newpage=FALSE)
grid.force()
legend <- grid.get("guide-box-right", grep=TRUE)


## -----------------------------------------------------------------------------
#| label: fig-text-guide-annotation
#| echo: FALSE
#| out-width: 4.1in
#| fig.cap: The annotation in @fig-trade-bars-annotation works in a very similar way to the y-axis in @fig-trade-bars.  Information is encoded as the shape of text label and that information can be decoded from the text label.  This information is associated with information from the data symbols, and values decoded from the data symbols, through the *connection* that is created by the line between the text label and the data symbols for the United Kingdom.
include_graphics("Diagrams/text-guide-annotation.svg")


## -----------------------------------------------------------------------------
#| echo: FALSE
#| fig-width: 2
#| fig-height: 1
#| out-width: 25%
grid.newpage()
grid.draw(legend)


## -----------------------------------------------------------------------------
#| label: fig-text-geom-guide
#| echo: FALSE
#| out-width: 6.2in
#| fig.cap: A guide may contain geometric shapes as well as text labels, for example, the legend in @fig-trade-bars.  Data values are encoded as visual features of geometric shapes in the legend just like they are for data symbols. Values decoded from the shapes in a legend, or from text labels associated with those shapes, are associated with the values decoded from data symbols, through the similarity of the shapes in the legend and the shapes in the data symbols.
include_graphics("Diagrams/text-geom-guide.svg")


## -----------------------------------------------------------------------------
#| label: fig-trade-bars-legend
#| echo: FALSE
#| results: hide
#| fig.keep: last
#| fig.cap: The bar plot from @fig-trade-bars, but with a non-standard legend. The geometric shapes in this legend match the geometric shapes of the data symbols much more closely.
ggBarLegend <- ggBar() +
    coord_cartesian(clip="off") +
    theme(legend.text=element_text(colour="white"))
grid.newpage()
grid.rect(gp=gpar(col="grey"))
pushViewport(viewport(width=unit(1, "npc") - margin,
                      height=unit(1, "npc") - margin,
                      y=.55))
print(ggBarLegend, newpage=FALSE)
upViewport()
grid.force()
barsPath <- grid.grep("panel-1::geom_rect", grep=TRUE, viewports=TRUE)
bars <- grid.get(barsPath)
downViewport(attr(barsPath, "vpPath"))
barSize <- convertHeight(bars$height[1], "in")
barGap <- convertHeight(bars$y[1] - bars$y[2], "in")
## Old legend
keyPaths <- grid.grep("guides::layout::key::gTree::rect", 
                      grep=TRUE, global=TRUE)
sapply(keyPaths, grid.edit, gp=gpar(fill=NA))
## New legend
cols <- pal_hue()(2)
edge <- 1
newLegend <- function(gap=.7) {
    x <- unit(0, "npc")
    y <- unit(0, "npc") - unit(gap, "in") + unit(edge, "mm") + bars$height[1]
    accountText <- textGrob(rev(levels(top10$account)),
                         unit(-1.5, "mm"),
                         y + c(.6, -.6)*barSize,
                         hjust=1,
                         gp=gpar(fontsize=8, col="#4D4D4DFF"))
    grid.draw(accountText)
    grid.segments(x, 
                  y + barSize + unit(edge, "mm"),
                  x,
                  y - barSize - unit(edge, "mm"),
                  gp=gpar(col="grey"))
    grid.segments(x, 
                  y,
                  x - unit(1, "mm"),
                  y,
                  gp=gpar(col="grey"))
    grid.rect(x, y,
              width=2*barSize,
              height=rep(barSize, 2),
              hjust=0,
              vjust=1:0,
              gp=gpar(col=NA, fill=cols))
}
newLegend()


## -----------------------------------------------------------------------------
#| label: fig-trade-bars-direct
#| echo: FALSE
#| fig.keep: last
#| results: hide
#| fig.cap: The bar plot from @fig-trade-bars, but instead of a legend, direct labelling is used to explain the encoding of trade account by placing text labels adjacent to the associated data symbols (proximity), plus colour to associate with other data symbols (similarity).
directLabel1 <- function(prefix="  ") {
    annotate("text", label=paste0(prefix, "Exports"), 
             size=8, size.unit="pt", fontface="bold",
             x=top10$amount[top10$country == "China" & 
                            top10$account == "Exports"], 
             y="China", hjust=0, vjust=-.5, colour=cols[2])
}
directLabel2 <- function(prefix="  ") {
    annotate("text", label=paste0(prefix, "Imports"), 
             size=8, size.unit="pt", fontface="bold",
             x=top10$amount[top10$country == "China" & 
                            top10$account == "Imports"], 
             y="China", hjust=0, vjust=1.5, colour=cols[1])
}
ggBarLegend <- ggBar() +
    coord_cartesian(clip="off") +
    theme(legend.text=element_text(colour="white")) +
    directLabel1() + directLabel2()
grid.newpage()
grid.rect(gp=gpar(col="grey"))
pushViewport(viewport(width=unit(1, "npc") - margin,
                      height=unit(1, "npc") - margin,
                      y=.5))
print(ggBarLegend, newpage=FALSE)
upViewport()
grid.force()
## Old legend
keyPaths <- grid.grep("guides::layout::key::gTree::rect", 
                      grep=TRUE, global=TRUE)
sapply(keyPaths, grid.edit, gp=gpar(fill=NA), redraw=FALSE)
grid.refresh()


## -----------------------------------------------------------------------------
#| label: fig-trade-bars-x-axis
#| echo: FALSE
#| fig.keep: last
#| results: hide
#| fig.cap: The bar plot from @fig-trade-bars, but with a non-standard x-axis that explains the encoding of trade amount using the lengths of bars.  The geometric shapes in this axis provide a better match of the encoding used for the data symbols.
exemplars <- seq(5, 15, 5)
xaxis <- function(data, coords) {
    y <- unit(-1, "mm") - barSize - (0:2)*(barGap - barSize)
    grobTree(rectGrob(0, y, width=coords$x, height=barSize, 
                      hjust=0, vjust=.5,
                      gp=gpar(col=NA, fill="grey80")),
             textGrob(paste(unique(data$label), c("", "", "$billion")),
                      unit(unique(coords$x), "npc") + unit(1, "mm"), 
                      y, just="left",
                      gp=gpar(fontsize=8)))
}
ggBarAxis <- ggBar() +
    coord_cartesian(clip="off") +
    theme(legend.text=element_text(colour="white"),
          ## Old axis
          panel.grid.major.x=element_blank(),
          axis.ticks.x=element_line(colour=NA),
          axis.text.x=element_text(colour=NA),
          axis.title.x=element_text(colour=NA)) +
    directLabel1() + directLabel2() +
    ## New axis
    grid_panel(xaxis, aes(amount, label=label), 
               data=data.frame(amount=1e9*exemplars, label=exemplars))
grid.newpage()
grid.rect(gp=gpar(col="grey"))
pushViewport(viewport(width=unit(1, "npc") - margin,
                      height=unit(1, "npc") - margin,
                      y=.55))
print(ggBarAxis, newpage=FALSE)
upViewport()
grid.force()
barsPath <- grid.grep("panel-1::geom_rect", grep=TRUE, viewports=TRUE)
bars <- grid.get(barsPath)
downViewport(attr(barsPath, "vpPath"))
## Old legend
keyPaths <- grid.grep("guides::layout::key::gTree::rect", 
                      grep=TRUE, global=TRUE)
sapply(keyPaths, grid.edit, gp=gpar(fill=NA), redraw=FALSE)
grid.refresh()


## -----------------------------------------------------------------------------
#| label: fig-trade-bars-x-axis-embedded
#| echo: FALSE
#| fig.keep: last
#| results: hide
#| message: FALSE
#| fig.cap: The bar plot from @fig-trade-bars-x-axis, but with the x-axis is embedded alongside the data symbols to make length comparisons easier and more accurate.
top10xaxis <- rbind(top10, 
                    data.frame(year=2024, 
                               country=as.character(exemplars),
                               account=rep(c("Exports", "Imports"), 3),
                               amount=1e9*exemplars))
top10xaxisWide <- dcast(top10xaxis, year + country ~ account)
top10xaxisWide <- 
    top10xaxisWide[order(top10xaxisWide$Exports, decreasing=TRUE), ]
top10xaxisWide$country <- factor(top10xaxisWide$country,
                                 levels=rev(top10xaxisWide$country))
top10xaxis <- melt(top10xaxisWide, id.vars=c("year", "country"), 
                   variable.name="account", value.name="amount")
top10xaxis$amount[top10xaxis$country %in% as.character(exemplars)] <- 0
internalBars <- function(data, coords) {
    grobTree(rectGrob(0, coords$y, width=coords$x, height=barSize2, 
                      hjust=0, vjust=c(.5, 0, 1),
                      gp=gpar(col=NA, fill="grey80")),
             textGrob(paste(unique(data$label), c("", "", "$billion")),
                      unit(unique(coords$x), "npc") + unit(1, "mm"), 
                      unique(coords$y), hjust=0, vjust=c(.5, 0, 1),
                      gp=gpar(fontsize=8)))             
}
ggBarAxis2 <- ggBar(top10xaxis) +
    coord_cartesian(clip="off") +
    geom_col(aes(amount, country, fill=account), position="dodge") +
    scale_y_discrete(labels=function(x) {
                                x[x %in% as.character(exemplars)] <- ""
                                x
                            }) +
    theme(legend.text=element_text(colour="white"),
          ## Old axis
          panel.grid.major.x=element_blank(),
          axis.ticks.x=element_line(colour=NA),
          axis.text.x=element_text(colour=NA),
          axis.title.x=element_text(colour=NA)) +
    directLabel1() + directLabel2() +
    ## New grid lines
    grid_panel(internalBars, aes(amount, label, label=label),
               data=data.frame(label=as.character(exemplars),
                               amount=1e9*exemplars)) +
    ## Give some more height to allow for "axis" bars
    theme(aspect.ratio=1.3)
## Draw once to get new 'barSize'
barSize2 <- barSize
grid.newpage()
pushViewport(viewport(width=unit(1, "npc") - margin + unit(10, "mm"),
                      height=unit(1, "npc") - margin + unit(10, "mm"),
                      y=.5))
print(ggBarAxis2, newpage=FALSE)
upViewport()
grid.force()
barsPath <- grid.grep("panel-1::geom_rect", grep=TRUE, viewports=TRUE)
bars <- grid.get(barsPath)
downViewport(attr(barsPath, "vpPath"))
barSize2 <- convertHeight(bars$height[1], "in")
## Draw again with added bars
grid.newpage()
grid.rect(gp=gpar(col="grey"))
pushViewport(viewport(width=unit(1, "npc") - margin + unit(10, "mm"),
                      height=unit(1, "npc") - margin + unit(10, "mm"),
                      y=.5))
print(ggBarAxis2, newpage=FALSE)
upViewport()
grid.force()
## Old legend
keyPaths <- grid.grep("guides::layout::key::gTree::rect", 
                      grep=TRUE, global=TRUE)
sapply(keyPaths, grid.edit, gp=gpar(fill=NA), redraw=FALSE)
grid.refresh()


## -----------------------------------------------------------------------------
#| label: fig-trade-bars-x-axis-direct
#| echo: FALSE
#| fig.keep: last
#| results: hide
#| fig.cap: The bar plot from @fig-trade-bars, but instead of an x-axis, direct labelling explains the encoding of trade amounts by placing labels adjacent to the associated data symbols (proximity).
ggBarAxisDirect <- ggBar() +
    geom_text(aes(amount, country, 
                  label=ifelse(amount/1e9 < 10, 
                               sprintf(" %.1f", amount/1e9), 
                               sprintf(" %.0f", amount/1e9))),
              vjust=rep(c(-.5, 1.5), each=nrow(top10)/2), hjust=0,
              size=8, size.unit="pt") +
    coord_cartesian(clip="off") +
    theme(legend.text=element_text(colour="white"),
          panel.grid.major.x=element_blank(),
          axis.text.x=element_text(colour="white"),
          axis.title.x=element_text(vjust=-1)) +
    directLabel1("        ") + directLabel2("        ")
grid.newpage()
grid.rect(gp=gpar(col="grey"))
pushViewport(viewport(width=unit(1, "npc") - margin,
                      height=unit(1, "npc") - margin,
                      y=.5))
print(ggBarAxisDirect, newpage=FALSE)
upViewport()
grid.force()
## Old legend
keyPaths <- grid.grep("guides::layout::key::gTree::rect", 
                      grep=TRUE, global=TRUE)
sapply(keyPaths, grid.edit, gp=gpar(fill=NA), redraw=FALSE)
grid.refresh()
dev.off()


## -----------------------------------------------------------------------------
#| label: fig-corr-mats-penguin
#| echo: FALSE
#| fig.keep: last
#| results: hide
#| message: FALSE
#| fig.cap: Correlations between variables that record physical dimensions, sex, and location of the Palmer Penguins.
vars <- c("bill_dep", "bill_len", "flipper_len", "body_mass", "sex", "island")
labels <- c(bill_dep="bill\ndepth", 
            bill_len="bill\nlength",
            flipper_len="flipper\nlength",
            body_mass="body\nmass",
            sex="sex",
            island="island")
pens <- subset(penguins, !is.na(bill_len) & !is.na(sex), select=vars)
cor <- pairwise_scores(pens)
df <- subset(cor, select=c(x, y, group, value))
df2 <- df; tmp <- df2$x; df2$x <- df2$y; df2$y <- tmp
dfPenguin <- rbind(df, df2,
                   data.frame(x=vars, y=vars, group="all", value=1))
dfPenguin$x <- factor(dfPenguin$x, levels=vars[1:6])
dfPenguin$y <- factor(dfPenguin$y, levels=vars[1:6])
dotR <- unit(6, "mm")
dot <- function(data, coords) {
    sub <- data$x <= data$y
    coords <- coords[sub,]
    data <- data[sub,]
    grobTree(textGrob(labels[data$label], coords$x, coords$y, 
                      gp=gpar(fontsize=10, lineheight=.9,
                              col=ifelse(coords$cor == 1,
                                         "black", NA))),
             circleGrob(coords$x, coords$y, r=dotR, 
                        gp=gpar(col=ifelse(coords$cor == 1,
                                           NA, "white"),
                                fill=ifelse(coords$cor == 1,
                                            NA, coords$fill))))
}
title <- function(data, coords) {
    x <- unit(sort(unique(coords$x))[1], "npc") - dotR
    y1 <- unit(1, "npc") + unit(1, "lines")
    grobTree(textGrob("Palmer Penguins", x, y1, just=c("left", "bottom"),
                      gp=gpar(fontsize=14)))
}
ggPenguin <- ggplot(dfPenguin) +
    grid_panel(dot, aes(x, y, fill=value, cor=value, label=x),
               show.legend=TRUE) +
    grid_panel(title, aes(x, y)) +
    scale_fill_continuous_diverging(palette="Blue-Red", limits=c(-1, 1), 
                                    rev=TRUE,
                                    name="correlation") +
    coord_cartesian(clip="off") +
    ggtitle("Palmer Penguins") +
    theme(panel.background=element_blank(),
          ## Space for title, drawn via grid_panel() for alignment
          plot.title=element_text(colour=NA),
          plot.subtitle=element_text(colour=NA),
          axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks=element_blank(),
          aspect.ratio=1,
          legend.position="right")
grid.newpage()
grid.rect(gp=gpar(col="grey"))
pushViewport(viewport(width=unit(1, "npc") - margin,
                      height=unit(1, "npc") - margin))
print(ggPenguin, newpage=FALSE)


## -----------------------------------------------------------------------------
#| label: fig-corr-mats-penguin-geom
#| echo : FALSE
#| fig.keep: last
#| results: hide
#| message: FALSE
#| fig.cap: The correlation matrix from @fig-corr-mats-penguin, but a novel legend explains the encoding of correlation using circles that match the data symbols.
cols <- diverging_hcl(5, palette="Blue-Red", rev=TRUE)
textlab <- round(seq(-1, 1, length.out=5), 2)
legendDot <- function(y, i) {
    grobTree(circleGrob(x=dotR, y=y, r=dotR, 
                        gp=gpar(col="white", fill=cols[i])),
             textGrob(sprintf("%4.1f", textlab[i]), 
                      x=2*dotR + unit(1, "mm"), y=y, just="left",
                      gp=gpar(col="black", fontsize=10)))
}
fiddle <- unit(10, "mm")
dotLegend <- function(data, coords) {
    vp <- viewport(x=unit(1, "npc") + fiddle, just="left")
    y <- sort(unique(coords$y))
    y <- y[2:6]
    dots <- do.call(grobTree, mapply(legendDot, y, 1:5, SIMPLIFY=FALSE))
    grobTree(dots,
             textGrob("correlation", x=0, y=1, 
                      just=c("left", "bottom"),
                      gp=gpar(fontsize=10)),
             vp=vp)
}
ggPenguinLegend <- ggPenguin +
    grid_panel(dotLegend, aes(x, y)) +
    coord_cartesian(clip="off")
grid.newpage()
grid.rect(gp=gpar(col="grey"))
pushViewport(viewport(y=.5,
                      width=unit(1, "npc") - margin,
                      height=unit(1, "npc") - margin))
print(ggPenguinLegend, newpage=FALSE)
grid.force()
## Remove legend
grid.remove("guide-box-right", grep=TRUE)


## -----------------------------------------------------------------------------
#| label: fig-text-standalone
#| echo: FALSE
#| out-width: 2.1in
#| fig.cap: A guide may consist only of text labels and need no association with data symbols, for example, the title in @fig-trade-bars.  In this case, the value of the guide comes directly from being able to decode absolute information (about the data visualisation as a whole) from the text label.
include_graphics("Diagrams/text-standalone.svg")


## -----------------------------------------------------------------------------
#| label: fig-pinker
#| echo: FALSE
#| out-width: 100%
#| fig.cap: A theory of graph comprehension adapted from Figure 19.2 of @wilkinson2005grammar, which was adapted from Figure 4.20 of @Pinker1990ATO.  This adaptation includes the original "message flags" from @Pinker1990ATO.
include_graphics("Pinker/pinker.svg")

