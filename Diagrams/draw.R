
source("guide-myth.R")
svg("guide-myth.svg", width=4.1, height=2)
guide.myth()
dev.off()

source("text-guide.R")
svg("text-guide.svg", width=4.1, height=3)
text.guide()
dev.off()

source("text-guide-annotation.R")
svg("text-guide-annotation.svg", width=4.1, height=3)
text.guide.annotation()
dev.off()

source("text-geom-guide.R")
svg("text-geom-guide.svg", width=6.2, height=3)
text.geom.guide()
dev.off()

source("text-standalone.R")
svg("text-standalone.svg", width=2.1, height=3)
text.standalone()
dev.off()

