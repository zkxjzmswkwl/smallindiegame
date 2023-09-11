module networking.packet;

import std.conv : to;
import std.stdio;

/* 
Need serialization/deserialization for obvious reasons.

	"packets": [
		{
			"opcode": 1,
			"size": 6,
			"paramByteSizes": [
				2, 	// Short
				2, 	// Short
				4, 	// Integer 
			]
		},
		{
			"opcode": 2,
			"size": 8
		},
	]
*/

// testing
struct ReceivedPacket
{
	char[1024] buffer;
	ubyte opcode;
	ubyte size;
	ubyte[] paramByteSizes;
}
// - testing

class Packet
{
private:
	uint[1024] buffer;
	ushort offset;
	ushort opcode;
	ushort size;

public:
	// Likely the ctor you want when instantiating outbound packets 
	this(ushort opcode, ushort size)
	{
		this.opcode = opcode;
		this.size = size;
	}

	// Likely the ctor you want when instantiating inbound packets 
	this(uint[] buffer, ushort size)
	{
		// From my understanding, this doesn't result
		// in any additional copying.
		this.buffer = buffer;
		this.size = size;
	}

	uint[] getBuffer()
	{
		return this.buffer[0 .. offset];
	}

	void writeHeader()
	{
		writeByte(cast(ubyte)opcode);
		writeByte(cast(ubyte)size);
	}

	void print()
	{
		("Packet<" ~ to!string(this.size) ~ ">\t" ~ to!string(this.buffer[0 .. size])).writeln;
	}

	void printBytes()
	{
		foreach (ref c; buffer[0 .. size])
		{
			printf("%02hhX ", c);
		}
		printf("\n");
	}

	uint[] readNBytes(int n)
	{
		this.offset += n;
		return this.buffer[this.offset - n .. offset];
	}

	Packet extractCombinedPacket()
	{
		auto opcode = readByte();
		auto size = readByte();
		auto combinedBuffer = this.buffer[0 .. size];
		return new Packet(combinedBuffer.dup, size);
	}

	bool isSegmentStart()
	{
		// mov offset into originalOffset for safe keeping
		auto originalOffset = this.offset;
		// Skip over opcode/size, land on start of header magic numbers
		this.offset = cast(ushort)(originalOffset + 2);

		// We should cross-reference a container of defined opcodes for additional verification.
		auto headerBytes = readNBytes(3);
		foreach (c; headerBytes)
		{
			printf("%02hhX ", c);
		}
		printf("\n");
		// If the super secret magic values were present.
		if (headerBytes == [0x69, 0x69, 0x69])
		{
			this.offset = originalOffset;
			printBytes();
			return true;
		}
		// restore offset to what it was when we got here
		this.offset = originalOffset;
		return false;
	}

	void writeByte(ubyte val)
	{
		buffer[++offset - 1] = cast(ubyte)(val);
	}

	void writeShort(short val)
	{
		buffer[++offset - 1] = cast(ubyte)(val >> 8);
		buffer[++offset - 1] = cast(ubyte)(val);
	}

	void writeInt(int val)
	{
		buffer[++offset - 1] = cast(ubyte)(val >> 24);
		buffer[++offset - 1] = cast(ubyte)(val >> 16);
		buffer[++offset - 1] = cast(ubyte)(val >> 8);
		buffer[++offset - 1] = cast(ubyte)(val);
	}

	ubyte readByte()
	{
		offset++;
		return buffer[offset - 1] & 0xFF;
	}
	
	ushort readShort()
	{
		offset += 2;
		return ((buffer[offset - 2] & 0xFF) << 8) + (buffer[offset - 1] & 0xFF);
	}

	int readInt()
	{
		offset += 4;
		return 
			((buffer[offset - 4] & 0xFF) << 24) +
			((buffer[offset - 3] & 0xFF) << 16) + 
			((buffer[offset - 2] & 0xFF) << 8)  + (buffer[offset - 1] & 0xFF);
	}

	// Temp remove getOffset() - should never matter outside of the packet in production situations.
	ushort getOffset() { return this.offset; }

}

