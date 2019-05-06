#!/bin/sh

. $(dirname $0)/base.inc.sh

startdir=.
mdfiles=
docdir=./fulldoc
css=${here}/pbook-styles/default.css
doclear=0
makebook=0
bookname=
tmpmd=
debug=0

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
${script} --book book-name.pdf [OPTIONS] FILES.md...: make a PDF book with all FILES.md
--book book.pdf: create a book with all files, default "", i.e. no book
OPTIONS:
    --css css-file: css used, default ${css}
    --doclear: erase previous docdir, default false
${script} [OPTIONS] [FILES.md]: convert all markdown files of current dir to PDF
--startdir dir: use dir instead of current dir, default ${startdir}
OPTIONS:
    --docdir dir: destination dir of PDF files, default ${docdir}
    --css css-file: css used, default ${css}
    --doclear: erase previous docdir, default false
DOHELP
    exit ${ecode}
}

show_config() {
    [ ${debug} -eq 1 ] && \
        echo '============================================='
        echo "here:         $here" && \
        echo "script:       $script" && \
        echo "startdir:     $startdir" && \
        echo "docdir:       $docdir" && \
        echo "css:          $css" && \
        echo "doclear:      $doclear" && \
        echo "mdfiles:      $mdfiles" && \
        echo "bookname:     $bookname" && \
        echo '============================================='
}

while [ $# -ne 0 ]
do
    case $1 in
        -h|--help)
            dohelp
            ;;
        --doclear)
            doclear=1
            ;;
        --startdir)
            shift
            [ $# -eq 0 ] && dohelp ${FAILURE} "$1 must be followed by a dir name"
            startdir="$1"
            ;;
        --book)
            shift
            [ $# -eq 0 ] && dohelp ${FAILURE} "$1 must be followed by a file name"
            bookname="$1"
            makebook=1
            ;;
        --css)
            shift
            [ $# -eq 0 ] && dohelp ${FAILURE} "$1 must be followed by a css name"
            css="$1"
            ;;
        --docdir)
            shift
            [ $# -eq 0 ] && dohelp ${FAILURE} "$1 must be followed by a dir name"
            docdir="$1"
            ;;
        --debug)
            debug=1
            ;;
        *)
            [ $makebook -eq 0 ] && \
              dohelp ${FAILURE} "you need a book file name (option --book PDF)"
            tmpmd=$(dirname $bookname)/$(basename $bookname .pdf).md
            rm -f ${tmpmd}
            mdfiles=${tmpmd}
            while [ $# -gt 0 ]; do
              cat $1 >> ${tmpmd}
              echo >> ${tmpmd}
              shift
            done
            ;;
    esac
    [ $# -gt 0 ] && shift
done

show_config

[ ${makebook} -eq 0 ] \
    && startdir=$(standardize_dir $startdir) \
    && mdfiles=$(cd ${startdir} && find . -name '*.md') \
    && mkdir -p $docdir \
    && docdir=$(standardize_dir $docdir)

show_config

[ ${makebook} -eq 0 ] \
    && [ ${doclear} -eq 1 ] \
    && rm -rf ${docdir} \
    && cd ${startdir}

for f in ${mdfiles}
do
    echo "$f ...."
    fdir=$(dirname $f)
    fname=$(basename $f .md)
    ddir=$(echo $fdir | sed "s!^\.!${docdir}!")
    echo "$f -> $ddir/$fname.pdf"
    mkdir -p $ddir
    pdf_file=$ddir/$fname.pdf
    [ $makebook -eq 1 ] && pdf_file=$bookname
    [ ${debug} -ne 1 ] && \
        pandoc --standalone \
            --toc \
            --css ${css} \
            -f markdown \
            -t html \
            $f \
            -o ${pdf_file}
done