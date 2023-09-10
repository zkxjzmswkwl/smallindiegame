import std.stdio;

import std.conv : to;
import std.concurrency;
import equipment;
import networking.server;

void testEquipmentShit()
{
	// Testing  
	auto specialAttack = new SpecialAttack(
		1,      // id
		0.0,	// chargeRate
		0.0,	// chargeCost
		"null",	// name
		"null",	// description
	);

	const auto testSword = new Weapon(69, 100, specialAttack);
	writeln(testSword.getDamage());
}

void main()
{
	/* 
	 * `Server` loop runs on main thread
	 * `Server` instantiation results in the creation and subsequent running of `World` thread.
	 * `Server` loop receives incoming messages, deserializes them into `Packet` objects and uses 
	   d's messaging protocol to pass them to the `World` thread.
	 * The `World` thread then processes those messages and invokes the corresponding logic for each.
	 * ....profit?
	*/
	auto server = new Server();
	server.loadWorld();
	auto serverTid = server.id;
	server.start();
}
