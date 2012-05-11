require "Base"
require "Plant"

Seed = Base:new()

function Seed:init(plant)
	self.size = vector(10, 10)
	self.offset = vector(0,0)

	if plant ~= nil then
		self.genetics = plant:reproduceGenetics()
	end

	Base.init(self)

end

function Seed:draw()
	love.graphics.push()

	love.graphics.translate(self.pos.x, self.pos.y)
	--love.graphics.translate(-self.offset.x / 2, -self.offset.y)
	love.graphics.setColor(173, 69, 0)
	love.graphics.circle("fill", 0, 0, self.size.x / 2)

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
