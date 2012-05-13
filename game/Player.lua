require "Base"
require "hump.vector"

Player = Base:new()
Player.sprite = {}
Player.direction = "right"

function Player:init()

	self.speed = 140
	self.size = vector(60, 190)
	self.offset = vector(0, -95)
	self.actionoffset = vector(30, 0)
	self.inventory = {}

	Base.init(self)

	self.sprite = spritemanager.createSprite()
	self.sprite.strData = "girl"
	self.sprite.animation = "standing_right"
	self.sprite:setData(self.sprite.strData, self.sprite.animation, true)
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

			if self.direction == "right" then
				self.sprite:setAnimation("standing_right")
			elseif self.direction == "left" then
				self.sprite:setAnimation("standing_left")
			end

			if self.moveToAction then
				print("performing action "..self.moveToAction)
				assert( table.maxn(self.moveToActionParams) <= 5, "moveTo callback can only take 5 params")
				self[self.moveToAction](self, self.moveToActionParams[1], self.moveToActionParams[2], self.moveToActionParams[3], self.moveToActionParams[4], self.moveToActionParams[5])
				self.moveToAction = nil
				self.moveToActionParams = nil
			end
		else
			self.pos = self.pos + (dir * move)
		end


	end
	self.sprite.x = self.pos.x
	self.sprite.y = self.pos.y
	self.sprite:update(dt)

end

function Player:draw()
	-- love.graphics.push()
	-- love.graphics.translate(-self.size.x / 2, -self.size.y)
	-- love.graphics.setColor(0,0,0, 64)
	-- love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
	-- love.graphics.pop()

	self.sprite:draw()

	Base.draw(self)
end

function Player:moveTo(v)
	if v.x > self.pos.x then
		self.sprite:setAnimation("walking_right")
		self.direction = "right"
	elseif v.x < self.pos.x then
		self.sprite:setAnimation("walking_left")
		self.direction = "left"
	end

	self.target = v

	--constrain the position
	self.target.y = self.world:getGroundHeight()
end

function Player:pickUp( obj )
	obj.world:removeObject(obj)
	table.insert( self.inventory, obj )

	if self.direction == "right" then
		self.sprite:setAnimation("pickup_right")
	elseif self.direction == "left" then
		self.sprite:setAnimation("pickup_left")
	end
end

function Player:removeFromInventory(obj)
    for i, v in ipairs(self.inventory) do
    	if v == obj then
    		table.remove(self.inventory,i)
       		return
       	end
    end
end

function Player:removeSeed()
	local seed = nil
	if self:hasSeeds() then
		seed = self.inventory[1]
		self:removeFromInventory(seed)
	end

	return seed
end

function Player:hasSeeds()
	return table.maxn( self.inventory ) >= 1
end

function Player:plant(pos)
	local seed = self:removeSeed()

	if seed then
		local plant = seed:makePlant()
		plant.pos = pos
		self.world:addObject(plant)
	end

	if self.direction == "right" then
		self.sprite:setAnimation("planting_right")
	elseif self.direction == "left" then
		self.sprite:setAnimation("planting_left")
	end
end

function Player:water(pos)
	-- add water to world at pos
	if self.direction == "right" then
		self.sprite:setAnimation("watering_right")
	elseif self.direction == "left" then
		self.sprite:setAnimation("watering_left")
	end
end

function Player:moveToObjAndDo( obj, action, ... )
	local targetpos = obj.pos;

	if obj.pos.x > self.pos.x then
		targetpos = targetpos - self.actionoffset
	else
		targetpos = targetpos + self.actionoffset
	end

	self:moveTo(targetpos)
	self.moveToAction = action
	self.moveToActionParams = { ... }
end

function Player:moveToAndDo( pos, action, ...)
	self:moveTo(pos)
	self.moveToAction = action
	self.moveToActionParams = { ... }
end