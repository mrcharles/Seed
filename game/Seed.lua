
Seed = Base:new()

function Seed:init()
	self.size = vector(10, 10)
	self.offset = vector(-5,-5)

	Base.init(self)

end

function Seed:draw()
	love.graphics.push()

	love.graphics.translate(self.pos.x, self.pos.y)
	love.graphics.translate(-self.size.x / 2, -self.size.y)
	love.graphics.setColor(173, 69, 0)
	love.graphics.circle("fill", 0, self.size.y / 2, self.size.x / 2)

	love.graphics.pop()

	Base.draw(self)
end

function Seed:update(dt)

end
