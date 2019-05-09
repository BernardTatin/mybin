#!/bin/sh

. $(dirname $0)/base.inc.sh

# generic configuration
debug=0
mdfiles=
css=${here}/pbook-styles/default.css

# can be:
# - website: same directory tree but with html instead of md files
# - book:    combination of all md input files in one PDF made through wkhtmltopdf, using CSS
# - article: combination of all md input files in one PDF made through LaTeX
output_type=

# book configuration
makebook=0
bookname=
tmpmd=

# website configuration
startdir=.
website=./fulldoc
doclear=0

rm -f ${tmpmd}

dohelp() {
    ecode=0
    if [ $# -ne 0 ]
    then
        ecode=$1
        shift
        show_error "$@"
    fi
    cat << DOHELP
${script} -h|--help: this text
${script} article article-name.pdf FILES.md...: make a PDF book with all FILES.md
${script} book book-name.pdf [--css cssfile] FILES.md...: make a PDF book with all FILES.md
OPTIONS:
    --css css-file: css used, default ${css}
${script} website [--startdir dir] [--website dir] [--css cssfile] [--doclear]: convert all markdown files of current dir to HTML in the website dir
OPTIONS:
    --startdir dir: source dir of Markdown files, default ${startdir}
    --website dir: destination dir of PDF files, default ${website}
    --css css-file: css used, default ${css}
    --doclear: erase previous website, default false
DOHELP
    exit ${ecode}
}

show_config() {
    [ ${debug} -eq 1 ] && \
        echo '============================================='
        echo "here:         $here" && \
        echo "script:       $script" && \
        echo "startdir:     $startdir" && \
        echo "website:      $website" && \
        echo "css:          $css" && \
        echo "doclear:      $doclear" && \
        echo "mdfiles:      $mdfiles" && \
        echo "bookname:     $bookname" && \
        echo '============================================='
}

prepare_book() {
  [ -z "$bookname" ] && \
    dohelp ${FAILURE} "you need a book file name"
  tmpmd=$(dirname $bookname)/$(basename $bookname .pdf).md
  rm -f ${tmpmd}
  while [ $# -gt 0 ]; do
    cat $1 >> ${tmpmd}
    echo >> ${tmpmd}
    shift
  done
}

book() {
  echo "book $*"
  bookname=$1
  shift
  case $1 in
    --css)
      shift
      [ $# -eq 0 ] && dohelp ${FAILURE} "$1 must be followed by a css name"
      css="$1"
      shift
      ;;
    *)
      ;;
  esac
  [ $# -eq 0 ] && dohelp ${FAILURE} "a book needs markdown files in input"
  prepare_book "$@"
  pandoc --standalone \
      --toc \
      --reference-links \
      --number-sections \
      --pdf-engine=wkhtmltopdf \
      --css ${css} \
      -f markdown \
      -t html \
      $tmpmd \
      -o ${bookname}
}
article() {
  bookname=$1
  shift
  [ $# -eq 0 ] && dohelp ${FAILURE} "an article needs markdown files in input"
  prepare_book "$@"
  pandoc --standalone \
      --toc \
      --reference-links \
      --number-sections \
      --pdf-engine=xelatex \
      --variable mainfont="TeX Gyre Pagella" \
      --template=default \
      -f markdown \
      $tmpmd \
      -o ${bookname}

}

[ $# -eq 0 ] && dohelp

output_type=$1
shift

case ${output_type} in
  -h|--help)
    dohelp
    ;;
  book)
    book "$@"
    ;;
  article)
    article "$@"
    ;;
  website)
    dohelp 1 "no code for this"
    # website "$@"
    ;;
  *)
    dohelp
    ;;
esac
