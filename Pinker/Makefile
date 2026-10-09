
.PHONY: dot
dot:
	# SVG
	dot -T svg -o pinker.svg pinker.dot 

.PHONY: tex
tex:
	# PDF
	lualatex pinker.tex
	# PNG
	convert -density 100 pinker.pdf pinker.png
	# SVG
	pdf2svg pinker.pdf pinker.svg
	# lualatex --output-format=dvi pinker.tex
	# dvisvgm pinker.dvi
