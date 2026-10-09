#!/bin/bash

kontrolli_sisend() {
  if [ $# -ne 2 ]; then
    echo "Viga: vaja kaks arvu"
    return 1
  fi
  return 0
}

arvuta_tulemus() {
  local a="$1"
  local b="$2"
  echo $(( a + b ))
}

salvesta_tulemus() {
  local vaartus="$1"
  tulemus="$vaartus"
}

kuva_tulemus() {
  echo "Tulemus: $1"
}

kontrolli_sisend 10 20
summa=$(arvuta_tulemus 10 20)
salvesta_tulemus "$summa"
kuva_tulemus "$tulemus"
