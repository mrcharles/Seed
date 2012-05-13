-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."blossom_i.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	blossom_baby={
		[0]={u=98, v=82, w=24, h=22, offsetX=13, offsetY=16, duration=0.0333333},
		scale=1
	},
	blossom_mature={
		[0]={u=58, v=0, w=52, h=48, offsetX=24, offsetY=34, duration=0.0333333},
		scale=1
	},
	blossom_young={
		[0]={u=0, v=84, w=34, h=30, offsetX=18, offsetY=17, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data
