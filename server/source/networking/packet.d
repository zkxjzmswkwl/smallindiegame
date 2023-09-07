module networking.packet;

import std.stdio;

/* 
Need serialization/deserialization for obvious reasons.

	"packets": [
		{
			"opcode": 1,
			"size": 6
		},
		{
			"opcode": 2,
			"size": 8
		},
	]
*/
class Packet
{
private:
	char[1024] buffer;
	ushort opcode;
	long size;

public:
	// Likely the ctor you want when instantiating outbound packets 
	this(ushort opcode, ushort size)
	{
		this.opcode = opcode;
		this.size = size;
	}

	// Likely the ctor you want when instantiating inbound packets 
	this(char[] buffer, long size)
	{
		// From my understanding, this doesn't result
		// in any additional copying.
		this.buffer = buffer;
		this.size = size;

		writeln(size);
		writeln(this.buffer[0 .. size]);
	}
}
