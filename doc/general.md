# généralités à propos des commandes

## affichage, n'oubliez pas `printf`

La commande `printf` permet de formatter une sortie console. Cette commande utilise à peu de chose près la même syntaxe que les `printf`, `sprintf` et autres `fprintf` du langage _C_. Voici un exemple:

```bash
line=12
file=README.md
# affiche "   12 README.md"
printf "%5d %s\n" line file
```

## tri

La commande `sort` offre de nombreuses possibilités dont celles de trier non pas depuis le début de ligne mais sur la _nième_ colonne d'un fichier. Par exemple, on trie ici le fichier `passwd` sur le nom du shell, soit la 7ème colonne en utilisant le séparateur _:_ :

```bash
sort -t ':' -k 7 /etc/passwd
```

Ce qui donne le résultat escompté.

Une autre possibilité intéressante de `sort`  va nous permettre de connaître tous les shells utilisés par les comptes du système. En s'aidant de `cut`:

```bash
cat /etc/passwd | cut -d ':' -f 7 | sort -u
```

Nous obtenonns sur ma machine cette liste:

```
/bin/bash
/bin/false
/bin/sh
/bin/sync
/usr/bin/zsh
/usr/sbin/nologin
```

On peut éventuellement en profiter pour désinstaller les shells non utilisés.

## *sourcer* des fichiers

*Sourcer* un fichier, c'est l'*inclure* dans le script courant comme s'il faisait parti du code en court d'interprétation. Depuis une console, sourcer un fichier, c'est comme si on saisissait son contenu au clavier. Dans le dernier cas, l'intérêt est de pouvoir, entre autre, modifier les variables d'environnement.

Selon les *shells*, il y a deux syntaxes possibles:

- `. filename`: pour `sh`, `bash`, `zsh` et certainement bien d'autres,
- `source filename`: pour `bash`, `zsh` mais ***pas*** pour `sh`.

Pour certains *shell* et avec la syntaxe `.`, la recherche du fichier s'effectue dans les répertoires de la variable `PATH` d'où, parfois, la nécessité de rappeler le chemin complet ou relatif du fichier comme par exemple `. ./filename`. La syntaxe `source filename` fait *aussi* une recherche dans le répertoire courant.
