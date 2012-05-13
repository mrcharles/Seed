-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."leaf_e.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	leaf_baby={
		[0]={u=20, v=54, w=12, h=10, offsetX=6, offsetY=13, duration=0.0333333},
		scale=1
	},
	leaf_mature={
		[0]={u=18, v=30, w=16, h=24, offsetX=8, offsetY=25, duration=0.0333333},
		scale=1
	},
	leaf_young={
		[0]={u=20, v=0, w=14, h=22, offsetX=7, offsetY=25, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data
