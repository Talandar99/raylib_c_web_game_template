#!/bin/bash

source config.env

# -------------------------------------------------------------------------
# DEPENDANCIES
# -------------------------------------------------------------------------
#
mkdir deps
cd deps

if $RAYLIB_USE_RAYGUI; then
    echo "-----------------------------------------------------------------"
    echo "getting raygui"
    echo "-----------------------------------------------------------------"
    git clone https://github.com/raysan5/raygui.git raygui
fi

if $RAYLIB_USE_RPNG; then
    echo "-----------------------------------------------------------------"
    echo "getting rpng"
    echo "-----------------------------------------------------------------"
    git clone https://github.com/raysan5/rpng.git rpng
fi

if $RAYLIB_USE_RAUDIO; then
    echo "-----------------------------------------------------------------"
    echo "getting raudio"
    echo "-----------------------------------------------------------------"
    git clone https://github.com/raysan5/raudio.git raudio
fi

if $RAYLIB_USE_RRES; then
    echo "-----------------------------------------------------------------"
    echo "getting rres"
    echo "-----------------------------------------------------------------"
    git clone https://github.com/raysan5/rres.git rres
fi

if $RAYLIB_USE_NBNET; then
    echo "-----------------------------------------------------------------"
    echo "getting nbnet"
    echo "-----------------------------------------------------------------"
    git clone https://github.com/nathhB/nbnet.git nbnet 
fi

# -------------------------------------------------------------------------
# SETUP
# -------------------------------------------------------------------------
echo "-----------------------------------------------------------------"
echo "getting raylib"
echo "-----------------------------------------------------------------"
git clone https://github.com/raysan5/raylib.git raylib
cd raylib/src/
sudo make clean 
cd ../..
echo "-----------------------------------------------------------------"
echo "setting up raylib for $RAYLIB_SETUP_PLATFORM"
echo "-----------------------------------------------------------------"

if [[ "$RAYLIB_SETUP_PLATFORM" == "WEB" ]]; then
    #emscripten
    echo "-----------------------------------------------------------------"
    echo "getting emsdk"
    echo "-----------------------------------------------------------------"
    git clone https://github.com/emscripten-core/emsdk.git emsdk
    git pull
    cd emsdk
    echo "-----------------------------------------------------------------"
    echo "building emsdk"
    echo "-----------------------------------------------------------------"
    ./emsdk install latest
    cd ..
    cd emsdk
    echo "-----------------------------------------------------------------"
    echo "activating emsdk"
    echo "-----------------------------------------------------------------"
    emsdk activate latest
    source ./emsdk_env.sh
    cd ..
    cd raylib/src/
    make PLATFORM=PLATFORM_WEB 
    echo "-----------------------------------------------------------------"
    echo "building"
    echo "-----------------------------------------------------------------"
    sudo make install
elif [[ "$RAYLIB_SETUP_PLATFORM" == "DESKTOP" ]]; then
    # To make the static version.
    cd raylib/src/
    make PLATFORM=PLATFORM_DESKTOP 
    # To make the dynamic shared version.
    #make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED 
    echo "-----------------------------------------------------------------"
    echo "building"
    echo "-----------------------------------------------------------------"
    sudo make install
else
    echo "UNKNOWN PLATFORM: $RAYLIB_SETUP_PLATFORM"
    echo "pick WEB or DESKTOP."
fi



