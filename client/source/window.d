import raylib;

Color rgba(int re, int gr, int bl, int al) {
    return Color(cast(ubyte)re, cast(ubyte)gr, cast(ubyte)bl, cast(ubyte)al);
}

class Gui
{
	static void DrawMiniMenu(string text, float x, float y, float fontSize, Color color, int padding)
	{
		 auto font = GetFontDefault();
		 auto strSize = MeasureTextEx(font, cast(const char*)text, fontSize, 2.0f);
		 DrawRectangleLines(cast(int)x, cast(int)y, cast(int)strSize.x + padding, cast(int)strSize.y + padding, color);
		 DrawText(cast(const char*) text, cast(int)x + (padding / 2), cast(int)y + (padding / 2), cast(int)fontSize, color);
	}
}

class Window
 {
	 void test()
	 {
		 InitWindow(1920, 1080, "0.001");

		 while (!WindowShouldClose())
		 {
			 BeginDrawing();
			 ClearBackground(rgba(34, 39, 46, 255));
			 Gui.DrawMiniMenu("Scape Game test", 20, 20, 20, rgba(0, 255, 100, 255), 15);
			 EndDrawing();
		 }

		 CloseWindow();
	 }
 }
