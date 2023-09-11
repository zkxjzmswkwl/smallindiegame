module networking.connection;

import core.thread;
import std.stdio;
import std.socket;


class Connection : Thread
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
		super(&run);
	}

	public void test()
	{
		writeln("test");
		this.socket.connect(new InternetAddress(host, port));
		this.socket.send("lo");
		/*
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
		*/
	}

	private void run()
	{
		test();
		int offset = 0;
		ubyte[1024] buffer;
		buffer[++offset - 1] = cast(ubyte)(0x1);	// byte
		buffer[++offset - 1] = cast(ubyte)(0xA);	// byte
		buffer[++offset - 1] = cast(ubyte)(0x69);
		buffer[++offset - 1] = cast(ubyte)(0x69);	// short
		buffer[++offset - 1] = cast(ubyte)(0x69);
		buffer[++offset - 1] = cast(ubyte)(0x72);	// short
		buffer[++offset - 1] = cast(ubyte)(0x12);
		buffer[++offset - 1] = cast(ubyte)(0x42);
		buffer[++offset - 1] = cast(ubyte)(0x32);
		buffer[++offset - 1] = cast(ubyte)(0x22);	// int
		// 10 bytes total
		for (int i = 0; i <= 1; i++) {
			writeln(i);
			this.socket.send(buffer[0 .. 10]);
		}
	}
}
