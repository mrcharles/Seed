-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."blossom_f.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	blossom_baby={
		[0]={u=68, v=40, w=10, h=16, offsetX=5, offsetY=15, duration=0.0333333},
		scale=1
	},
	blossom_mature={
		[0]={u=38, v=0, w=32, h=40, offsetX=15, offsetY=42, duration=0.0333333},
		scale=1
	},
	blossom_young={
		[0]={u=56, v=40, w=12, h=18, offsetX=6, offsetY=18, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data
