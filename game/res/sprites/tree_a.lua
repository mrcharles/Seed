-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."tree_a.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	tree_baby={
		[0]={u=700, v=548, w=150, h=284, offsetX=69, offsetY=278, duration=0.0333333},
		scale=1
	},
	tree_mature={
		[0]={u=0, v=0, w=700, h=986, offsetX=344, offsetY=974, duration=0.0333333},
		scale=1
	},
	tree_young={
		[0]={u=700, v=0, w=314, h=548, offsetX=158, offsetY=540, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data