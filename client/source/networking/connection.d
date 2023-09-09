module networking.connection;

import std.stdio;
import std.socket;


class Connection
{
	private Socket socket;
	private string host;
	private ushort port;

	this(string host="localhost", ushort port=3195)
	{
		writefln("%s:%d\n", host, port);
		this.host = host;
		this.port = port;
		this.socket = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);
	}

	public void test()
	{
		this.socket.connect(new InternetAddress(host, port));
		this.socket.send("lo");
		char[1024] buffer;
		auto byteCount = this.socket.receive(buffer);
		if (byteCount == SOCKET_ERROR)
		{
			writeln("Socket error ", byteCount); 
			return;
		}
		writeln(buffer[0 .. byteCount]);
		foreach (ref c; buffer[0 .. byteCount])
			printf("%02hhX ", c);
		printf("\n");
	}
}
