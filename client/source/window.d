import std.conv;
import raylib;
import gui.widget;

Color rgba(int re, int gr, int bl, int al) {
    return Color(cast(ubyte)re, cast(ubyte)gr, cast(ubyte)bl, cast(ubyte)al);
}

void testDrawConsole()
{
	string output;
	string input;

	DrawRectangleLines(185, 10, 1700, 1050, rgba(255, 255, 255, 255));
	DrawText("im gay\n12323123123b\nadfasdfasdf\nasdfasdfasdferwer\n", 205, 20, 20, rgba(0, 255, 100, 255));
	DrawRectangleLines(205, 985, 1650, 65, rgba(255, 255, 255, 255));
}

class Window
 {
	 void test()
	 {
		 InitWindow(1920, 1080, "0.001");
		 SetTargetFPS(60);

		 auto mmenu = new MiniMenu(10, 10, 20, 20, rgba(0, 255, 100, 255), rgba(255, 0, 255, 255));
		 mmenu
			 .setPadding(30)
			 .setFontSize(20)
			 .setStr("Test client");

		 auto mmmenu = new MiniMenu(960, 540, 80, 80, rgba(0, 255, 100, 255), rgba(255, 255, 100, 255));
		 mmmenu
			 .setPadding(40)
			 .setFontSize(20)
			 .setStr("Test\nTest\nTest\ttest\nTesttt");

		 auto texture = LoadTexture("assets/test.png");

		 while (!WindowShouldClose())
		 {
			 BeginDrawing();
			 {
				 ClearBackground(rgba(34, 39, 46, 255));
				 mmenu.draw();

				 testDrawConsole();
//				 mmmenu.draw();
//				 DrawTexture(texture, 20, 20, rgba(255, 255, 255, 255));
//				 Gui.DrawMiniMenu("Scape Game test", 20, 20, 20, rgba(0, 255, 100, 255), 15);
			 }
			 EndDrawing();
		 }

		 CloseWindow();
	 }
 }
