-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."blossom_g.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	blossom_baby={
		[0]={u=46, v=46, w=8, h=16, offsetX=4, offsetY=17, duration=0.0333333},
		scale=1
	},
	blossom_mature={
		[0]={u=46, v=0, w=40, h=46, offsetX=21, offsetY=45, duration=0.0333333},
		scale=1
	},
	blossom_young={
		[0]={u=110, v=0, w=18, h=32, offsetX=9, offsetY=32, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data
