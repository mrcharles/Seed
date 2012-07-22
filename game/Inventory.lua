require "hump.vector"

Inventory = {}

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

end
