require "Base"
require "Genetics"

PlantState = {
	Sprout = 1,
	Baby = 2,
	Young = 3,
	Mature = 4
}

PlantType = {
	Flower = 1,
	Bush = 2,
	Tree = 3,
}

Plant = Base:new()

Plant.sizes = {
	{ -- flower
	vector( 10, 10 ),
	vector( 15, 20 ),
	vector( 20, 40 ),
	vector( 25, 60 )
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

function Plant:init(seed)
	self.state = PlantState.Sprout

	--straight copy for right now
	self.genetics = seed.genetics

	self.size = self.sizes[self.genetics.planttype][self.state]

	self.growtime = 0
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

function Plant:update(dt)
	self.growtime = self.growtime + dt
	if self.growtime > self.genetics.growspeed then
		self.growtime = 0
		if self.state < PlantState.Mature then
			self.state = self.state + 1
			self.size = self.sizes[self.genetics.planttype][self.state] * self.genetics.size
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
end

function Plant:draw()
	love.graphics.push()
	love.graphics.translate(self.pos.x, self.pos.y)
	love.graphics.setColor(self.genetics.color)


	love.graphics.rectangle("fill", -self.size.x / 2, -self.size.y, self.size.x, self.size.y)
	love.graphics.pop()
end