
source("common.R")

text.standalone <- function() {
    
grid.newpage()

## Overall size
pushViewport(viewport(width=unit(2, "in")))

## Layout
pushViewport(viewport(layout=grid.layout(5, 1,
                                         widths=c(5,1,1,5),
                                         heights=unit(3:2, "lines"))))
## Backgrounds
pushViewport(viewport(layout.pos.row=1))
grid.rect(gp=gpar(col=NA, fill=adjustcolor(guidecol, alpha=.7)))
grid.text("guide", x=unit(1, "npc") + unit(0, "mm"), hjust=1,
          y=unit(1, "npc") + unit(.5, "lines"), 
          gp=gpar(col=adjustcolor(guidecol, alpha=.7), fontface="bold"))
popViewport()
pushViewport(viewport(layout.pos.row=2:3))
grid.rect(gp=gpar(col=NA, fill=adjustcolor(guidecol, alpha=.5)))
popViewport()
pushViewport(viewport(layout.pos.row=4:5))
grid.rect(gp=gpar(col=NA, fill=adjustcolor(guidecol, alpha=.3)))
popViewport()

## Nodes
pushViewport(viewport(layout.pos.row=1))
node("data value", label="data value")
popViewport()
pushViewport(viewport(layout.pos.row=2))
grid.text("encode ", y=unit(1, "npc") - unit(1, "lines"), hjust=1,
          gp=gpar(fontsize=10))
popViewport()
pushViewport(viewport(layout.pos.row=3))
node("text shape")
popViewport()
pushViewport(viewport(layout.pos.row=4))
grid.text("decode ", y=unit(1, "npc") - unit(1, "lines"), hjust=1,
          gp=gpar(fontsize=10))
popViewport()
pushViewport(viewport(layout.pos.row=5))
node("absolute value")
popViewport()

## Layout
popViewport()

## Overall size
popViewport()

## Edges
edge("data value", 270, "text shape", 90)
edge("text shape", 270, "absolute value", 90, lty="dashed")

}
