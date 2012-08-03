require "Base"
require "Plant"
require "AlphaEffect"
require "Tools"
require "Snapshot"

Seed = Base:new()

local uniqueid = 1

function Seed:init(plant)
	self.size = vector(10, 10)
	self.offset = vector(3,3)

	Base.init(self)

	if plant then
		self.parent = plant.id
	else
		self.parent = uniqueid
		uniqueid = uniqueid + 1
	end

	self.snapshot = Snapshot:new(plant, 256)

	Seed.image = love.graphics.newImage("res/sprites/seed.png")--.."/palette.png")
	Seed.image:setFilter("linear", "linear")

	Seed.effect = AlphaEffect:new()
	Seed.effect:load()
end

function Seed:draw(notranslation)
	love.graphics.push()

	--love.graphics.translate(self.pos.x, self.pos.y)
	----love.graphics.translate(-self.offset.x / 2, -self.offset.y)
	--love.graphics.setColor(173, 69, 0)
	--love.graphics.circle("fill", 0, 0, self.size.x / 2)

	Seed.effect:setAlpha(1.0)
	Seed.effect:setEffect()
	if not notranslation then
		love.graphics.translate(self.pos.x, self.pos.y)
	end
	love.graphics.translate(-self.offset.x, -self.offset.y)
	love.graphics.draw(Seed.image, 0, 0, 0,  1, 1, 0, 0)
	Seed.effect:clearEffect()

	love.graphics.pop()

	Base.draw(self)
end

function Seed:makePlant()
	local plant = Plant:new()
	plant:init(self)
	plant.id = uniqueid
	uniqueid = uniqueid + 1

	return plant

end

function Seed:update(dt)
	Base.update(self, dt)
end
