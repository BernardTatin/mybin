---
author: "Bernard Tatin"
title: "Histoires de shells"
date: "Mai 2019"
lang: fr-FR
titlepage: on
toc-own-page: on
book: false
abstract: |
  Le shell est un élément indispensable losqu'on travaille
  sous Unix. Voici de quoi améliorer ses compétences.

  Beaucoup de notes à propos des shells et de l'administration _Linux_. Et des scripts, beaucoup de scripts.
---
# README

## installation/désinstallation

Les scripts `install.sh` et `uninstall.sh` sont là pour faire ce job. Pour le moment (mai 2019), ces deux scripts ne prennent aucun paramètres. Au besoin, modifiez la variable `PREFIX` dans chacun d'eux. Cette variable défini le répertoire de base de l'installation.

## la documentation

Après l'installation, elle consiste uniquement en une collection de fichiers *Markdown* contenus dans le répertoire `doc`. On peut obtenir un beau fichier *PDF* avec la suite de commande lancée depuis la racine de l'installation:

```sh
$ cd pbook
$ ./do-current-doc.sh
# pour visualiser le fichier
$ evince ../bin-article.pdf&
```
