#!/bin/bash

source config.env

if [[ "$RAYLIB_SETUP_PLATFORM" == "WEB" ]]; then
    rm -r web_build
    mkdir web_build
    cd deps/emsdk
    ./emsdk activate latest
    source ./emsdk_env.sh
    cd ../..
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/deps/raylib/src/
    export C_INCLUDE_PATH=$C_INCLUDE_PATH:$PWD/deps/raylib/src/
    
    emcc -o main.html main.c -Os -Wall $PWD/deps/raylib/src/libraylib.a -I. -I$PWD/deps/raylib/src/raylib-h -L. -L$PWD/deps/raylib/src/libraylib-a -s USE_GLFW=3 -s ASYNCIFY --shell-file $PWD/shell.html -DPLATFORM_WEB
    mv main.html main.wasm main.js web_build/

elif [[ "$RAYLIB_SETUP_PLATFORM" == "DESKTOP" ]]; then
    PWD=$(pwd)
    rm game_desktop_build.out
    gcc  main.c -L$PWD/deps/raylib/src/libraylib.so -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 
    mv a.out game_desktop_build.out
else
    echo "UNKNOWN PLATFORM: $RAYLIB_SETUP_PLATFORM"
    echo "pick WEB or DESKTOP."
fi
