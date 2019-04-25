# ce fichier doit être inclu par un script shell

script=$(basename $0)
current_user=$USER

SUCCESS=0
FAILURE=1

onerror() {
	echo "[ERROR] $*" 1>2
	echo "try '$scrippt --help'" 
	exit ${FAILURE}
}

ensureroot() {
	echo "EUID : $EUID, UID : $UID"
	[ $EUID -ne 0 ] && onerror "you must be root"
}
