require "Base"

Plant = Base:new()

function Plant:init(seed)
	self.size = vector(10, 20)

	--self.pos = seed.pos
	Base.init(self)
end

function Plant:update(dt)

end

function Plant:draw()
	love.graphics.push()
	love.graphics.translate(self.pos.x, self.pos.y)
	love.graphics.setColor(173, 200, 0)
	love.graphics.rectangle("fill", -5, -10, 10, 20)
	love.graphics.pop()
end