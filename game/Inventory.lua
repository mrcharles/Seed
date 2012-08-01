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

	self.startx = (love.graphics.getWidth() - ( self.width * self.tilewidth + (self.width-1)*self.tilespace )) / 2 + self.tilewidth / 2
	self.starty = (love.graphics.getHeight() - ( self.height * self.tileheight + (self.height-1)*self.tilespace )) / 2 + self.tileheight / 2

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

function Inventory:draw(mousepos)
	local zoomsize = 256
	local mousex = math.ceil((mousepos.x - self.startx + self.tilewidth / 2 ) / ( self.tilewidth + self.tilespace ))
	local mousey = math.ceil((mousepos.y - self.starty + self.tileheight / 2) / ( self.tileheight + self.tilespace ))

	local idx = 1
	local postdraw = nil
	for i=1,self.height do
		for j=1,self.width do
			local selected = false
			local zoom = 128
			local color = { 255, 255, 255, 128 }
			local mousehover = false

			if idx == self.selected then
				color = { 128, 255, 128, 128 }
				selected = true
			end

			if i == mousey and j == mousex and idx <= self:count() then
				zoom = 256
				color[4] = 255
				mousehover = true
			end
			local func = self:makeDrawFunc(idx, j, i, selected, zoom, color)

			if mousehover == false then
				func()
			else
				postdraw = func
			end

			idx = idx + 1
		end
	end

	if postdraw then
		postdraw()
	end
end

function Inventory:makeDrawFunc(idx, x, y, selected, zoomsize, color)
	local tlzoomx = -zoomsize/2
	local tlzoomy = -zoomsize/2

	local tloffsetx = -self.tilewidth/2
	local tloffsety = -self.tileheight/2

	return function()
		
		local drawx = self.startx + (x-1) * (self.tilewidth + self.tilespace)
		local drawy = self.starty + (y-1) * (self.tileheight + self.tilespace)

		love.graphics.setColor(color)

		local item = self.items[idx]

		if item and item.snapshot then
			item.snapshot:draw(drawx , drawy, zoomsize, color)
		else
			love.graphics.rectangle("fill",drawx + tloffsetx, drawy + tloffsety, self.tilewidth, self.tileheight)
		end

		if idx <= self:count() then
			love.graphics.push()

			love.graphics.translate(drawx + item.snapshot.rendersize /2 - 20 ,drawy + item.snapshot.rendersize /2 - 20 )

			item:draw(true)

			love.graphics.pop()
		end

	end

end

function Inventory:drawold(mousepos)
	

	local x = self.startx
	local y = self.starty

	local idx = 1

	--print(string.format("inv: x: %d y: %d", mousex, mousey))

	local quad = self.itemquad

	for i=1,self.height do
		for j=1,self.width do
			local mousehover = false
			local alpha = 128
			if i == mousey and j == mousex then
				mousehover = true
				alpha = 255
			end

			if idx == self.selected then
				love.graphics.setColor(128,255,128,alpha)
			else
				love.graphics.setColor(255,255,255,alpha)
			end

			local item = self.items[idx]

			if item and item.snapshot then
				local isize = 128
				if mousehover then
					isize = 256
				end
				love.graphics.rectangle("fill",x - isize/2 , y - isize / 2, isize, isize)
				item.snapshot:draw(x , y, isize)
			else
				love.graphics.rectangle("fill",x + tloffsetx, y +tloffsety, self.tilewidth, self.tileheight)
			end

			if idx <= self:count() then
				love.graphics.push()
				love.graphics.translate(x + 50,y + 50)

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
