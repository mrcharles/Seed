vector = require("hump.vector")
require("Seed")
require ("Plant")

World = Base:new()
World.pctsky = 0.6
World.pcthorizon = 0.25
World.objects = {}

World.minx = -2000
World.maxx = 2000
World.thickness = 100

World.groundresolution = 50
World.ground = {}

local physobjs = {}

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

	if DRAWPHYSICS then
		love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
		love.graphics.polygon("fill", physobjs.ground.body:getWorldPoints(physobjs.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

		for i,v in ipairs(physobjs) do
			love.graphics.setColor(255, 0, 0) --set the drawing color to red for the ball
			love.graphics.circle("fill", v.body:getX(), v.body:getY(), v.shape:getRadius())
		end
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
	if obj.onAddToWorld then
		obj:onAddToWorld(self)
	end
	table.insert(self.objects, obj)
end

function World:removeObject(obj)
    for i, v in ipairs(self.objects) do
    if v == obj then
    	v.world = nil
        table.remove(self.objects,i)

        if v.physics then

        end

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

function World:getPatch(pos)
	local index = math.floor( (pos.x - self.minx) / self.groundresolution ) + 1
	return self.ground[index]
end


function World:init()
	love.physics.setMeter(128)
	local world = love.physics.newWorld(0, 9.81 * 128, true)

	self.physworld = world

	physobjs.ground = {}
	physobjs.ground.body = love.physics.newBody(world, 0, self:getGroundHeight() + self.thickness / 2)
	physobjs.ground.shape = love.physics.newRectangleShape( self.maxx - self.minx, self.thickness)
	physobjs.ground.fixture = love.physics.newFixture(physobjs.ground.body, physobjs.ground.shape)



end

function World:addCirclePhysics(obj)
	local circle = {}
	
	circle.body = love.physics.newBody(self.physworld, obj.pos.x, obj.pos.y, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	circle.body:setMass(15) --give it a mass of 15
	circle.body:setAngularDamping(12)
	circle.shape = love.physics.newCircleShape( obj.size.x / 2 ) --the ball's shape has a radius of 20
	circle.fixture = love.physics.newFixture(circle.body, circle.shape, 1) --attach shape to body and give it a friction of 1
	circle.fixture:setRestitution(0.2) --let the ball bounce

	obj.physics = circle

	table.insert( physobjs, circle )

	--circle.body:applyForce(0,1)
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
		color = { 128, 0, 128 },
		seedrate = 3
	}

	seed.pos = self:randomSpot() + vector(0, -100)

	self:addObject(seed)
	self:addCirclePhysics(seed)

end

function World:getClickedObject(x, y)
	for i,obj in ipairs(self.objects) do
		if obj:inBounds(vector(x,y)) then
			return obj
		end
	end
end



function World:update(dt)
	self.physworld:update(dt)
	for i,v in ipairs(self.objects) do
		v:update(dt)
	end
end
