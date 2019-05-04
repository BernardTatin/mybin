#!/bin/sh 

. $(dirname $0)/base.inc.sh

here=$(standardize_dir $(dirname $0))
script=$(basename $0)

startdir=.
docdir=./fulldoc
css=${here}/style.css
doclear=0
debug=0

dohelp() {
    ecode=0
    if [ $# -ne 0 ]
    then
        ecode=$1
        shift
        [ ${ecode} -ne 0 ] && printf "ERROR: " 1>2
        [ $# -ne 0 ] && echo $@ 1>2
    fi
    cat << DOHELP
${script} -h|--help: this text
${script} [OPTIONS]: convert markdown files of current dir all to PDF
OPTIONS:
    --startdir dir: use dir instead of current dir, default ${startdir}
    --docdir dir: destination dir of PDF files, default ${docdir}
    --css css-file: css used, default ${css}
    --doclear: erase previous docdir, default false
DOHELP
    exit ${ecode}
}

show_config() {
    [ ${debug} -eq 1 ] && \
        echo "here:         $here" && \
        echo "script:       $script" && \
        echo "startdir:     $startdir" && \
        echo "docdir:       $docdir" && \
        echo "css:          $css" && \
        echo "doclear:      $doclear"
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
            [ $# -eq 0 ] && dohelp 1 "$1 must be followed by a dir name"
            startdir="$1"
            ;;
        --css)
            shift 
            [ $# -eq 0 ] && dohelp 1 "$1 must be followed by a css name"
            css="$1"
            ;;
        --docdir)
            shift 
            [ $# -eq 0 ] && dohelp 1 "$1 must be followed by a dir name"
            docdir="$1"
            ;;
        --debug)
            debug=1
            ;;
        *)
            dohelp 1 "unknown option '$1'"
            ;;
    esac
    shift
done

show_config 

startdir=$(standardize_dir $startdir)
mkdir -p $docdir
docdir=$(standardize_dir $docdir)

show_config 

[ ${doclear} -eq 1 ] && rm -rf ${docdir}

cd ${startdir}

for f in $(find . -name '*.md')
do
    echo "$f ...."
    fdir=$(dirname $f)
    fname=$(basename $f .md)
    ddir=$(echo $fdir | sed "s!^\.!${docdir}!")
    echo "$f -> $ddir/$fname.pdf"
    mkdir -p $ddir 
    [ ${debug} -ne 1 ] && \
        pandoc --standalone \
            --css ${css} \
            -f markdown \
            -t html \
            $f \
            --pdf-engine=wkhtmltopdf \
            -o $ddir/$fname.pdf
done