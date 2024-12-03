# -------------------------------------------------------------------------
# SETTINGS
# -------------------------------------------------------------------------
# pick platform "WEB" or "DESKTOP"
RAYLIB_SETUP_PLATFORM="DESKTOP"  

# set to true or false based on preferences
# RAYGUI raygui is immediate-mode-gui library.
RAYLIB_USE_RAYGUI=true     
# RPNG is library to load/save png images and manage png chunks.
RAYLIB_USE_RPNG=false      
# raudio is audio library based on miniaudio.
RAYLIB_USE_RAUDIO=false    
# rres is file-format to package resources
RAYLIB_USE_RRES=false      
# NBNET is library designed to implement client-server architecture
RAYLIB_USE_NBNET=false     


# -------------------------------------------------------------------------
# VARIABLES
# -------------------------------------------------------------------------
PURPLE = \033[95m
CYAN = \033[96m
DARKCYAN = \033[36m
BLUE = \033[94m
GREEN = \033[92m
YELLOW = \033[93m
RED = \033[91m
BOLD = \033[1m 
UNDERLINE = \033[4m 
RESET = \033[0m 


help:
	@echo -e "Available commands:"
	@echo -e "  $(GREEN)make help$(RESET)           		- Show this help message"
	@echo -e "  $(GREEN)make deps$(RESET)           		- Download necessary dependencies and run setup_raylib_platform"
	@echo -e "  $(GREEN)make setup_raylib_platform$(RESET)	- Setup raylib for the selected platform"
	@echo -e "  $(GREEN)make build$(RESET)          		- Build the project based on the selected platform"
	@echo -e "  $(GREEN)make web_run$(RESET)        		- Build and run web version with HTTP server"
	@echo -e "  $(GREEN)make desktop_run$(RESET)    		- Build and run desktop version"
	@echo -e "  $(GREEN)make clean$(RESET)          		- Clean the build and dependencies"


deps:
ifeq ($(strip $(RAYLIB_USE_RAYGUI)),true)
	@echo -e "$(GREEN)-----------------------------------------------------------------"
	@echo -e "Getting raygui"
	@echo -e "-----------------------------------------------------------------$(RESET)"
	@git clone https://github.com/raysan5/raygui.git deps/raygui || echo -e "Failed to download dependacy (Already exist?)"
endif

ifeq ($(strip $(RAYLIB_USE_RPNG)),true)
	@echo -e "$(GREEN)-----------------------------------------------------------------"
	@echo -e "Getting rpng"
	@git clone https://github.com/raysan5/rpng.git deps/rpng || echo -e "Failed to download dependacy (Already exist?)"
endif

ifeq ($(strip $(RAYLIB_USE_RAUDIO)),true)
	@echo -e "$(GREEN)-----------------------------------------------------------------"
	@echo -e "Getting raudio"
	@echo -e "-----------------------------------------------------------------$(RESET)"
	@git clone https://github.com/raysan5/raudio.git deps/raudio || echo -e "Failed to download dependacy (Already exist?)"
endif

ifeq ($(strip $(RAYLIB_USE_RRES)),true)
	@echo -e "$(GREEN)-----------------------------------------------------------------"
	@echo -e "Getting rres"
	@echo -e "-----------------------------------------------------------------$(RESET)"
	@git clone https://github.com/raysan5/rres.git deps/rres || echo -e "Failed to download dependacy (Already exist?)"
endif

ifeq ($(strip $(RAYLIB_USE_NBNET)),true)
	@echo -e "$(GREEN)-----------------------------------------------------------------"
	@echo -e "Getting nbnet"
	@echo -e "-----------------------------------------------------------------$(RESET)"
	@git clone https://github.com/nathhB/nbnet.git deps/nbnet || echo -e "Failed to download dependacy (Already exist?)"
endif
	@echo -e "$(GREEN)-----------------------------------------------------------------"
	@echo -e "Getting raylib"
	@echo -e "-----------------------------------------------------------------$(RESET)"
	@git clone https://github.com/raysan5/raylib.git deps/raylib || echo -e "Failed to download dependacy (Already exist?)"

	$(MAKE) setup_raylib_platform



setup_raylib_platform:
ifeq ($(strip $(RAYLIB_SETUP_PLATFORM)), "WEB")
	@echo -e "$(GREEN)-----------------------------------------------------------------"
	@echo -e "Setting up platform: WEB"
	@echo -e "-----------------------------------------------------------------$(RESET)"
	@cd deps/raylib/src && make clean
	@echo -e "getting emsdk"
	@git clone https://github.com/emscripten-core/emsdk.git deps/emsdk || echo -e "Failed to download dependacy (Already exist?)"
	@cd deps/emsdk && git pull
	@cd deps/emsdk && ./emsdk install latest
	@cd deps/emsdk && ./emsdk activate latest
	@echo -e "$(GREEN)-----------------------------------------------------------------"
	@echo -e "building raylib"
	@echo -e "-----------------------------------------------------------------$(RESET)"
	@cd deps/raylib/src && source ../../emsdk/emsdk_env.sh && make PLATFORM=PLATFORM_WEB
	@cd deps/raylib/src && source ../../emsdk/emsdk_env.sh && sudo make install
else ifeq ($(strip $(RAYLIB_SETUP_PLATFORM)), "DESKTOP")
	@echo -e "$(GREEN)-----------------------------------------------------------------"
	@echo -e "Setting up platform: DESKTOP"
	@echo -e "-----------------------------------------------------------------$(RESET)"
	@cd deps/raylib/src && make clean
	@cd deps/raylib/src && make PLATFORM=PLATFORM_DESKTOP
	@echo -e "$(GREEN)-----------------------------------------------------------------"
	@echo -e "building raylib"
	@echo -e "-----------------------------------------------------------------$(RESET)"
	@cd deps/raylib/src && sudo make install
else
	@echo -e "$(RED)UNKNOWN PLATFORM: $(RAYLIB_SETUP_PLATFORM)"
	@echo -e "Pick 'WEB' or 'DESKTOP'.$(RESET)"
endif

build:
	@rm -rf build
	@mkdir build
ifeq ($(strip $(RAYLIB_SETUP_PLATFORM)), "WEB")
	@rm -rf build/web
	@mkdir build/web
	@cd deps/emsdk && ./emsdk activate latest
	@export LD_LIBRARY_PATH=$$LD_LIBRARY_PATH:$(PWD)/deps/raylib/src/ \
		&& export C_INCLUDE_PATH=$$C_INCLUDE_PATH:$(PWD)/deps/raylib/src/ \
	    && source deps/emsdk/emsdk_env.sh \
		&& emcc -o main.html main.c -Os -Wall $(PWD)/deps/raylib/src/libraylib.a \
		-I. -I$(PWD)/deps/raylib/src/raylib.h \
		-L. -L$(PWD)/deps/raylib/src/libraylib.a \
		-s USE_GLFW=3 -s ASYNCIFY --shell-file $(PWD)/shell.html -DPLATFORM_WEB
	@mv main.html main.wasm main.js build/web/
else ifeq ($(strip $(RAYLIB_SETUP_PLATFORM)), "DESKTOP")
	@rm -rf build/desktop
	@mkdir build/desktop
	@rm -f build/desktop/bin.out
	@gcc main.c -L$(PWD)/deps/raylib/src -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 -o build/desktop/bin.out
else
	@echo -e "$(RED)UNKNOWN PLATFORM: $(RAYLIB_SETUP_PLATFORM)"
	@echo -e "Pick 'WEB' or 'DESKTOP'.$(RESET)"
endif

web_run:
	$(MAKE) build
	@echo -e "$(GREEN)Starting HTTP server at http://0.0.0.0:8000/main.html $(RESET)"
	@cd build/web && python -m http.server

desktop_run:
	$(MAKE) build
	./build/desktop/bin.out

clean:
	@echo -e "Cleaning ..."
	@rm -rf deps game_desktop_build.out build

.PHONY: build deps
