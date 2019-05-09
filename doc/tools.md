# les outils

Voici la liste actuelle:

- `debian-autoremove.sh`
- `debian-upgrade.sh`
- `disk-space-leak.sh`
- `domerge.sh`
- `git-commit-and-push.sh`
- `mem-monitor.sh`
- `mk-bash.bash`
- `mk-sh.sh`
- `mkusers`
- `use-swap.sh`

Ils utilisent tous, ou presque, `base.inc.sh` qui est *sourcé*.

## `debian-autoremove.sh`

Lance `apt-get autoremove` et met à jour le dépôt *Git* de `/etc`. Il n'y a pas de paramètres.

## `debian-upgrade.sh`

Lance `apt-get update && apt-get upgrade -y` et met à jour le dépôt *Git* de `/etc`. Il n'y a pas de paramètres.

## `disk-space-leak.sh`

Ce script affiche les trois répertoires qui occupent le plus de place depuis la position courante. Voici un exemple:

```sh
$ disk-space-leak.sh ~/
82240	/home/bernard//Pictures
19111	/home/bernard//VirtualBox VMs
13174	/home/bernard//emulation
```

Les tailles des répertoires sont données en mégaoctets. La syntaxe est la suivante:

- `disk-space-leak.sh --help`: affiche une aide minimale,
- `disk-space-leak.sh dir dir ...`: affiche les 3 plus gros objets (répertoire ou fichiers) des répertoires cités,
- `disk-space-leak.sh`: équivaut à `disk-space-leak.sh *`.

## `domerge.sh`

`domerge.sh` est une tentative de simplification du *merge* de deux branches d'un dépôt *Git*.

Finalement, peu utilisé par l'auteur qui se rabat souvent sur l'interface *Web* de *Gitlab*, *Github* ou *Bitbucket* qui sont simples tout en restant très efficace.

## `git-commit-and-push.sh`

L'ultime simplification du trio `git add`, `git commit` et `git push`, très utilisé par l'auteur! La syntaxe est très simple, le seul paramètre est le commentaire du `commit`:

- `git-commit-and-push.sh "commentaire adapté au commit"`

## `mem-monitor.sh`

Ce script rempli un fichier log avec la mémoire libre et le swap libre. Finalement, son utilité est très anecdotique mais lorsqu'on ne l'a pas sous la main, on est em...bêté.

## `mk-bash.bash`

Crée un ou plusieurs squelette de script `bash`.

## `mk-sh.sh`

Crée un ou plusieurs squelette de script `sh`.

## `mkusers`

Crée un ou plusieurs utilisateurs dont le shell par défaut est `zsh`. Il faut le compléter pour ajouter la bonne configuration de `zsh` et de `vim`.

## `use-swap.sh`

Affiche tant bien que mal qui utilise le *swap* et dans quelle quantité.
