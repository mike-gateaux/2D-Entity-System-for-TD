local AssetService = game:GetService("AssetService")

local bufferCreate = buffer.create
local bufferWriteU32 = buffer.writeu32
local bit32Bor = bit32.bor
local bit32Lshift = bit32.lshift

export type rendererProperties = {
	width: number,
	height: number,
	canvas: EditableImage,
	pixelBuffer: buffer,
}

export type rendererMethods = {
	clear: (rendererProperties, number, number, number) -> nil,
	drawPixel: (rendererProperties, number, number, number, number, number) -> nil,
	drawRect: (rendererProperties, number, number, number, number, number, number) -> nil,
	flush: (rendererProperties) -> nil,
}

export type renderInstance = rendererProperties & rendererMethods

local Renderer = {}
Renderer.__index = Renderer

local Methods = {}
Methods.__index = Methods

function Renderer:init(imageLabel: ImageLabel, width: number, height: number): renderInstance
	local canvas = AssetService:CreateEditableImage({ Size = Vector2.new(width, height) })

	local newRenderer = setmetatable({
		width = width,
		height = height,
		canvas = canvas,
		pixelBuffer = bufferCreate(width * height * 4),
	}, Methods)

	imageLabel.ImageContent = Content.fromObject(canvas)

	return newRenderer
end

function Methods.clear(self: renderInstance, r: number, g: number, b: number)
	local totalPixels = self.width * self.height
	local colorValue = bit32Bor(r, bit32Lshift(g, 8), bit32Lshift(b, 16), bit32Lshift(255, 24))

	for index = 0, totalPixels - 1 do
		bufferWriteU32(self.pixelBuffer, index * 4, colorValue)
	end
end

function Methods.drawPixel(self: renderInstance, x: number, y: number, r: number, g: number, b: number)
	local intX = math.floor(x)
	local intY = math.floor(y)

	if intX < 0 or intX >= self.width or intY < 0 or intY >= self.height then
		return
	end

	local byteOffset = (intY * self.width + intX) * 4
	local colorValue = bit32Bor(r, bit32Lshift(g, 8), bit32Lshift(b, 16), bit32Lshift(255, 24))
	bufferWriteU32(self.pixelBuffer, byteOffset, colorValue)
end

function Methods.drawRect(
	self: renderInstance,
	x: number,
	y: number,
	w: number,
	h: number,
	r: number,
	g: number,
	b: number
)
	local startX = math.floor(x)
	local startY = math.floor(y)
	local endX = startX + math.floor(w) - 1
	local endY = startY + math.floor(h) - 1

	for px = startX, endX do
		for py = startY, endY do
			self:drawPixel(px, py, r, g, b)
		end
	end
end

function Methods.flush(self: renderInstance)
	self.canvas:WritePixelsBuffer(Vector2.zero, Vector2.new(self.width, self.height), self.pixelBuffer)
end

return Renderer
