module networking.server;

import std.file;
import std.stdio;
import std.array;
import std.socket;
import std.conv : to;
import std.algorithm;
import std.concurrency;
import core.thread;

import dackson;
import networking.packet;
import game.world;

struct ServerConfig
{
	string host;
	ushort port;
	ushort tickRate;
	int backlog;
	int setCapacity;
}

struct MessageDescriptor
{
	ubyte opcode;
	ubyte[] paramSizeOrder;
}

class Server : Thread
{
private:
	MessageDescriptor[] messageDescriptions = [
		// The idea is that you'll be able to infer
		//   - param count
		//   - param sizes
		//   - param order
		MessageDescriptor(
		0x1,		// Opcode
		[
			0x2,	// Short
			0x2,	// Short
			0x4		// int
		]),
		MessageDescriptor(0x2, [0x4, 0x4, 0x2]),
		MessageDescriptor(0x3, [0x2, 0x4]),
		MessageDescriptor(0x4, [0x4]),
	];
	TcpSocket socket;
	SocketSet readSet;
	SocketSet writeSet;
	SocketSet serverSet;
	//
	// Configuration, brought in from disk.
	//
	ServerConfig config;
	//
	// World object instantiated and thread started upon server config load.
	//
	World world;
	//
	// Tid object for World thread. Needed to send messages to it.
	//
	Tid worldTid;
	//
	// All connected clients socket. ?? english
	//
	Socket[] clients;
	//
	// Reference to current incoming packet buffer
	//
	ubyte[1024] tmpBuffer;
	//
	// When set to false, the server will close.
	//
	bool shouldProcess;
	//
	// Total amount of bytes the server had read this session.
	//
	long totalBytesRead;

	void processNewClients()
	{
		// if (readSet.isSet(socket))
		// {
		// 	Socket newClient = socket.accept();
		// 	clients ~= newClient;
		// 	writeln("New client");
		// }
	}

	void processReceived()
	{
		this.serverSet.reset();
		this.readSet.reset();
		this.serverSet.add(this.socket);

		// Accept new clients
		auto selectNew = Socket.select(this.serverSet, null, null);
		if (selectNew > 0)
		{
			auto newClient = this.socket.accept();
			clients ~= newClient;
			writeln("New client has connected: ", newClient.remoteAddress());
		}

		foreach (client; this.clients)
			this.readSet.add(client);

		auto readNew = Socket.select(this.readSet, null, null);
		if (readNew < 1)
			return;

		foreach (ref client; clients)
		{
			if (!readSet.isSet(client))
				continue;

			auto recv = client.receive(this.tmpBuffer);
			if (recv > 0)
			{
				foreach (ref c; tmpBuffer[0 .. recv])
					printf("%02hhX ", c);
				printf("\n");
			}
		}
	}

	void processSent()
	{
		// Not implemented
	}

	void run()
	{
		while(shouldProcess)
		{
			processNewClients();
			processReceived();
			processSent();
		}
	}

	bool loadConfiguration()
	{
		try
		{
			auto configContents = readText("serverconfig.json");
			this.config = decodeJson!(ServerConfig)(configContents);
			return true;
		}
		catch (FileException e)
		{
			writeln("Could not open serverconfig.json. The server will not start.");
			return false;
		}
	}
public:
	this()
	{
		// meh.
		this.loadConfiguration();

		this.socket = new TcpSocket();
		this.socket.blocking = false;
		this.socket.bind(new InternetAddress(this.config.port));
		// Weird thing, the docs on listen aren't very clear.
		// I think they meant that it's the maximum amount of queued connections?
		this.socket.listen(this.config.backlog);
		// 500 being the initial capacity.
		this.readSet = new SocketSet(this.config.setCapacity);
		this.serverSet = new SocketSet(this.config.setCapacity);
		// Flip if you want to kill the server.
		this.shouldProcess = true;
		super(&run);
	}

	// Probably make this a void later. not sure yet. World might have config too.
	bool loadWorld()
	{
		this.world = new World(thisTid);
		// test remove later
		this.world.start();
		// this is giga retarded no?
		// Once I learn more about the messaging system in D I'm sure this will change.
		bool hasWorldTid = false;
		while (!hasWorldTid)
		{
			receive(
				(Tid tid) {
					this.worldTid = tid;
					writeln("World TID:\t" ~ to!string(tid));
					hasWorldTid = true;
				}
			);
		}
		return true;
	}
}
