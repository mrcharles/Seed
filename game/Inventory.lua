require "hump.vector"

Inventory = {
	tilewidth = 128,
	tileheight = 128,
	tilespace = 16,
	width = 8,
	height = 4,
	selected = 0
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
	if self.selected == 0 then
		self.selected = 1
	end
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

function Inventory:pick(mousepos)
	local basex = (love.graphics.getWidth() - ( self.width * self.tilewidth + (self.width-1)*self.tilespace )) / 2 - self.tilespace / 2
	local basey = (love.graphics.getHeight() - ( self.height * self.tileheight + (self.height-1)*self.tilespace )) / 2 - self.tilespace / 2

	local stridex = self.tilewidth + self.tilespace
	local stridey = self.tileheight + self.tilespace

	local x = math.floor(( mousepos.x - basex ) / stridex) + 1
	local y = math.floor(( mousepos.y - basey ) / stridey) + 1

	--print(string.format("%d %d %d %d %d %d", basex, basey, stridex, stridey, x, y))

	self:setSelected( x + (y-1) * self.width )

end

function Inventory:setSelected(idx)
	if idx <= self:count() then
		self.selected = idx
	end
end

function Inventory:removeSelected()
	local item = self.items[self.selected]
	self:remove(item)
	return item
end

function Inventory:draw()
	local startx = (love.graphics.getWidth() - ( self.width * self.tilewidth + (self.width-1)*self.tilespace )) / 2
	local starty = (love.graphics.getHeight() - ( self.height * self.tileheight + (self.height-1)*self.tilespace )) / 2
	
	local x = startx
	local y = starty

	local idx = 1

	local quad = self.itemquad

	for i=1,self.height do
		for j=1,self.width do
			if idx == self.selected then
				love.graphics.setColor(128, 255, 128, 128)
			else
				love.graphics.setColor(255,255,255,128)
			end
			love.graphics.rectangle("fill",x,y, self.tilewidth, self.tileheight)

			local item = self.items[idx]

			if item and item.snapshot then
				item.snapshot:draw(x, y, 1)
			end

			if idx <= self:count() then
				love.graphics.push()
				love.graphics.translate(x + 100,y + 100)

				item:draw(true)

				love.graphics.pop()
			end
			x = x + self.tilewidth + self.tilespace
			idx = idx + 1
		end
		y = y + self.tileheight + self.tilespace
		x = startx
	end
end
