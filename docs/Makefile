# Makefile for pandoc compiling
# v0.1

PANDOC_OPTS=--smart --normalize --standalone

rapport : rapport.pdf
	evince rapport.pdf &

rapport.md:
	# to prevent circular dependencies

rapport.pdf: rapport.tex
	pdflatex $<

rapport.tex: _rapport.tex
	sed 's/G\\_\(RT\|f\|0\)/$$G_{\1}$$/g' $< > $@

_rapport.tex: rapport.md
	pandoc ${PANDOC_OPTS} $< -o $@

rapport.%: rapport.md
	pandoc ${PANDOC_OPTS} $< -o $@

clean:
	for e in aux log out toc;do rm -f *.$$e;done
	rm -f *~
	rm -f _rapport.tex
	rm -f rapport.dvi

cleanall:
	for e in tex pdf;do rm -f rapport.$$e;done
