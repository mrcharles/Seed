Snapshot = {}

function Snapshot:new (obj, size)
	local t = {}
	setmetatable(t, self)
	self.__index = self
	t:init(obj, size)
	return t
end

function Snapshot:init(obj, size)
	local canvas = love.graphics.newCanvas(size,size)

	love.graphics.setCanvas(canvas)
	love.graphics.setColor(255,255,255, 0)
	love.graphics.rectangle("fill",0,0, size,size)
	love.graphics.push()
	if obj then
		love.graphics.translate(size/2,size)
		love.graphics.setColor(255,255,255, 255)
		obj:draw(true)
	else
		love.graphics.translate(size/2 - 16,size/2 + 16)
		love.graphics.setFont(Tools.fontMainLarge)
		love.graphics.setColorMode("modulate")
		love.graphics.setColor(128,128,255)
		love.graphics.printf("?", 0, 0, 1000)
	end
	love.graphics.pop()
	love.graphics.setCanvas()

	self.size = size
	self.image = love.graphics.newImage(canvas:getImageData())
	self.quad = love.graphics.newQuad(0,0,size,size,size,size)
end

function Snapshot:draw(x, y, size)

	local scale = (size or self.size) / self.size
	love.graphics.push()
	love.graphics.translate(x - size / 2,y - size / 2)
	love.graphics.setColor(255,255,255,255)
	love.graphics.drawq( self.image, self.quad, 0, 0, 0, scale, scale )
	love.graphics.pop()
end