#!/bin/bash

cd ..
mkdir deps
cd deps
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
#raygui
echo "-----------------------------------------------------------------"
echo "getting raygui"
echo "-----------------------------------------------------------------"
git clone https://github.com/raysan5/raygui.git raygui
#raylib
echo "-----------------------------------------------------------------"
echo "getting raylib"
echo "-----------------------------------------------------------------"
git clone https://github.com/raysan5/raylib.git raylib
cd raylib/src/
make clean
sudo make uninstall
cd ../..
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
