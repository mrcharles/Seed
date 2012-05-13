require "Base"
require "Genetics"
require "Tools"
require "spritemanager"
require "LayeredSprite"
require "AlphaEffect"

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
Plant.leavesfrequency = 0.2

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
			return string.lower(k)
		end
	end

	assert(false)
end

function Plant:makeDataName()
	return string.format("plantdata/%s_%c_data.lua", string.lower(self:getKeyName(PlantStyle, self.genetics.plantstyle)), 96 + self.genetics.planttype)
end

function Plant:makeBlossomName()
	return string.format("blossom_%c", 96 + self.genetics.blossomtype)
end

function Plant:makeLeavesName()
	return string.format("leaf_%c", 96 + self.genetics.leavestype)
end

function Plant:loadSprite( state )
	self.data[state].sprite = spritemanager.createSprite(self.data[state].sprite, self.data[state].anim)
end

function Plant:init(seed)
	self.state = PlantState.Sprout

	--straight copy for right now
	self.genetics = seed.genetics

	self.growtime = 0

	self.leaves = {}
	self.blossoms = {}

	self.stemsfull = {}

	self.lifetime = self.genetics.lifetime

	--load our data
	local chunk = love.filesystem.load( self:makeDataName() ) -- load the chunk 
	self.data = chunk()

	-- we're only loading three states from the data, so we need to hack some shits
	for i=4,2,-1 do
		self.data[i] = self.data[i-1]
	end


	self:loadSprite( PlantState.Baby )
	self:loadSprite( PlantState.Young )
	self:loadSprite( PlantState.Mature )
	--self.pos = seed.pos
	Base.init(self)

	self.size = self:getSize()

	self.effect = AlphaEffect:new()
	self.effect:load()
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

function Plant:hasStems()
	local state = self.data[self.state]

	if state.stems then
		for i,stem in ipairs(state.stems) do
			if not self.stemsfull[i] then
				return true
			end
		end
	end
end



--this shit is going to spam memroy like a motherfucker
function Plant:loadBlossomData()
	local testLayeredSprite = LayeredSprite:new()
	testLayeredSprite:load(self:makeBlossomName(), "blossom_baby")
	return testLayeredSprite
end

function Plant:loadLeavesData()
	local testLayeredSprite = LayeredSprite:new()
	testLayeredSprite:load(self:makeLeavesName(), "leaf_baby")
	return testLayeredSprite
end

function Plant:sproutBlossom()

	print("SPROUTING BLOSSOM")
	local blossom  = {
		blossompoint = self:getNewBlossomPoint(),
		state = PlantState.Baby,
		growtime = Genetics:mutateValue("blossomgrowspeed", self.genetics.blossomgrowspeed),
		sprite = self:loadBlossomData()
	}

	table.insert(self.blossoms, blossom)
end

function Plant:getLeavesOnStem(idx)
	local count = 0
	for i,leaf in ipairs(self.leaves) do
		if leaf.stem == idx then
			count = count + 1
		end
	end

	return count
end


function Plant:getStem()
	-- look through stems, find out how many leaves we have on a stem, return that stem if we can fit a new leaf
	local state = self.data[self.state]
	if state.stems then
		for i,stem in ipairs(state.stems) do
			print("checking new stem...")
			if not self.stemsfull[i] then 
				local count = self:getLeavesOnStem(i)

				local min = math.floor( self.genetics.leavesdensity )
				local max = math.ceil( self.genetics.leavesdensity )
				local r = self.genetics.leavesdensity - min

				print( string.format("min is %d and max is %d and count is %d", min, max, count))

				if count == min and math.random() > r then
					self.stemsfull[i] = true
				elseif count >= max then
					self.stemsfull[i] = true
				end

				return i
			end
		end
	end
end

function Plant:getStemPos(idx, r)
	local stem = self.data[self.state].stems[idx]

	if stem == nil then
		print("wtf")
	end

	return Tools:lerp( vector( stem[1] ), vector( stem[2] ), r)

