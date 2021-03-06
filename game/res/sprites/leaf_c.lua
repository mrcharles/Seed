-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."leaf_c.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	leaf_baby={
		[0]={u=46, v=38, w=10, h=16, offsetX=3, offsetY=17, duration=0.0333333},
		scale=1
	},
	leaf_mature={
		[0]={u=34, v=16, w=28, h=22, offsetX=13, offsetY=24, duration=0.0333333},
		scale=1
	},
	leaf_young={
		[0]={u=34, v=0, w=30, h=16, offsetX=14, offsetY=21, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data
