require "hump.vector"

Inventory = {
	tilewidth = 128,
	tileheight = 128,
	tilespace = 16,
	width = 8,
	height = 4,
}

function Inventory:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o:init()
	return o
end

function Inventory:init()
	self.items = {}
end

function Inventory:add(item)
	table.insert(self.items, item)
end

function Inventory:count()
	return #self.items

end

function Inventory:remove(item)
    for i, v in ipairs(self.items) do
    	if v == item then
    		table.remove(self.items,i)
       		return
       	end
    end
end

function Inventory:removeSelected()
	local item = self.items[1]
	self:remove(item)
	return item
end

function Inventory:draw()
	local startx = (love.graphics.getWidth() - ( self.width * self.tilewidth + (self.width-1)*self.tilespace )) / 2
	local starty = (love.graphics.getHeight() - ( self.height * self.tileheight + (self.height-1)*self.tilespace )) / 2
	
	local x = startx
	local y = starty

	for i=1,self.height do
		for j=1,self.width do
			love.graphics.setColor(255,255,255,128)
			love.graphics.rectangle("fill",x,y, self.tilewidth, self.tileheight)

			x = x + self.tilewidth + self.tilespace
		end
		y = y + self.tileheight + self.tilespace
		x = startx
	end
end
