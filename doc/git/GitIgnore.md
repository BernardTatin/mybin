# les aventures de .gitignore

Il est bien connu que le fichier `.gitignore`  à la racine de tout dépôt local permet de sélectionner les fichiers à ***ne pas*** inclure dans le dépôt lors des opérations d'ajout et de commit.

À consulter: [la documentation officielle](https://git-scm.com/docs/gitignore)

## état 0 de .gitignore

Le premier état d'un `.gitignore` doit ressembler à ça:

```
# IDEs
.*.swp

# archives
*.zip
*.tar
*.bz2
*.gz
```

## remplir avec ce qu'il y a dans le répertoire en question

Ce n'est évidemment pas suffisant dans la plupart des cas. On a la possibilité de faire quelques recherche sur le Web ou bien d'automatiser au moins une partie du remplissage de ce fichier.

Prenons l'exemple de `/etc`  qui contient pour l'essentiel des fichiers textes. Aussi surprenant que cela puisse paraître, il y a un nombre non négligeable de fichiers binaires qui n'ont rien à faire dans un dépôt.

La première étaape de cette recherche est de trouver tous les types des fichiers du répertoire:

```bash
find . -type f -print0 \
	| xargs -0 file \
	| cut -d ':' -f 2 \
	| sed 's/^[ \t]\+//' \
	| sort -u
```

Comme nous travaillons dans un répertoire sensible, beaucoup de fichiers sont protégés y compris en lecture au visiteur lambda. l'utilisation de `sudo`  permet de s'affranchir alors de nombreux et désagréables messages d'erreur.

On obtient quelque chose qui ressemble à ça (ce n'est qu'un extrait, la liste est assez longue sur ma machine):

```
application/x-gnupg-keyring; charset=binary
application/x-java-keystore; charset=binary
application/zlib; charset=binary
inode/x-empty; charset=binary
text/html; charset=iso-8859-1
text/html; charset=us-ascii
text/plain; charset=us-ascii
text/plain; charset=utf-8
text/x-c; charset=us-ascii
text/x-c; charset=utf-8
```

En fait, on ne doit conserver que ce qui est `text/...` et éliminer le reste. On éliminera aussi quelques certificats ennuyeux et le répertoire `.git`:

``` bash
find . -type f  -print0 \
	| xargs -0 file --mime  \
	| grep -Ev '\./\.git/|text/|\./mono/certstore/certs/Trust' \
	| cut -d ':' -f 1 >> .gitignore
```

