local EntityStorage = require(script.Parent.EntityStorage)

type Storage = EntityStorage.storageInstance

export type coreProperties = {
	nextEntityId: number,
	components: { [string]: Storage },
}

export type coreMethods = {
	createEntity: (coreProperties, string) -> number,
	registerComponent: (coreProperties, string) -> Storage,
	add: (coreProperties, number, any) -> nil,
	addBatch: (coreProperties, number, { [string]: any }) -> nil,
	remove: (coreProperties, number, string) -> nil,
}

export type coreInstance = coreProperties & coreMethods

local Core = {}
Core.__index = Core

local Methods = {}
Methods.__index = Methods

function Core:init(): coreInstance
	local newCoreInstance = setmetatable({
		nextEntityId = 1,
		components = {},
	}, Methods)

	return newCoreInstance
end

function Methods.createEntity(self: coreInstance): number
	local entityId = self.nextEntityId
	self.nextEntityId += 1

	return entityId
end

function Methods.registerComponent(self: coreInstance, name: string): Storage
	if not self.components[name] then
		self.components[name] = EntityStorage:init()
	end
	return self.components[name]
end

function Methods.add(self: coreInstance, entityId: number, name: string, data: any)
	local store = self.components[name] or self:registerComponent(name)
	store:insert(entityId, data)
end

function Methods.addBatch(self: coreInstance, entityId: number, componentMap: { [string]: any })
	for name, data in pairs(componentMap) do
		local store = self.components[name] or self:registerComponent(name)
		store:insert(entityId, data)
	end
end

function Methods.remove(self: coreInstance, entityId: number, name: string)
	local store = self.components[name]

	if store then
		store:remove(entityId)
	end
end

return Core
