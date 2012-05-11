require "Base"
require "hump.vector"

Player = Base:new()

function Player:init()

	self.speed = 140
	self.size = vector(60, 190)
	self.offset = vector(0, -40)
	self.actionoffset = vector(30, 0)
	self.inventory = {}

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

end

function Player:draw()
	love.graphics.push()
	love.graphics.translate(-self.size.x / 2, -self.size.y)
	love.graphics.setColor(0,0,0, 64)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
	love.graphics.pop()

	Base.draw(self)
end

function Player:moveTo(v)
	self.target = v
end

function Player:pickUp( obj )
	obj.world:removeObject(obj)
	table.insert( self.inventory, obj )
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

end

function Player:moveToObjAndDo( obj, action, ... )
	local targetpos = obj.pos;

	if obj.pos.x > self.pos.x then
		targetpos = targetpos + self.actionoffset
	else
		targetpos = targetpos - self.actionoffset
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