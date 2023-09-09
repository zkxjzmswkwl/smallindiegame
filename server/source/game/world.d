module game.world;

import std.stdio;
import core.thread;
import std.concurrency;

import game.player;
import networking.server;
import networking.packet;


struct CancelMessage {}

class World : Thread
{
private:
	Tid parentTid;
	//
	// All players connected to the world.
	//
	Player[] players;
	//
	// When false the world will destruct after current iteration.
	//
	bool shouldProcess;

	void run()
	{
		send(parentTid, thisTid);
		while (this.shouldProcess)
		{
			receive(
			(shared Packet packet) {
				// ??? why is this allowed?
				// It works??
				auto a = cast(Packet) packet;
				a.print();
				a.printBytes();
			},
			(CancelMessage m) {
				writeln("Processing stopped.");
				this.shouldProcess = false;
			});
		}
	}

public:
	this(Tid parentTid)
	{
		this.parentTid = parentTid;
		this.shouldProcess = true;
		super(&run);
	}
}
