
## Run after text-guide.R has been source()ed

source("common.R")

text.guide.annotation <- function() {
    text.guide()
    grid.set("gestalt",
             textGrob("connection", y=unit(.5, "npc") + unit(-1, "mm"), vjust=1,
                      gp=gpar(fontsize=10), name="gestalt"))
}

