# à propos de _zsh_

## compter avec _zsh_

Voici un exemple important, il y a des différences peut-être minimes mais cruciales avec _bash_:

```sh
i=0
while (( $i < 100 ))
do
   printf "%3d\n" $i
   ((i = i+1))
done
```
