#!/bin/bash
PWD=$(pwd)
rm a.out
gcc  main.c -L$PWD/deps/raylib/src/libraylib.so -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 
./a.out
rm a.out
