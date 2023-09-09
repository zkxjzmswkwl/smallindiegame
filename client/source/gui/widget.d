module gui.widget;
import std.stdio;

import raylib;

abstract class Widget
{
	private int x, y, w, h;
	private Color color;
	private Color testColor;

	this(int x, int y, int w, int h, Color color, Color testColor)
	{
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.color = color;
		this.testColor = testColor;
	}

	Widget grow(int amt)
	{
		this.x += amt;
		this.y += amt;
		return this;
	}

	abstract void draw();
}

class MiniMenu : Widget
{
	private int padding;
	private int fontSize;
	private string str;
	private Vector2 strSize;

	this(int x, int y, int w, int h, Color color, Color testColor)
	{
		this.padding = padding;
		super(x, y, w, h, color, testColor);
	}

	bool isHovered()
	{
		auto mousePos = GetMousePosition();
		return(mousePos.x >= x && mousePos.x <= x + strSize.x + padding) && 
			(mousePos.y >= y && mousePos.y <= y + strSize.y + padding);
	}

	MiniMenu setStr(string str)
	{
		auto font = GetFontDefault();
		this.str = str;
		this.strSize = MeasureTextEx(font, cast(const char*)str, fontSize, 2.0f);
		return this;
	}

	MiniMenu setPadding(int padding)
	{
		this.padding = padding;
		return this;
	}

	MiniMenu setFontSize(int fontSize)
	{
		this.fontSize = fontSize;
		return this;
	}

	override
	void draw()
	{
		// TODO: figure out a way to handle the casting madness that's going on here.
		// Testing
		if (isHovered())
		{
			DrawRectangleLines(cast(int)x, cast(int)y, cast(int)strSize.x + padding, cast(int)strSize.y + padding, testColor);
			DrawText(cast(const char*) str, cast(int)x + (padding / 2), cast(int)y + (padding / 2), cast(int)fontSize, testColor);
			return;
		}

		DrawRectangleLines(cast(int)x, cast(int)y, cast(int)strSize.x + padding, cast(int)strSize.y + padding, color);
		DrawText(cast(const char*) str, cast(int)x + (padding / 2), cast(int)y + (padding / 2), cast(int)fontSize, color);
	}
}
