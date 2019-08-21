#!/usr/bin/env dash

# ----------------------------------------------------------------------
set -e
set -u
# set -x
# ----------------------------------------------------------------------
. $(dirname $0)/base.inc.sh

# ----------------------------------------------------------------------
# generic configuration
css=${here:-$(dirname $ 0)}/pbook-styles/default.css

# can be:
# - webpage: same directory tree but with html instead of md files
# - book:    combination of all md input files in one PDF made through wkhtmltopdf, using CSS
# - article: combination of all md input files in one PDF made through LaTeX
output_type=

# ----------------------------------------------------------------------
# book configuration
makebook=${makebook:-0}
bookname=
tmpmd=$(get_tmp_file tmpmd)
template=eisvogel
# ----------------------------------------------------------------------
# webpage configuration
startdir=${startdir:-'.'}
webpage=${webpage:-'./fulldoc'}
doclear=${doclear:-0}
tmpcss=

# ----------------------------------------------------------------------
trap_exit() {
   [ $debug -eq 0 ] || echo "trap_exit ${retcode}"
   rm -fv ${tmpmd}
   [ -z "$tmpcss" ] || rm -fv ${tmpcss}
   exit ${retcode}
}
trap_error() {
   retcode=${FAILURE}
   [ $debug -eq 0 ] || echo "trap_error ${retcode}"
}
trap_force_quit() {
   retcode=${FAILURE}
   [ $debug -eq 0 ] || echo "trap_force_quit ${retcode}"
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

   ${script} article article-name.pdf [-t|--template template-name] FILES.md...: make a PDF article with all FILES.md
   OPTIONS:
   -t|template template-name: name of the LaTeX template

   ${script} book book-name.pdf [-c|--css cssfile] FILES.md...: make a PDF book with all FILES.md
   OPTIONS:
   --css css-file: css used, default ${css}

   ${script} webpage [--startdir dir] [--webpage dir] [-c--css cssfile] [--doclear]: convert all markdown files of current dir to HTML in the webpage dir
   OPTIONS:
   --startdir dir: source dir of Markdown files, default ${startdir}
   --webpage dir: destination dir of PDF files, default ${webpage}
   --css css-file: css used, default ${css}
   --doclear: erase previous webpage, default false
DOHELP
}

# ----------------------------------------------------------------------
show_config() {
   echo "============================================="
   echo "here:         $here"
   echo "script:       $script"
   echo "startdir:     $startdir"
   echo "webpage:      $webpage"
   echo "css:          $css"
   echo "doclear:      $doclear"
   echo "bookname:     $bookname"
   echo '============================================='
}

# ----------------------------------------------------------------------
prepare_book() {
   [ -z "$bookname" ] && \
   dohelp ${FAILURE} "you need a book file name"
   case $1 in
      -t|--template|-c|-css)
      shift
      ;;
      *)
      ;;
   esac
   output_extension=$1
   shift
   ymlfile=$(dirname ${bookname})/$(basename ${bookname} ${output_extension}).yml
   [ -f ${ymlfile} ] && cp ${ymlfile} ${tmpmd}
   while [ $# -gt 0 ]; do
      ! [ -f "$1" ] \
      && onerror $FAILURE "Cannot find this file: '$1'"
      cat "$1" >> ${tmpmd}
      echo >> ${tmpmd}
      shift
   done
   [ $debug -eq 0 ] || show_config
}

# ----------------------------------------------------------------------
book() {
   echo "book $*"
   case $1 in
      -c|--css)
      shift
      [ $# -eq 0 ] && dohelp ${FAILURE} "$1 must be followed by a css name"
      css="$1"
      shift
      ;;
      *)
      ;;
   esac
   bookname=$1
   shift
   [ $# -eq 0 ] && dohelp ${FAILURE} "a book needs markdown files in input"
   prepare_book '.pdf' "$@"
   pandoc --standalone \
   --toc \
   --number-sections \
   --pdf-engine=wkhtmltopdf \
   --css ${css} \
   -f markdown \
   -t html \
   $tmpmd \
   -o ${bookname} || onerror $FAILURE "pandoc failed"

   # --reference-links
}
# ----------------------------------------------------------------------
article() {
   case $1 in
      -t|--template)
        shift
        [ $# -eq 0 ] && dohelp ${FAILURE} "$1 must be followed by a template name"
        template=$1
        shift
        ;;
      *)
        ;;
   esac
   bookname=$1
   shift
   [ $# -eq 0 ] && dohelp ${FAILURE} "an article needs markdown files in input"
   prepare_book '.pdf' "$@"
   pandoc --standalone \
   --toc \
   --number-sections \
   --template=${template} \
   -V documentclass=article \
   -V familydefault=cmr \
   -V fontsize=12pt \
   --highlight-style pygments \
   --pdf-engine=xelatex \
   -f markdown \
   $tmpmd \
   -o ${bookname} || onerror $FAILURE "pandoc failed"

   # --reference-links \
}
webpage() {
   case $1 in
      -c|--css)
      shift
      [ $# -eq 0 ] && dohelp ${FAILURE} "$1 must be followed by a css name"
      css="$1"
      shift
      ;;
      *)
      ;;
   esac
   bookname=$1
   shift
   [ $# -eq 0 ] && dohelp ${FAILURE} "a webpage needs markdown files in input"
   prepare_book '.html' "$@"
   tmpcss=$(get_tmp_file css)
   echo '<style type="text/css">' > $tmpcss
   cat $css >> $tmpcss
   echo '</style>' >> $tmpcss
   pandoc --standalone \
   --toc \
   --reference-links \
   --number-sections \
   --highlight-style pygments \
   --include-in-header=${tmpcss} \
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
   webpage)
   webpage "$@"
   ;;
   *)
   dohelp
   ;;
esac

retcode=$SUCCESS
