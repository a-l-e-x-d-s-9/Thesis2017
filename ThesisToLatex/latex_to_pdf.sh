#!/usr/bin/env bash
#set -e

ARG_1=$1

#mkdir output_flatex
#pdflatex -output-directory=output_flatex -output-format=pdf ${LATEX_FILE}

#mkdir output_rubber
#cd output_rubber
#rubber --pdf ../${LATEX_FILE}
#cd -

if [ "$ARG_1" = "adapt" ]
then
  ../Source/adapt_to_latex.sh ../Source/Thesis_trunk_to_latex.txt Thesis-Main.tex Thesis-FrontMatter.tex Thesis-Appendices.tex
fi

#mkdir output_pdftex
#pdftex -output-directory=output_pdftex -output-format=pdf -interaction=nonstopmode ${LATEX_FILE}
rm Thesis.pdf
rm Thesis.out
#rm Thesis.aux
#rm Thesis.toc
#rm Thesis.log
#rm Thesis.blg
#rm Thesis.bbl
#wait ${!}


bibtex Thesis
wait ${!}
xelatex Thesis.tex
wait ${!}
evince Thesis.pdf &>/dev/null
