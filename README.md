# raylib_c_web_game_template
This is template for running raylib games and building them for web using emscripten
##### side note
i use raylib with raygui but it's fully optional

## How to setup for development
- `cd setup_scripts`
- `./setup_raylib_for_desktop.sh`
- now you can use `./run.sh` for running your game

## How to setup for web build
- `cd setup_scripts`
- `./setup_raylib_for_web.sh`
- if you will try to use `./run.sh` it will cause an error. You should use setup for desktop setup for development process
- now you can use `./build_web.sh`

## How to build for web
- setup for web first
- `cd setup_scripts`
- `./build_web.sh`
- all files will be in `web_build` directory

## Running web build using python
- `cd web_build`
- `python -m http.server`


## Why 2 setups?
- raylib have to be build first before using it for development or web

## Dependancies
- gcc with all libraries needed to build code
- git
- bash
- UNIX based operating system
