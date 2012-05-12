-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."/dude_cel.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	dude_cel={
		[0]={u=0, v=0, w=102, h=102, offsetX=50, offsetY=50, duration=0.0333333},
		[1]={u=0, v=0, w=102, h=102, offsetX=50, offsetY=50, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data