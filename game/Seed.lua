require "Base"
require "Plant"
require "AlphaEffect"
require "Tools"

Seed = Base:new()

function Seed:init(plant)
	self.size = vector(10, 10)
	self.offset = vector(3,3)

	self.snapshot = love.graphics.newCanvas(128,128)

	love.graphics.setCanvas(self.snapshot)
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",0,0, 128,128)
	love.graphics.translate(64,0)
	if plant then
		plant:draw(true)
	else
		love.graphics.setFont(Tools.fontMainLarge)
		love.graphics.setColorMode("modulate")
		love.graphics.setColor(128,128,255)
		love.graphics.printf("?", 0, 0, 1000)
	end
	love.graphics.setCanvas()

	Base.init(self)

	Seed.image = love.graphics.newImage("res/sprites/seed.png")--.."/palette.png")
	Seed.image:setFilter("linear", "linear")

	Seed.effect = AlphaEffect:new()
	Seed.effect:load()
end

function Seed:draw()
	love.graphics.push()

	--love.graphics.translate(self.pos.x, self.pos.y)
	----love.graphics.translate(-self.offset.x / 2, -self.offset.y)
	--love.graphics.setColor(173, 69, 0)
	--love.graphics.circle("fill", 0, 0, self.size.x / 2)

	Seed.effect:setAlpha(1.0)
	Seed.effect:setEffect()
	love.graphics.translate(self.pos.x, self.pos.y)
	love.graphics.translate(-self.offset.x, -self.offset.y)
	love.graphics.draw(Seed.image, 0, 0, 0,  1, 1, 0, 0)
	Seed.effect:clearEffect()

	love.graphics.pop()

	Base.draw(self)
end

function Seed:makePlant()
	local plant = Plant:new()
	plant:init(self)

	return plant

end

function Seed:update(dt)
	Base.update(self, dt)
end
