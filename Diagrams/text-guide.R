
source("common.R")

svg("text-guide.svg", width=4.1, height=3)

guidecols <- 3:4
datacols <- 1:2

grid.newpage()

## Overall size
pushViewport(viewport(width=unit(4, "in")))

## Layout
pushViewport(viewport(layout=grid.layout(5, 4,
                                         widths=c(5,1,1,5),
                                         heights=unit(3:2, "lines"))))
## Backgrounds
pushViewport(viewport(layout.pos.col=guidecols, layout.pos.row=1))
grid.rect(gp=gpar(col=NA, fill=adjustcolor(guidecol, alpha=.7)))
grid.text("guide", x=unit(1, "npc") + unit(0, "mm"), hjust=1,
          y=unit(1, "npc") + unit(.5, "lines"), 
          gp=gpar(col=adjustcolor(guidecol, alpha=.7), fontface="bold"))
popViewport()
pushViewport(viewport(layout.pos.col=guidecols, layout.pos.row=2:3))
grid.rect(gp=gpar(col=NA, fill=adjustcolor(guidecol, alpha=.5)))
popViewport()
pushViewport(viewport(layout.pos.col=guidecols, layout.pos.row=4:5))
grid.rect(gp=gpar(col=NA, fill=adjustcolor(guidecol, alpha=.3)))
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
pushViewport(viewport(layout.pos.col=datacols, layout.pos.row=4:5))
grid.rect(gp=gpar(col=NA, fill=adjustcolor(datacol, alpha=.3)))
popViewport()

## Nodes
pushViewport(viewport(layout.pos.col=guidecols[2], layout.pos.row=1))
node("data value")
popViewport()
pushViewport(viewport(layout.pos.col=guidecols[2], layout.pos.row=2))
grid.text("encode ", y=unit(1, "npc") - unit(1, "lines"), hjust=1,
          gp=gpar(fontsize=10))
popViewport()
pushViewport(viewport(layout.pos.col=datacols[1], layout.pos.row=1))
node("data value 2", label="data value")
popViewport()
pushViewport(viewport(layout.pos.col=datacols[1], layout.pos.row=2))
grid.text(" encode", y=unit(1, "npc") - unit(1, "lines"), hjust=0,
          gp=gpar(fontsize=10))
popViewport()
pushViewport(viewport(layout.pos.col=guidecols[2], layout.pos.row=3))
node("text shape")
popViewport()
pushViewport(viewport(layout.pos.col=guidecols[2], layout.pos.row=4))
grid.text("decode ", y=unit(1, "npc") - unit(1, "lines"), hjust=1,
          gp=gpar(fontsize=10))
popViewport()
pushViewport(viewport(layout.pos.col=datacols[1], layout.pos.row=3))
node("geom feature")
popViewport()
pushViewport(viewport(layout.pos.col=datacols[1], layout.pos.row=4))
grid.text(" decode", y=unit(1, "npc") - unit(1, "lines"), hjust=0,
          gp=gpar(fontsize=10))
popViewport()
pushViewport(viewport(layout.pos.col=guidecols[2], layout.pos.row=5))
node("absolute value")
popViewport()
pushViewport(viewport(layout.pos.col=datacols[1], layout.pos.row=5))
node("relative value")
popViewport()
pushViewport(viewport(layout.pos.col=2:3, layout.pos.row=5))
grid.text("proximity", y=unit(.5, "npc") + unit(-1, "mm"), vjust=1,
          gp=gpar(fontsize=10))
popViewport()

## Layout
popViewport()

## Overall size
popViewport()

## Edges
edge("data value", 270, "text shape", 90)
edge("data value 2", 270, "geom feature", 90)
edge("text shape", 270, "absolute value", 90, lty="dashed")
edge("geom feature", 270, "relative value", 90, lty="dashed")
edge("absolute value", 180, "relative value", 0, ends="both", lty="dotted")

dev.off()
