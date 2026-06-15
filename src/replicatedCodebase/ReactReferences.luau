local references = {}
local methods = {}
local listeners = {}

function methods:getRef(ref, callback)
	local refExists = references[ref] and references[ref].Parent ~= nil

	if callback and refExists then
		return callback(references[ref])
	end

	return refExists and references[ref] or nil
end

function methods:waitForRef(ref, callback)
	if references[ref] then
		return references[ref]
	end

	if not listeners[ref] then
		listeners[ref] = {}
	end

	table.insert(listeners[ref], { thread = coroutine.running(), callback = callback })

	return coroutine.yield()
end

function methods:onRefAvailable(ref, callback)
	coroutine.wrap(methods.waitForRef)({}, ref, callback)
end

function methods:setRef(key, ref)
	references[key] = ref

	if listeners[key] then
		for _, listener in listeners[key] do
			if listener.callback then
				task.spawn(listener.callback, ref)
			end

			task.spawn(listener.thread, ref)
		end

		table.clear(listeners[key])
	end

	return ref
end

return methods
