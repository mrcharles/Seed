vector = require("hump.vector")

World = Base:new()
World.pctsky = 0.1
World.pcthorizon = 0.2


function World:draw()
	--draw sky
	love.graphics.setColor(128,128,255)
	love.graphics.rectangle("fill", 0,0, 
							love.graphics.getWidth(), love.graphics.getHeight() * self.pctsky)

	--draw horizon
	love.graphics.setColor(0, 128, 0)
	love.graphics.rectangle("fill", 0, self.pctsky * love.graphics.getHeight(),
							love.graphics.getWidth(), love.graphics.getHeight() * self.pcthorizon)

	--draw ground
	love.graphics.setColor(0,192, 0)
	love.graphics.rectangle("fill", 0, (self.pctsky + self.pcthorizon) * love.graphics.getHeight(), 
							love.graphics.getWidth(), (1.0 - self.pctsky - self.pcthorizon) * love.graphics.getHeight())

end

function World:update(dt)

end