end

function Plant:sproutLeaves()

	local stem = self:getStem()

	local leaf = {
		stem = stem,
		pos = math.random(),
		state = PlantState.Baby,
		growtime = Genetics:mutateValue("leavesgrowspeed", self.genetics.leavesgrowspeed),
		sprite = self:loadLeavesData()
	}

	table.insert(self.leaves, leaf)
end

function Plant:getBlossomPoint(idx)
	return vector( self.data[self.state].blossompoints[idx])
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

	if self.nextleavestime then
		self.nextleavestime = self.nextleavestime - dt
		if self.nextleavestime <= 0 then
			print('leaving... (lol)')
			self:sproutLeaves()
			self.nextleavestime = nil
		end
	elseif self:hasStems() then
		self.nextleavestime = self.leavesfrequency * math.random()
		print("MAKE MORE LEAVES!")
	end
end

function Plant:getSize()
	return vector(self.data[self.state].size)
end

function Plant:update(dt)
	dt = 1.5 * dt

	self.lifetime = self.lifetime - dt

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
				blossom.sprite:setAnimation("blossom_"..self:getKeyName(PlantState, blossom.state))
				blossom.growtime = Genetics:mutateValue("blossomgrowspeed", self.genetics.blossomgrowspeed)
			end

		end

		blossom.sprite:update(dt)
	end

	--grow leaves
	for i,leaf in ipairs(self.leaves) do
		if leaf.state < PlantState.Mature then
			leaf.growtime = leaf.growtime - dt
			if leaf.growtime <= 0.0 then
				leaf.state = leaf.state + 1
				leaf.sprite:setAnimation("leaf_"..self:getKeyName(PlantState, leaf.state))
				leaf.growtime = Genetics:mutateValue("leavesgrowspeed", self.genetics.leavesgrowspeed)
			end
		end
	end

	self:updateParts(dt)
end

function Plant:draw()
	local alpha = self.lifetime/(self.genetics.lifetime * 0.1)
	self.effect:setAlpha(alpha)
	self.effect:setEffect()

	love.graphics.push()
	love.graphics.translate(self.pos.x, self.pos.y)
	--love.graphics.setColor(self.genetics.color)
	--love.graphics.setColor(0, 113, 8)

	--love.graphics.rectangle("fill", -self.size.x / 2, -self.size.y, self.size.x, self.size.y)

	if self.data[self.state].sprite then
		love.graphics.push()
		love.graphics.scale(self.genetics.size)
		self.data[self.state].sprite:draw()
		love.graphics.pop()
	end

	--now draw our blossoms!
	for i,blossom in ipairs(self.blossoms) do
		love.graphics.push()
		
		local point = self:getBlossomPoint(blossom.blossompoint) * self.genetics.size
		
		love.graphics.translate(point.x, point.y)

		--love.graphics.setColor( self.genetics.color )
		--local size = self.blossomdata[blossom.state].size;
		--love.graphics.rectangle("fill", -size[1]/2, -size[2] / 2, size[1], size[2])
		love.graphics.scale(self.genetics.size)
		blossom.sprite:setPosition(vector(0,0))
		blossom.sprite:draw()
		love.graphics.pop()
	end

	--now draw our leaves!
	for i,leaf in ipairs(self.leaves) do
		love.graphics.push()
		
		local point = self:getStemPos( leaf.stem, leaf.pos ) * self.genetics.size
		love.graphics.translate(point.x, point.y)

		--love.graphics.setColor( 0, 255, 0 )
		love.graphics.scale(self.genetics.size)
		
		leaf.sprite:setPosition(vector(0,0))
		leaf.sprite:draw()
		--love.graphics.rectangle("fill", -size[1]/2, -size[2] / 2, size[1], size[2])
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

	self.effect:clearEffect()

	Base.draw(self)

end