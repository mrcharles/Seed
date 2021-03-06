-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."blossom_f.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	blossom_baby_cel={
		[0]={u=38, v=40, w=18, h=22, offsetX=9, offsetY=18, duration=0.0333333},
		scale=1
	},
	blossom_mature_cel={
		[0]={u=0, v=0, w=38, h=52, offsetX=19, offsetY=45, duration=0.0333333},
		scale=1
	},
	blossom_young_cel={
		[0]={u=70, v=0, w=20, h=26, offsetX=9, offsetY=22, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data
