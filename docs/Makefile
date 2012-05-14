# Makefile for pandoc compiling
# v0.1

rapport : rapport.pdf
	evince rapport.pdf &

rapport.pdf: rapport.md
	pandoc --smart --normalize --standalone rapport.md -o rapport.pdf

