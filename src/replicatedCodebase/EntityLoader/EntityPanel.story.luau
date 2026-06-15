local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EntityPanel = require(script.Parent.EntityPanel)
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

return function(canvas)
	local root = ReactRoblox.createRoot(canvas)
	root:render(React.createElement(EntityPanel))

	return function()
		root:unmount()
	end
end
