-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."blossom_g.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	blossom_baby_cel={
		[0]={u=86, v=38, w=14, h=24, offsetX=7, offsetY=20, duration=0.0333333},
		scale=1
	},
	blossom_mature_cel={
		[0]={u=0, v=0, w=46, h=52, offsetX=24, offsetY=47, duration=0.0333333},
		scale=1
	},
	blossom_young_cel={
		[0]={u=86, v=0, w=24, h=38, offsetX=12, offsetY=34, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data
