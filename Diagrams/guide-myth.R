
source("common.R")

guide.myth <- function() {
    
guidecols <- 3:4
datacols <- 1:2

grid.newpage()

## Overall size
pushViewport(viewport(width=unit(4, "in")))

## Layout
pushViewport(viewport(layout=grid.layout(3, 4,
                                         widths=c(5,1,1,5),
                                         heights=unit(3:2, "lines"))))
## Backgrounds
pushViewport(viewport(layout.pos.col=guidecols, layout.pos.row=1))
grid.text("guide", x=unit(1, "npc") + unit(0, "mm"), hjust=1,
          y=unit(1, "npc") + unit(.5, "lines"), 
          gp=gpar(col=adjustcolor(guidecol, alpha=.7), fontface="bold"))
popViewport()
pushViewport(viewport(layout.pos.col=guidecols, layout.pos.row=1:3))
grid.rect(gp=gpar(col=NA, fill=adjustcolor(guidecol, alpha=.7)))
popViewport()
pushViewport(viewport(layout.pos.col=datacols, layout.pos.row=1))
grid.rect(gp=gpar(col=NA, fill=adjustcolor(datacol, alpha=.7)))
grid.text("data symbols", x=unit(0, "mm"), hjust=0,
          y=unit(1, "npc") + unit(1, "mm"), vjust=0,
          gp=gpar(col=adjustcolor(datacol, alpha=.7), fontface="bold"))
popViewport()
pushViewport(viewport(layout.pos.col=datacols, layout.pos.row=2:3))
grid.rect(gp=gpar(col=NA, fill=adjustcolor(datacol, alpha=.5)))
popViewport()

## Nodes
pushViewport(viewport(layout.pos.col=datacols[1], layout.pos.row=1))
node("data value 2", label="data value")
popViewport()
pushViewport(viewport(layout.pos.col=datacols[1], layout.pos.row=2))
grid.text(" encode", y=unit(1, "npc") - unit(1, "lines"), hjust=0,
          gp=gpar(fontsize=10))
popViewport()
pushViewport(viewport(layout.pos.col=datacols[1], layout.pos.row=3))
node("geom feature")
popViewport()
pushViewport(viewport(layout.pos.col=guidecols[2], layout.pos.row=2))
grid.text("decode  ", y=unit(1, "npc") - unit(1, "lines"), hjust=1,
          gp=gpar(fontsize=10))
popViewport()

## Layout
popViewport()

## Overall size
popViewport()

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
grid.bezier(x, y, gp=gpar(fill=black, lwd=1, lty="dashed"))

}
