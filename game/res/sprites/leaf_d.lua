-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."leaf_d.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	leaf_baby={
		[0]={u=66, v=26, w=10, h=20, offsetX=6, offsetY=23, duration=0.0333333},
		scale=1
	},
	leaf_mature={
		[0]={u=34, v=0, w=44, h=26, offsetX=24, offsetY=22, duration=0.0333333},
		scale=1
	},
	leaf_young={
		[0]={u=50, v=26, w=16, h=24, offsetX=8, offsetY=23, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data