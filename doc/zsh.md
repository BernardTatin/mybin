# à propos de Bash et Zsh

## compter

Voici un exemple important qui fonctionne tel quel avec les deux shells:

```bash
i=0
while (( $i < 100 ))
do
   printf "%3d\n" $i
   ((i = i+1))
done
```

