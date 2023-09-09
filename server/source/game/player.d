module game.player;

import game.vec;

class Player
{
	private string name;
	private string sessionCipherKey;
	//
	// Amount of mid-session renegotiations since initial handshake
	//
	private ushort renegotiations;
	private Vec3 position;

	this(string name, string sessionCipherKey="asswecan")
	{
		this.name = name;
		// TODO: Generate this here, don't require it to be passed in.
		this.sessionCipherKey = sessionCipherKey;
	}

	void setPosition(Vec3 position)
	{
		this.position = position;
	}

	void updatePosition(long x, long y, long z)
	{
		this.position.x = x;
		this.position.y = y;
		this.position.z = z;
	}
}
