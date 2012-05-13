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
		[0]={u=46, v=78, w=16, h=18, offsetX=7, offsetY=18, duration=0.0333333},
		scale=1
	},
	blossom_mature={
		[0]={u=0, v=50, w=40, h=44, offsetX=20, offsetY=34, duration=0.0333333},
		scale=1
	},
	blossom_young={
		[0]={u=46, v=24, w=24, h=22, offsetX=12, offsetY=17, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data
