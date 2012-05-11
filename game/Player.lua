require "Base"
require "hump.vector"

Player = Base:new()

function Player:init()

	self.speed = 140
	self.size = vector(50, 80)
	self.offset = vector(0, -40)

	Base.init(self)
end



function Player:update(dt)
	if self.target ~= nil then
		local toTarget = self.target - self.pos
		local dir = toTarget:normalized()
		local dist = toTarget:len()

		local move = self.speed * dt


		if dist < move then
			self.pos = self.target
			self.target = nil
		else
			self.pos = self.pos + (dir * move)
		end


	end

end

function Player:draw()
	love.graphics.push()
	love.graphics.translate(-self.size.x / 2, -self.size.y)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, 50, 80)
	love.graphics.pop()

	Base.draw(self)
end

function Player:moveTo(v)
	self.target = v
end