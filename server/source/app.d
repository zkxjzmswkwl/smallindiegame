import std.stdio;
import core.thread;
import equipment;
import networking.server;

void main()
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

	// Testing crude packet intake
	auto server = new Server();
	while (1)
	{
		server.process();
		Thread.sleep(dur!("msecs")(25));
	}
}
