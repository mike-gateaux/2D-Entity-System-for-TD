--!strict
--!optimize 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packets = require(ReplicatedStorage.Shared.Packets)

type entityData = {
	x: number,
	y: number,
	waypointIndex: number,
	speed: number,
}

local entities: { entityData } = {}

local waypoints: { Vector2 } = {
	Vector2.new(20, 20),
	Vector2.new(230, 20),
	Vector2.new(230, 128),
	Vector2.new(30, 128),
	Vector2.new(30, 230),
	Vector2.new(230, 230),
}

Packets.SpawnRequest.OnServerEvent:Connect(function(_, data)
	local spawnCount = math.clamp(data.amount or 1, 1, 2 ^ 16 - 1)

	for _ = 1, spawnCount do
		if #entities > spawnCount then
			continue
		end

		table.insert(entities, {
			x = waypoints[1].X,
			y = waypoints[1].Y,
			waypointIndex = 2,
			speed = data.speed,
		})

		task.wait(1 / data.perSecond)
	end
end)

RunService.Heartbeat:Connect(function(deltaTime)
	local count = math.clamp(#entities or 0, 0, 2 ^ 16 - 1)

	if count < 1 then
		return
	end

	local positionPayload = {}
	local activeCount = 0

	local k = 1

	while k <= #entities do
		local ent = entities[k]
		local target = waypoints[ent.waypointIndex]

		if target then
			local dx = target.X - ent.x
			local dy = target.Y - ent.y
			local dist = math.sqrt(dx * dx + dy * dy)
			local step = ent.speed * deltaTime

			if dist <= step then
				ent.x = target.X
				ent.y = target.Y
				ent.waypointIndex += 1
			else
				ent.x += (dx / dist) * step
				ent.y += (dy / dist) * step
			end

			activeCount += 1
			k += 1

			positionPayload[activeCount] = {
				x = math.clamp(math.floor(ent.x), 0, 255),
				y = math.clamp(math.floor(ent.y), 0, 255),
			}
		else
			table.remove(entities, k)
		end
	end

	if activeCount > 0 then
		Packets.StateSync:Fire({
			positions = positionPayload,
		})
	end
end)

return {}
