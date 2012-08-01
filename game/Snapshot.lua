Snapshot = {}

function Snapshot:new (obj, size)
	local t = {}
	setmetatable(t, self)
	self.__index = self
	t:init(obj, size)
	return t
end

function Snapshot:init(obj, size)

	local actualsize = size
	if not obj then
		actualsize = 128
	end

	local canvas = love.graphics.newCanvas(actualsize,actualsize)

	love.graphics.setCanvas(canvas)
	love.graphics.setColor(255,255,255, 0)
	love.graphics.rectangle("fill",0,0, actualsize,actualsize)
	love.graphics.push()
	if obj then
		love.graphics.translate(actualsize/2,actualsize)
		love.graphics.setColor(255,255,255, 255)
		obj:draw(true)
	else
		love.graphics.translate(16,-16)
		love.graphics.setFont(Tools.fontMainLarge)
		love.graphics.setColorMode("modulate")
		love.graphics.setColor(128,128,255)
		love.graphics.printf("?", 0, 0, 1000)
	end
	love.graphics.pop()
	love.graphics.setCanvas()

	self.size = actualsize
	self.image = love.graphics.newImage(canvas:getImageData())
	self.quad = love.graphics.newQuad(0,0,actualsize,actualsize,actualsize,actualsize)
end

function Snapshot:draw(x, y, size, backcolor, zoomspeed)

	local rendersize = self.rendersize or size or self.size
	local zoomspeed = zoomspeed or 10

	if rendersize < size then
		self.rendersize = math.min(rendersize + zoomspeed, size)
	elseif rendersize > size then
		self.rendersize = math.max(rendersize - zoomspeed, size)
	else
		self.rendersize = rendersize
	end


	local scale = (self.rendersize) / self.size
	love.graphics.push()
	love.graphics.translate(x - self.rendersize / 2,y - self.rendersize / 2)
	love.graphics.setColor(backcolor)
	love.graphics.rectangle("fill", 0, 0, self.rendersize, self.rendersize)
	love.graphics.setColor(255,255,255,255)
	love.graphics.drawq( self.image, self.quad, 0, 0, 0, scale, scale )
	love.graphics.pop()
end