#!/bin/sh

script=$(basename "$0")

dohelp () {
	cat << DOHELP
${script} -h|--help : this text
${script} [-f|--from FROM] [-t|--to TO] [--tag TAG]
	git merge branch FROM into branch TO tagging with TAG
	- FROM default value : develop
	- TO default value : master
	- TAG default : nothing to be done
DOHELP
}

branch_from=develop
branch_to=master
tag=

while [ $# -ne 0 ]
do
	case $1 in
		-h|--help)
			dohelp
			exit 0
			;;
		-f|--from)
			shift
			[ $# -eq 0 ] && dohelp && exit 1
			branch_from=$1
			;;
		-t|--to)
			shift
			[ $# -eq 0 ] && dohelp && exit 2
			branch_to=$1
			;;
		--tag)
			shift
			[ $# -eq 0 ] && dohelp && exit 3
			tag=$1
			;;
		*)
			dohelp && exit 15
	esac
	shift
done

echo "## push current..."
git push || exit 5
echo "## checkout ${branch_to}..."
git checkout "${branch_to}" || exit 5
echo "## git merge ${branch_from}..."
git merge "${branch_from}" || exit 5
echo "## push current..."
git push -u origin "${branch_to}" || exit 7
if [ -n "${tag}" ]
then
	git tag -m "New version ${tag}" "${tag}" || exit 6
	git push --tags || exit 6
fi

echo "## checkout ${branch_from}..."
git checkout "${branch_from}" || exit 8

exit 0
