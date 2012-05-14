# Makefile for pandoc compiling
# v0.1

PANDOC_OPTS=--smart --normalize --standalone

rapport : rapport.pdf
	evince rapport.pdf &

rapport.md:
	# to prevent circular dependencies

rapport.%: rapport.md
	pandoc ${PANDOC_OPTS} $< -o $@
