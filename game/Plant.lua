require "Base"
require "Genetics"

PlantState = {
	Sprout = 1,
	Baby = 2,
	Young = 3,
	Mature = 4
}



PlantStyle = {
	Flower = 1,
	Bush = 2,
	Tree = 3,
}

Plant = Base:new()

Plant.blossomfrequency = 0.3
Plant.sizes = {
	{ -- flower
	vector( 5, 10 ),
	vector( 6, 20 ),
	vector( 6, 40 ),
	vector( 8, 60 )
	},
	{ -- Bush
	vector( 10, 10 ),
	vector( 25, 40 ),
	vector( 40, 50 ),
	vector( 70, 80 )
	},
	{ -- Tree
	vector( 10, 20 ),
	vector( 40, 30 ),
	vector( 80, 40 ),
	vector( 160, 60 )
	},
}

function Plant:getKeyName(t, val)
	for k,v in pairs(t) do
		if v == val then
			return k
		end
	end

	assert(false)
end

function Plant:makeDataName()
	return string.format("plantdata/%s%ddata.lua", self:getKeyName(PlantStyle, self.genetics.plantstyle), self.genetics.planttype)
end

function Plant:makeBlossomName()
	return string.format("plantdata/blossom%ddata.lua", self.genetics.blossomtype)
end

function Plant:init(seed)
	self.state = PlantState.Sprout

	--straight copy for right now
	self.genetics = seed.genetics

	self.growtime = 0

	self.leaves = {}
	self.blossoms = {}

	--load our data
	local chunk = love.filesystem.load( self:makeDataName() ) -- load the chunk 
	self.data = chunk()

	self.size = self:getSize()


	--self.pos = seed.pos
	Base.init(self)
end

function Plant:onAddToWorld(world)
	self.ground = world:getPatch(self.pos)
end

function Plant:reproduceGenetics()
	return self.genetics
end

function Plant:makeSeed()
	local seed = Seed:new()
	seed:init(self)
	seed.pos = self.pos
	self.world:addObject(seed)
	self.world:addCirclePhysics(seed)

	seed.genetics = Genetics:asexualMutate(self.genetics)

	return seed
end

function Plant:getNewBlossomPoint()
	local state = self.data[self.state]
	assert( table.maxn(self.blossoms) < table.maxn(state.blossompoints))
	return table.maxn(self.blossoms) + 1
end

function Plant:hasBlossomPoints()
	local state = self.data[self.state]
	if state.blossompoints then
		if table.maxn(self.blossoms) < table.maxn(state.blossompoints) then
			return true
		end
	end

end

--this shit is going to spam memroy like a motherfucker
function Plant:loadBlossomData()
	local chunk = love.filesystem.load( self:makeBlossomName() ) -- load the chunk 
	return chunk()
end

function Plant:sproutBlossom()

	if self.blossomdata == nil then
		self.blossomdata = self:loadBlossomData()
	end
	local blossom  = {
		blossompoint = self:getNewBlossomPoint(),
		state = PlantState.Baby,
		growtime = Genetics:mutateValue("blossomgrowspeed", self.genetics.blossomgrowspeed)
	}

	table.insert(self.blossoms, blossom)
end

function Plant:updateParts(dt)

	if self.nextblossomtime then
		self.nextblossomtime = self.nextblossomtime - dt
		if self.nextblossomtime <= 0 then
			print('blossoming...')
			self:sproutBlossom()
			self.nextblossomtime = nil
		end
	elseif self:hasBlossomPoints() then
		self.nextblossomtime = self.blossomfrequency * math.random()
	end
end

function Plant:getSize()
	return vector(self.data[self.state].size)
end

function Plant:update(dt)
	self.growtime = self.growtime + dt
	if self.growtime > self.genetics.growspeed then
		self.growtime = 0
		if self.state < PlantState.Mature then
			self.state = self.state + 1

			self.size = self:getSize() * self.genetics.size
		elseif not self.seeded then -- seed
			print('seeding')
			for i=1,self.genetics.seedrate do
				local dir = vector( 2 * math.random() - 1, -1)

				local seed = self:makeSeed()
				seed:pulse( dir:normalized(), 70)
				self.seeded = true

			end


		end
	end

	--grow blossoms
	for i,blossom in ipairs(self.blossoms) do
		if blossom.state < PlantState.Mature then
			blossom.growtime = blossom.growtime - dt
			if blossom.growtime <= 0.0 then
				blossom.state = blossom.state + 1
				blossom.growtime = Genetics:mutateValue("blossomgrowspeed", self.genetics.blossomgrowspeed)
			end

		end
	end

	self:updateParts(dt)
end

function Plant:getBlossomPoint(idx)
	return vector( self.data[self.state].blossompoints[idx])
end

function Plant:draw()
	love.graphics.push()
	love.graphics.translate(self.pos.x, self.pos.y)
	--love.graphics.setColor(self.genetics.color)
	love.graphics.setColor(0, 113, 8)

	love.graphics.rectangle("fill", -self.size.x / 2, -self.size.y, self.size.x, self.size.y)

	--now draw our blossoms!
	for i,blossom in ipairs(self.blossoms) do
		love.graphics.push()
		
		local point = self:getBlossomPoint(blossom.blossompoint)
		love.graphics.translate(point.x, point.y)

		love.graphics.setColor( self.genetics.color )
		local size = self.blossomdata[blossom.state].size;
		love.graphics.rectangle("fill", -size[1]/2, -size[2] / 2, size[1], size[2])

		love.graphics.pop()
	end

	love.graphics.pop()


	if DRAWPLANTS then
		local state = self.data[self.state]

		if state.blossompoints then 
			for i,v in ipairs(state.blossompoints) do
				love.graphics.setColor(255,0,0)
				love.graphics.circle("fill",self.pos.x + v[1], self.pos.y + v[2], 2)
			end
		end

		if state.stems then
			for i,v in ipairs(state.stems) do
				love.graphics.setColor(255,255,255)
				love.graphics.line(self.pos.x + v[1][1], self.pos.y + v[1][2], self.pos.x + v[2][1], self.pos.y + v[2][2])
			end
		end
	end
end