/* The idea is to load these objects from disk at each run.
Each object here is to be immutable once initialized.

See: https://dlang.org/spec/const3.html */

enum ItemType
{
	// Armor
	ARMOR_HEAD,
	ARMOR_TORSO,
	ARMOR_HANDS,
	ARMOR_LEGS,
	ARMOR_FEET,

	// Weapons
	WEAPON,
	WEAPON_2H,

	// Consumables
	FOOD,
	POTION,
	RUNE,
	ARROW,
	THROWN
}

// Structs are copied by value in D, so these are classes.
// Meaning if we mutate a class instance after passing it somewhere else,
// we're going to have a bad time.
class Stats
{
	short meleeDefense;
	short magicDefense;
	short rangedDefense;

	short meleeIncrease;
	short magicIncrease;
	short rangedIncrease;
}

class SpecialAttack
{
	this(ushort id, float chargeRate, float chargeCost, string name, string description)
	{
		this.id = id;
		this.chargeRate = chargeRate;
		this.chargeCost = chargeCost;
		this.name = name;
		this.description = description;
	}
	/*-------------------------*/
	private ushort id;
	private float chargeRate;
	private float chargeCost;
	private string name;
	private string description;
	/*-------------------------*/
	ushort getId() const
	{
		return this.id;
	}
	/*-------------------------*/
	float getChargeRate() const
	{
		return this.chargeRate;
	}
	/*-------------------------*/
	float getChargeCost() const
	{
		return this.chargeCost;
	}
	/*-------------------------*/
	string getName() const
	{
		return this.name;
	}
	/*-------------------------*/
	string getDescription() const
	{
		return this.description;
	}
	/*-------------------------*/
}

abstract class Item
{
	private ushort id;
	private string name;
	private string description;
	private Stats stats;
	private ItemType type;
	/*-------------------------*/
	ushort getId()
	{
		return this.id;
	}
	/*-------------------------*/
	string getName()
	{
		return this.name;
	}
	/*-------------------------*/
	string getDescription()
	{
		return this.description;
	}
	/*-------------------------*/
	Stats getStats()
	{
		return this.stats;
	}
	/*-------------------------*/
	ItemType getType()
	{
		return this.type;
	}
	/*-------------------------*/
}

class Weapon : Item
{
	private uint damage;
	private ushort range;
	/* I think it'd be fine to create one SpecialAttack
	object with the name of "null" and zero'd out stats
	that is used to signify when a weapon doesn't have a 
	special attack. */
	private SpecialAttack specialAttack;
	/*-------------------------*/
	this(uint damage, ushort range, SpecialAttack specialAttack)
	{
		this.damage = damage;
		this.range = range;
		this.specialAttack = specialAttack;
	}
	/*-------------------------*/
	uint getDamage() const
	{
		return this.damage;
	}
	/*-------------------------*/
	ushort getRange() const
	{
		return this.range;
	}
	/*-------------------------*/
	SpecialAttack getSpecial() 
	{
		return this.specialAttack;
	}
	/*-------------------------*/
}
