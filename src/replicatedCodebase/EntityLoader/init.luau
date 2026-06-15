local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local EntityPanel = require(script.EntityPanel)
local ReactReferences = require(script.Parent.ReactReferences)
local Renderer = require(script.Renderer)
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local Packets = require(ReplicatedStorage.Shared.Packets)

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PacketECSClient"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local reactRoot = ReactRoblox.createRoot(screenGui)
reactRoot:render(React.createElement(EntityPanel))

local entityVisual = ReactReferences:waitForRef("entityPanelVisual")
local entityStatTr = ReactReferences:waitForRef("entityPanelStatTr")

local canvasRenderer = Renderer:init(entityVisual, 256, 256)
local latestPositions: { any } = {}

Packets.StateSync.OnClientEvent:Connect(function(data)
	if data and data.positions then
		latestPositions = data.positions
	end
end)

local waypoints: { Vector2 } = {
	Vector2.new(20, 20),
	Vector2.new(230, 20),
	Vector2.new(230, 128),
	Vector2.new(30, 128),
	Vector2.new(30, 230),
	Vector2.new(230, 230),
}

local frameCount = 0
local lastFpsTime = tick()
local currentFps = 60

RunService.Heartbeat:Connect(function()
	frameCount += 1
	if tick() - lastFpsTime >= 0.5 then
		currentFps = math.floor(frameCount / (tick() - lastFpsTime))
		frameCount = 0
		lastFpsTime = tick()
	end

	entityStatTr.Text = string.format("FPS: %d\nEnemies: %d", currentFps, #latestPositions)
	canvasRenderer:clear(15, 17, 24)

	for i = 1, #waypoints - 1 do
		local p1, p2 = waypoints[i], waypoints[i + 1]
		canvasRenderer:drawRect(p1.X - 6, p1.Y - 6, (p2.X - p1.X) + 12, (p2.Y - p1.Y) + 12, 40, 45, 60)
	end

	for i = 1, #latestPositions do
		local pos = latestPositions[i]
		if pos then
			canvasRenderer:drawPixel(pos.x, pos.y, 220, 50, 70)
		end
	end

	canvasRenderer:flush()
end)

return {}
