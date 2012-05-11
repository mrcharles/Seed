vector = require("hump.vector")
require("Seed")
require ("Plant")

World = Base:new()
World.pctsky = 0.6
World.pcthorizon = 0.25
World.objects = {}

World.minx = -2000
World.maxx = 2000

World.groundresolution = 50
World.ground = {}


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

	if DRAWGROUND then
		self:debugDrawGround()
	end

	for i,v in ipairs(self.objects) do
		v:draw()
	end


end

-- t,l,b,r
function World:getGroundBounds()
	local t =  { 
		top = self:getGroundHeight(),
		left = 0,
		bottom = self:getGroundHeight(),
		right = love.graphics.getWidth(),
	}

	return t
end

function World:getGroundHeight()
	return love.graphics.getHeight() * (self.pctsky + self.pcthorizon) 
end

function World:addObject(obj)
	obj.world = self
	table.insert(self.objects, obj)
end

function World:removeObject(obj)
    for i, v in ipairs(self.objects) do
    if v == obj then
    	v.world = nil
        table.remove(self.objects,i)
        return
    end
end

end


function World:randomSpot()
	local bounds = self:getGroundBounds()

	return vector( bounds.left + (bounds.right - bounds.left) * math.random(),
				    bounds.top + (bounds.bottom - bounds.top) * math.random() ) 

end

function World:debugDrawGround()

	local y = self:getGroundHeight()
	for i=1,table.maxn(self.ground) do
		slice = self.ground[i]

		local x = self.minx + (i - 1) * self.groundresolution
		local mx = self.minx + i * self.groundresolution

		--draw radiation as horizontal line

		local a = slice.radiation * 255
		love.graphics.setColor(255, 0, 0, a)
		love.graphics.line(x, y, mx, y)

		-- draw nutrition as a brown line
		local nx = x + (mx - x) * 0.4
		love.graphics.setColor(114,45,0)
		love.graphics.line(nx, y, nx, y - slice.nutrition * 50)

		-- draw water as a blue line
		local wx = x + (mx - x) * 0.6
		love.graphics.setColor(0,255,255)
		love.graphics.line(wx, y, wx, y - slice.water * 50)
	end

end


function World:create()
	--initialize our ground data
	local slices = (self.maxx - self.minx) / self.groundresolution
	for i=1,slices do
	 	local slice = {
	 		nutrition = math.random() * 0.2,
	 		water = math.random() * 0.2,
	 		radiation = math.random() * 0.6
		}
		table.insert(self.ground, slice)
	 end 



	--add initial seed somewhere:
	local seed = Seed:new()
	seed:init()

	seed.genetics = {
		planttype = PlantType.Flower,
		size = 1.0,
		growspeed = 10.0,
		color = { 128, 0, 128 }
	}

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
