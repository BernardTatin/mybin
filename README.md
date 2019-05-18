# à propos...

## installation/désinstallation des scripts

Les scripts **`install.sh`** et **`uninstall.sh`** sont là pour faire ce job. Pour le moment (mai 2019), ces deux scripts ne prennent aucun paramètres. Au besoin, modifiez la variable **`PREFIX`** dans chacun d'eux, cette variable défini le répertoire de base de l'installation.

## la documentation

Après l'installation, elle consiste uniquement en une collection de fichiers *Markdown* contenus dans le répertoire ***`doc`***. On peut obtenir un beau fichier *PDF* avec la suite de commandes lancées depuis la racine de l'installation:

```sh
$ cd pbook
$ ./do-current-doc.sh
# pour visualiser le fichier
$ evince ../bin-article.pdf&
```
