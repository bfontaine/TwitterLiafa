# Makefile for pandoc compiling
# v0.1

PANDOC_OPTS=--smart --normalize --standalone

rapport : rapport.pdf
	evince rapport.pdf &

rapport.md:
	# to prevent circular dependencies

rapport.pdf: rapport.tex
	sed 's/G\\_\(RT\|f\|0\)/$$G_{\1}$$/g' $< | sponge $<
	pdflatex $<

rapport.%: rapport.md
	pandoc ${PANDOC_OPTS} $< -o $@

clean:
	for e in aux dvi log out pdf tex;do rm -f rapport.$$e;done
	rm -f *~
