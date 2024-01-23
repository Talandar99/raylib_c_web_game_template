#include "raylib.h"
#define RAYGUI_IMPLEMENTATION
#include "deps/raygui/src/raygui.h"

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
int main(void) {
    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "basic window");

    SetTargetFPS(60);  // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------
    GuiSetFont(GetFontDefault());
    GuiSetStyle(DEFAULT, TEXT_SIZE, 20);
    int game_state = 0;
    Rectangle button_rectangle = (Rectangle){(screenWidth / 2), (screenHeight - 70), 200, 50};
    // Main game loop
    while (!WindowShouldClose())  // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        //
        BeginDrawing();
        bool button_pressed = GuiButton(button_rectangle, "Press the button");
        if (game_state == 0) {
            if (button_pressed) {
                game_state = 1;
            }
            ClearBackground(DARKPURPLE);
        } else {
            if (button_pressed) {
                game_state = 0;
            }
            ClearBackground(DARKGREEN);
        }

        DrawText("Hello from raylib game", 190, 200, 20, LIGHTGRAY);

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();  // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}
