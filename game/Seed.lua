
Seed = Base:new()
Seed.size = vector(10, 10)

function Seed:draw()
	love.graphics.push()

	love.graphics.translate(self.pos.x, self.pos.y)
	love.graphics.translate(-self.size.x / 2, -self.size.y)
	love.graphics.setColor(173, 69, 0)
	love.graphics.circle("fill", 0, self.size.y / 2, self.size.x / 2)

	love.graphics.pop()
end

function Seed:update(dt)

end
