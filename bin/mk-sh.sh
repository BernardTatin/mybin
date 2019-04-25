#!/bin/sh

script=$(basename $0)
script_dir=$(dirname $0)

dohelp() {
	exit_code=0

	[ $# -gt 0 ] && exit_code=$1 && shift
	[ $# -gt 0 ] && echo "ERROR: $*" 1>&2
	
	cat >> DOHELP
${script} [-h|--help] : this message
${script} name name ... : shell script names
DOHELP
	exit ${exit_code}
}

make_sh() {
	cat > $1 << MAKE_SH
#!/bin/sh

script=\$(basename \$0)
script_dir=\$(dirname \$0)

dohelp() {
	exit_code=0
	
	[ \$# -gt 0 ] && exit_code=\$1 && shift
	[ \$# -gt 0 ] && echo "ERROR: \$*" 1>&2
	
	cat >> DOHELP
\${script} [-h|--help] : this message
\${script} name name ... : shell script names
DOHELP
	exit \${exit_code}
}

while [ \$# -ne 0 ]
do
	case \$1 in
		-h|--help)
			dohelp
			;;
		*)
			;;
	esac
	shift
done
MAKE_SH
	chmod +x $1
}

while [ $# -ne 0 ]
do
	case $1 in
		-h|--help)
			dohelp
			;;
		*)
			make_sh $1
			;;
	esac
	shift
done
