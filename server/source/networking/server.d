module networking.server;

import std.stdio;
import core.thread;
import std.algorithm.searching;
import std.socket;

import networking.packet;

class Server : Thread
{
private:
	TcpSocket socket;
	SocketSet readSet;
	SocketSet writeSet;
	SocketSet errorSet;
	Socket[] clients;
	char[1024] tmpBuffer;

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
		foreach (ref client; clients)
		{
			// Add each client to the readset. I don't get why still?
			readSet.add(client);
			// if the new client's state is invalid, move on.
			if (!readSet.isSet(client))
				continue;

			// I *think* this does not copy?
			// From my understanding it ends up being a reference.
			auto byteCount = client.receive(tmpBuffer[]);
			if (byteCount == Socket.ERROR)
			{
				client.close();
				writeln("Connection error, client closed.");
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
			auto packet = new Packet(tmpBuffer.dup, byteCount);
			// Again - I'm still unsure why I'm meant to be using these at all?
			readSet.reset();
		}
	}

	void processSent()
	{
		// Not implemented
	}
public:
	this()
	{
		this.socket = new TcpSocket();
		this.socket.bind(new InternetAddress(3195));
		// Weird thing, the docs on listen aren't very clear.
		// I think they meant that it's the maximum amount of queued connections?
		this.socket.listen(25);
		// 500 being the initial capacity.
		this.readSet = new SocketSet(500);
	}

	void process()
	{
		processNewClients();
		processReceived();
		processSent();
	}
}
