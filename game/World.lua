vector = require("hump.vector")
require("Seed")

World = Base:new()
World.pctsky = 0.15
World.pcthorizon = 0.15
World.objects = {}

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

	for i,v in ipairs(self.objects) do
		v:draw()
	end
end

-- t,l,b,r
function World:getGroundBounds()
	local t =  { 
		top = love.graphics.getHeight() * ( self.pctsky + self.pcthorizon),
		left = 0,
		bottom = love.graphics.getHeight(),
		right = love.graphics.getWidth(),
	}

	return t
end

function World:addObject(obj)
	table.insert(self.objects, obj)
end

function World:randomSpot()
	local bounds = self:getGroundBounds()

	return vector( bounds.left + (bounds.right - bounds.left) * math.random(),
				    bounds.top + (bounds.bottom - bounds.top) * math.random() ) 

end

function World:create()
	--add initial seed somewhere:
	local seed = Seed:new()

	seed.pos = self:randomSpot()

	self:addObject(seed)

end

function World:getClickedObject(x, y)
	for i,obj in ipairs(self.objects) do
		if obj:inBounds(vector(x,y)) then
			return obj
		end
	end
end

function World:update(dt)
	for i,v in ipairs(self.objects) do
		v:update(dt)
	end
end
