export type storageProperties = {
	dense: { number },
	sparse: { number },
	data: { any },
	size: number,
}

export type storageMethods = {
	dense: (storageProperties, number, any) -> nil,
	sparse: (storageProperties, number) -> boolean,
	get: (storageProperties, number) -> any | nil,
}

export type storageInstance = storageProperties & storageMethods

local Storage = {}
Storage.__index = Storage

local Methods = {}
Methods.__index = Methods

function Storage:init(): storageInstance
	local newStore = setmetatable({
		dense = {},
		sparse = {},
		data = {},
		size = 0,
	}, Methods)

	return newStore
end

function Methods.insert(self: storageProperties, entityId: number, value: any)
	local dense = self.dense
	local sparse = self.sparse
	local data = self.data

	if sparse[entityId] and sparse[entityId] <= self.size and dense[sparse[entityId]] == entityId then
		data[sparse[entityId]] = value
		return
	end

	self.size += 1
	local index = self.size
	dense[index] = entityId
	sparse[entityId] = index
	data[index] = value
end

function Methods.remove(self: storageProperties, entityId: number): boolean
	local sparse = self.sparse
	local dense = self.dense
	local data = self.data

	local index = sparse[entityId]
	if not index or index > self.size or dense[index] ~= entityId then
		return false
	end

	local swappedEntity = dense[self.size]
	dense[index] = swappedEntity
	data[index] = data[self.size]
	sparse[swappedEntity] = index

	dense[self.size] = nil
	data[self.size] = nil
	sparse[entityId] = nil

	self.size -= 1
	return true
end

function Methods.get(self: storageProperties, entityId: number): any
	local index = self.sparse[entityId]
	if index and index <= self.size and self.dense[index] == entityId then
		return self.data[index]
	end
	return nil
end

return Storage
