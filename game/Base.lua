vector = require "hump.vector"

Base = {
	pos = vector(0,0)
}

function Base:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Base:update(dt)

end

function Base:draw()
	
	
end
