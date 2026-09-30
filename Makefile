
all:
	Rscript -e 'quarto::quarto_render("index.qmd")'
	Rscript -e 'knitr::purl("index.qmd")'
