-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."blossom_e.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	blossom_baby={
		[0]={u=96, v=0, w=10, h=10, offsetX=2, offsetY=18, duration=0.0333333},
		scale=1
	},
	blossom_mature={
		[0]={u=32, v=0, w=30, h=56, offsetX=14, offsetY=58, duration=0.0333333},
		scale=1
	},
	blossom_young={
		[0]={u=76, v=34, w=20, h=22, offsetX=9, offsetY=29, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data
