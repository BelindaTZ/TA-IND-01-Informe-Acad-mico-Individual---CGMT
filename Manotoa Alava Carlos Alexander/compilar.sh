#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
mkdir -p .compilacion
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=.compilacion main.tex
biber --input-directory=.compilacion --output-directory=.compilacion main
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=.compilacion main.tex
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=.compilacion main.tex
cp -- .compilacion/main.pdf main.pdf
printf 'PDF generado: main.pdf\n'
