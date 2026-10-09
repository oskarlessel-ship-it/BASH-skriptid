#!/bin/bash
if [ $# -ne 3 ]; then echo "Kasutus: $0 A B C"; exit 1; fi
A=$1; B=$2; C=$3
if [ "$(echo "$A == 0" | bc -l)" -eq 1 ]; then echo "A ei tohi olla 0."; exit 1; fi
D=$(echo "$B * $B - 4 * $A * $C" | bc -l)
if [ "$(echo "$D < 0" | bc -l)" -eq 1 ]; then echo "Reaalarvulisi lahendeid ei ole."; exit 0; fi
S=$(echo "sqrt($D)" | bc -l)
if [ "$(echo "$D == 0" | bc -l)" -eq 1 ]; then
    printf "x = %.5f\n" "$(echo "(-1 * $B) / (2 * $A)" | bc -l)"
else
    printf "x1 = %.5f\n" "$(echo "(-1 * $B + $S) / (2 * $A)" | bc -l)"
    printf "x2 = %.5f\n" "$(echo "(-1 * $B - $S) / (2 * $A)" | bc -l)"
fi
