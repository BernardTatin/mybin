#!/usr/bin/env dash

script=$(basename $0)
now=$(date "+%y%m%d")
log=${HOME}/${now}-${script}.log
touch $log

MINDMEM=30
MINDSWAP=30
freemem=$(( 1 - MINDMEM ))
freeswap=$(( 1 - MINDSWAP ))
doit=0
loops=0
deltat=10
PRINTF=/usr/bin/printf


function get_mem_info () {
	local regex=$1
	local dmem=0
	local value=$(egrep "${regex}" /proc/meminfo | tr -s ' ' | cut -d ' ' -f 2)

	value=$(( value / 1024 ))

	echo $value
}

function delta_mem () {
	local newvalue=$1
	local oldvalue=$2
	local dmem=$(( newvalue - oldvalue ))
	(( dmem < 0 )) && dmem=$(( -dmem ))
	echo $dmem
}

echo "deltat: ${deltat} - log: ${log}"
while true
do
	lfreemem=$(get_mem_info "^MemFree")
	lfreeswap=$(get_mem_info "^SwapFree")

	dmem=$(delta_mem lfreemem freemem)
	dswap=$(delta_mem lfreeswap freeswap)

	doit=0
	(( loops >= deltat )) && doit=1
	(( dmem >= MINDMEM )) && doit=1
	(( dswap >= MINDSWAP )) && doit=1
	lnow=$(date "+%y%m%d-%H%M%S")

	(( doit == 1 )) && \
		loops=0 && \
		freemem=${lfreemem} && \
		freeswap=${lfreeswap} && \
		$PRINTF "${lnow} - freemem : %6d - freeswap : %6d\n" ${freemem} ${freeswap} >> $log
	# echo " freemem : ${lfreemem} - freeswap : ${lfreeswap}"
	sleep 1
	(( loops++ ))
done
