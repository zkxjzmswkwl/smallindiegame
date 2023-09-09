import std.stdio;
import networking.connection;
import window;

void main()
{
/*	auto window = new Window();
	window.test();
*/

	auto con = new Connection("localhost", 3195);
	con.test();
}
