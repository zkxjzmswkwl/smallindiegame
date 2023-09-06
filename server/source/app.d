import std.stdio;
import equipment;

void main()
{
	const auto specialAttack = new SpecialAttack(
		1,      // id
		0.0,	// chargeRate
		0.0,	// chargeCost
		"null",	// name
		"null",	// description
	);

	const auto testSword = new Weapon(69, 100, specialAttack);
	writeln(testSword.getDamage());
}
