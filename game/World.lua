vector = require("hump.vector")
require ("Seed")
require ("Plant")
require ("Genetics")

World = Base:new()
World.pctsky = 0.6
World.pcthorizon = 0.34
World.objects = {}

World.minx = -2000
World.maxx = 2000
World.thickness = 100

World.radiationdensity = 0.1
World.radiationrange = 3
World.baserads = 0.5
World.radiationfalloff = 2.5

World.groundresolution = 50
World.ground = {}
World.quad = {}
World.image = {}

local physobjs = {}

function World:draw()
	love.graphics.setColorMode("replace")
	love.graphics.drawq(World.image, World.quad, 0, 0, 0, 
		0.5, 0.5, 
		0, 0)

	-- --draw sky
	-- love.graphics.setColor(128,128,255,100)
	-- love.graphics.rectangle("fill", 0,0, 
	-- 						love.graphics.getWidth(), love.graphics.getHeight() * self.pctsky)

	-- --draw horizon
	-- love.graphics.setColor(0, 128, 0, 100)
	-- love.graphics.rectangle("fill", 0, self.pctsky * love.graphics.getHeight(),
	-- 						love.graphics.getWidth(), love.graphics.getHeight() * self.pcthorizon)

	-- --draw ground
	-- love.graphics.setColor(0,192, 0, 100)
	-- love.graphics.rectangle("fill", 0, (self.pctsky + self.pcthorizon) * love.graphics.getHeight(), 
	-- 						love.graphics.getWidth(), (1.0 - self.pctsky - self.pcthorizon) * love.graphics.getHeight())

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
			if v.body:isActive() then
				love.graphics.setColor(255, 0, 0) --set the drawing color to red for the ball
				love.graphics.circle("fill", v.body:getX(), v.body:getY(), v.shape:getRadius())
			end
		end
	end

	--love.graphics.draw(World.image, 0, 0, 0, 
	--	1, 1, 
	--	0, 0)
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
	if obj.physics then
		obj.physics.body:setActive(true)
	end

	table.insert(self.objects, obj)
end

function World:removeObject(obj)
    for i, v in ipairs(self.objects) do
    if v == obj then
    	v.world = nil
        table.remove(self.objects,i)

        if v.physics then
        	v.physics.body:setActive(false)
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
		--draw it as a vertical line too cause ugh
		love.graphics.setColor(255,0,0)
		local nx = x + (mx - x) * 0.5
		love.graphics.line(nx, y, nx, y - slice.radiation * 100)


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

	World.image = love.graphics.newImage("res/bg.png")
	World.image:setFilter("linear", "linear")
	World.quad = love.graphics.newQuad(0, 0, World.image:getWidth(), World.image:getHeight(), World.image:getWidth(), World.image:getHeight())
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

function World:addRadiation(slice, rads)
	--if slice.radiation == 0.0 then 
	--	slice.radiation = slice.radiation + self.baserads + rads
	--else
		slice.radiation = slice.radiation + rads
	--end
end

function World:irradiate()
	local slices = (self.maxx - self.minx) / self.groundresolution
	local radcount = self.radiationdensity * slices

	for i=1,radcount do
		local sliceidx = math.random(slices) -- use this for even spacing: i * slices/radcount
		local slice = self.ground[sliceidx]
		local rads = math.random() * (1 - self.baserads)
		self:addRadiation(slice, self.baserads + rads)
		for i=-self.radiationrange,self.radiationrange do
			if i ~= 0 and sliceidx + i >= 1 and sliceidx + i <= slices then
				local s = self.ground[sliceidx + i]
				self:addRadiation(s, (slice.radiation)* ( math.pow(1 / self.radiationfalloff, math.abs(i)) ))
			end
		end
	end
end

function World:radReport()
	local min = 10000
	local max = 0

	for i,v in ipairs(self.ground) do
		min = math.min(min, v.radiation)
		max = math.max(max, v.radiation)
	end

	print( string.format("RADIATION REPORT: Min: %f, Max: %f", min, max))
end

function World:create()
	--initialize our ground data
	local slices = (self.maxx - self.minx) / self.groundresolution
	for i=1,slices do
	 	local slice = {
	 		nutrition = math.random() * 0.2,
	 		water = math.random() * 0.2,
	 		radiation = 0.0
		}
		table.insert(self.ground, slice)
	end 

	self:irradiate()

	self:radReport()

	--add initial seed somewhere:
	local seed = Seed:new()
	seed:init()

	--						value 			rate  					change 	min 				max 			floor
	Genetics:registerValue( "plantstyle", 	MutationRate.Rare, 		1, 		PlantStyle.Flower, 	PlantStyle.Tree, true)
	Genetics:registerValue( "size", 		MutationRate.Common, 	0.15, 	0.1, 				2)
	Genetics:registerValue( "growspeed", 	MutationRate.Uncommon, 	0.1, 	2)
	Genetics:registerValue( "color", 		MutationRate.Uncommon, 	20, 	0, 					255)
	Genetics:registerValue( "seedrate", 	MutationRate.Uncommon, 	1, 		0)
	Genetics:registerValue( "abiotic", 		MutationRate.Rare)
	Genetics:registerValue( "hasblossoms",	MutationRate.Rare)
	Genetics:registerValue( "hasleaves",	MutationRate.Rare)
	Genetics:registerValue( "blossomrate", 	MutationRate.Common, 	1, 		0)
	Genetics:registerValue( "blossomgrowspeed", MutationRate.Common,0.1, 	1)
	Genetics:registerValue( "leavesrate", 	MutationRate.Common, 	2, 		0)
	Genetics:registerValue( "leavesgrowspeed", MutationRate.Common, 0.1, 	1)
	Genetics:registerValue( "leavesdensity",  MutationRate.Common, 	0.2, 	0.2)
	--Genetics:registerValue( "blossomtype", 	MutationRate.Rare, 	1, 		1, amount of blossoms we have)
	--Genetics:registerValue( "leavestype", 	MutationRate.Rare, 	1, 		1, amount of leaves we have)
	--Genetics:registerValue( "planttype", 	MutationRate.Rare, 	1, 		1, amount of plants we have)



	seed.genetics = {
		plantstyle = PlantStyle.Flower,
		planttype = 1,
		size = 1.0,
		growspeed = 10.0,
		color = { 128, 0, 128 },
		seedrate = 2,
		abiotic = true,
		hasleaves = true,
		leavesrate = 4,
		leavestype = 1,
		leavesdensity = 0.7,
		leavesgrowspeed = 2.0,
		hasblossoms = true,
		blossomrate = 2,
		blossomtype = 1,
		blossomgrowspeed = 3.0,
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
