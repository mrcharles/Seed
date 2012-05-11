require "Base"
require "hump.vector"

Player = Base:new()



function Player:update(dt)

end

function Player:draw()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, 30, 50)
	Base.draw(self)
end

function Player:moveTo(v)
	self.pos = v
end