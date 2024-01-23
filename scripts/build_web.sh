#!/bin/bash
cd ..
rm -r web_build
mkdir web_build
cd deps/emsdk
./emsdk activate latest
source ./emsdk_env.sh
cd ../..
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/deps/raylib/src/
export C_INCLUDE_PATH=$C_INCLUDE_PATH:$PWD/deps/raylib/src/

emcc -o main.html main.c -Os -Wall $PWD/deps/raylib/src/libraylib.a -I. -I$PWD/deps/raylib/src/raylib-h -L. -L$PWD/deps/raylib/src/libraylib-a -s USE_GLFW=3 -s ASYNCIFY --shell-file $PWD/deps/raylib/src/shell.html -DPLATFORM_WEB
mv main.html main.wasm main.js web_build/
