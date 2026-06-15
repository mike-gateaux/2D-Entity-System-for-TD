--!strict
--!optimize 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packet = require(ReplicatedStorage.Packages.Packet)

return {
	SpawnRequest = Packet("SpawnRequest", {
		amount = Packet.NumberU32,
		speed = Packet.NumberU8,
		perSecond = Packet.NumberU16,
	}),

	StateSync = Packet("StateSync", {
		positions = { {
			x = Packet.NumberU16,
			y = Packet.NumberU16,
		} },
	}),
}
