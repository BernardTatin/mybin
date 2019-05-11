#!/usr/bin/env dash

# ----------------------------------------------------------------------
set -e
set -u

# ----------------------------------------------------------------------
. $(dirname $0)/base.inc.sh

# ----------------------------------------------------------------------
# generic configuration
debug=${debug:-0}
mdfiles=
css=${here:-$(dirname $ 0)}/pbook-styles/default.css

# can be:
# - website: same directory tree but with html instead of md files
# - book:    combination of all md input files in one PDF made through wkhtmltopdf, using CSS
# - article: combination of all md input files in one PDF made through LaTeX
output_type=

# ----------------------------------------------------------------------
# book configuration
makebook=${makebook:-0}
bookname=
tmpmd=$(get_tmp_file tmpmd)

# ----------------------------------------------------------------------
# website configuration
startdir=${startdir:-'.'}
website=${website:-'./fulldoc'}
doclear=${doclear:-0}

# variables
retcode=${retcode:-$FAILURE}

# ----------------------------------------------------------------------
trap_exit() {
  echo "trap_exit ${retcode}"
  rm -fv ${tmpmd}
  exit ${retcode}
}
trap_error() {
  retcode=${FAILURE}
  echo "trap_error ${retcode}"
}
trap_force_quit() {
  retcode=${FAILURE}
  echo "trap_force_quit ${retcode}"
}
# ----------------------------------------------------------------------
# trap trap_force_quit *
trap trap_force_quit TERM TSTP INT QUIT
trap trap_error HUP ILL ABRT FPE SEGV PIPE
trap trap_exit EXIT

# ----------------------------------------------------------------------
get_help_text() {
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
}

# ----------------------------------------------------------------------
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

# ----------------------------------------------------------------------
prepare_book() {
  [ -z "$bookname" ] && \
    dohelp ${FAILURE} "you need a book file name"
  while [ $# -gt 0 ]; do
    ! [ -f "$1" ] \
      && onerror $FAILURE "Cannot find this file: '$1'"
    cat "$1" >> ${tmpmd}
    echo >> ${tmpmd}
    shift
  done
}

# ----------------------------------------------------------------------
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
      -o ${bookname} || onerror $FAILURE "pandoc failed"
}
# ----------------------------------------------------------------------
article() {
  bookname=$1
  shift
  [ $# -eq 0 ] && dohelp ${FAILURE} "an article needs markdown files in input"
  prepare_book "$@"
  pandoc --standalone \
      --toc \
      --reference-links \
      --number-sections \
      --template=eisvogel \
      --pdf-engine=xelatex \
      -f markdown \
      $tmpmd \
      -o ${bookname} || onerror $FAILURE "pandoc failed"

}

# ----------------------------------------------------------------------
[ $# -eq 0 ] && dohelp

output_type=$1
shift

# ----------------------------------------------------------------------
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
    dohelp 0 "no code for this"
    # website "$@"
    ;;
  *)
    dohelp
    ;;
esac

retcode=$SUCCESS
