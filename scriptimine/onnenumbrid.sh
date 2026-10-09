#!/bin/bash

arv=1000

while [ "$arv" -le 9999 ]
do
    originaal=$arv
    summa=$arv

    while [ "$summa" -gt 9 ]
    do
        vahe=0
        number=$summa

        while [ "$number" -gt 0 ]
        do
            vahe=$((vahe + number % 10))
            number=$((number / 10))
        done

        summa=$vahe
    done

    if [ "$summa" -eq 7 ]
    then
        echo "$originaal"
    fi

    arv=$((arv + 1))
done
