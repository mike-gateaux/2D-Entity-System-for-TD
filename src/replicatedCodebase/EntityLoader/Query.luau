local EntityCore = require(script.Parent.EntityCore)

type core = EntityCore.coreInstance

local Query = {}

function Query:iter(core: core, componentNames: { string })
	local stores = {}
	for _, name in ipairs(componentNames) do
		local store = core.components[name]
		if not store then
			return function()
				return nil
			end
		end
		table.insert(stores, store)
	end

	table.sort(stores, function(a, b)
		return a.size < b.size
	end)

	local primaryStore = stores[1]
	if not primaryStore then
		return function()
			return nil
		end
	end

	local denseArray = primaryStore.dense
	local currentIndex = 0
	local totalSize = primaryStore.size

	return function(): (number?, ...any)
		while currentIndex < totalSize do
			currentIndex += 1
			local entityId = denseArray[currentIndex]

			if not entityId then
				continue
			end

			local isValid = true
			local componentValues = {}

			for i = 1, #stores do
				local val = stores[i]:get(entityId)
				if val == nil then
					isValid = false
					break
				end
				componentValues[i] = val
			end

			if isValid then
				return entityId, unpack(componentValues)
			end
		end

		return nil
	end
end

return Query
