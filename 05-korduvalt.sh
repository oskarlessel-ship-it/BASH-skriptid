#!/bin/bash

hello() {
  echo "Tere tulemast!"
}

hello
hello
hello

hello() {
  echo "Tere!"
}

for i in {1..5}
do
  hello
done
