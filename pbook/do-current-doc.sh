#!/bin/sh

. $(dirname $0)/base.inc.sh

cd $(dirname ${here})

mdfiles="README.md doc/general.md doc/zsh.md doc/git/GitIgnore.md"

./pbook/do-pbook.sh book ./bin-book.pdf \
    ${mdfiles}
./pbook/do-pbook.sh article ./bin-article.pdf \
    ${mdfiles}
