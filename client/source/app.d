import std.stdio;
import core.thread;
import networking.connection;
import window;

void main()
{
	auto con = new Connection("localhost", 3195);
	con.start();

	auto window = new Window();
	window.test();
}
