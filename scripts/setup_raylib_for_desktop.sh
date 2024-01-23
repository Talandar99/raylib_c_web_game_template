#!/bin/bash

cd ..
mkdir deps
cd deps
echo "-----------------------------------------------------------------"
echo "getting raygui"
echo "-----------------------------------------------------------------"
git clone https://github.com/raysan5/raygui.git raygui
echo "-----------------------------------------------------------------"
echo "getting raylib"
echo "-----------------------------------------------------------------"
git clone https://github.com/raysan5/raylib.git raylib
cd raylib/src/
make clean
sudo make uninstall
# To make the static version.
make PLATFORM=PLATFORM_DESKTOP 
# To make the dynamic shared version.
#make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED 
echo "-----------------------------------------------------------------"
echo "building"
echo "-----------------------------------------------------------------"
sudo make install
