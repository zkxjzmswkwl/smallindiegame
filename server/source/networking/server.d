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

class Server : Thread
{
private:
	TcpSocket socket;
	SocketSet readSet;
	SocketSet writeSet;
	SocketSet errorSet;
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
	char[1024] tmpBuffer;
	//
	// When set to false, the server will close.
	//
	bool shouldProcess;

	void processNewClients()
	{
		if (readSet.isSet(socket))
		{
			Socket newClient = socket.accept();
			clients ~= newClient;
			writeln("New client");
		}
	}

	void processReceived()
	{
		// Fairly certain I need to append the listening socket??
		readSet.add(socket);
		for (int i = 0; i < clients.length; i++)
		{
			// Add each client to the readset. I don't get why still?
			readSet.add(clients[i]);
			// if the new client's state is invalid, move on.
			if (!readSet.isSet(clients[i]))
				continue;

			// I *think* this does not copy?
			// From my understanding it ends up being a reference.
			auto byteCount = clients[i].receive(tmpBuffer[]);
			if (byteCount == Socket.ERROR)
			{
				clients[i].close();
				// This should work no????
				clients = clients.remove(i);
				writeln("Connection error, client closed: ", byteCount);
				continue;
			}
			// 0 bytes received and no error = client's gone
			// TODO: Test whether or not this is zero if the client's
			// simply not responding.
			if (byteCount == 0)
			{
				writeln("Client has terminated connection.");
				continue;
			}
			// That being said, because it's a reference, 
			// it's not guaranteed have the lifetime we may expect or need.
			// so .dup is necessary, I *think*.

			// This is test nuke 
			auto packet = new Packet(tmpBuffer.dup, cast(ushort)byteCount);
			// this shared cast feels like an illegal maneuver no?
			send(this.worldTid, cast(shared)packet);
			// - 


			// call out to some logic that identifies packet type and calls out to corresponding logic
			// TODO - implement that.

			// Again - I'm still unsure why I'm meant to be using these at all?
			readSet.reset();
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
			writeln(this.config.host, ",", this.config.port, ",", this.config.tickRate, ",", this.config.setCapacity, ",", this.config.backlog);
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
		this.socket.bind(new InternetAddress(this.config.port));
		// Weird thing, the docs on listen aren't very clear.
		// I think they meant that it's the maximum amount of queued connections?
		this.socket.listen(this.config.backlog);
		// 500 being the initial capacity.
		this.readSet = new SocketSet(this.config.setCapacity);
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
