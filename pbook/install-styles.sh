#!/usr/bin/env dash

# ----------------------------------------------------------------------
set -e
set -u

# ----------------------------------------------------------------------
. $(dirname $0)/base.inc.sh
safe_source ${here}/standard-traps.inc.sh

# ----------------------------------------------------------------------
dest=~/.pandoc/templates
source=${here}/pbook-styles

for f in ${source}/*.latex
do
  name=$(basename $f)
  dest_link=${dest}/${name}
  [ -L ${dest_link} ] \
    && rm -fv ${dest_link}
  ln -s ${f} ${dest_link}
done
