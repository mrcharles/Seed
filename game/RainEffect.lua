require "Base"
require "hump.vector"

RainEffect = Base:new()

local path = ...
if type(path) ~= "string" then
	path = "."
end

function brighten( x, y, r, g, b, a )
   r = math.min(r * 3, 255)
   g = math.min(g * 3, 255)
   b = math.min(b * 3, 255)
   return r,g,b,a
end

function cutAlpha( x, y, r, g, b, a )
   r = r
   g = g
   b = b
   a = math.max(a * 0.125, 0)
   return r,g,b,a
end

function RainEffect:load(strData, numParticles)
	local src = love.image.newImageData("res/sprites/"..strData)
	src:mapPixel(cutAlpha)
	RainEffect.image = love.graphics.newImage(src)--.."/palette.png")
	RainEffect.image:setFilter("linear", "linear")

	RainEffect.system = love.graphics.newParticleSystem(RainEffect.image, numParticles) 
	--RainEffect.system:setPosition(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
	RainEffect.system:setEmissionRate(100)
	RainEffect.system:setSpeed(700, 800)
	RainEffect.system:setGravity(9.81)
	RainEffect.system:setSizes(2, 1)
	RainEffect.system:setColors(255, 255, 255, 255, 255, 255, 255, 0)
	RainEffect.system:setPosition(love.graphics.getWidth()/2, 0)
	RainEffect.system:setLifetime(1)
	RainEffect.system:setParticleLife(.87)
	RainEffect.system:setDirection(3.14/2.1)
	RainEffect.system:setSpread(0.1)
	--RainEffect.system:setRadialAcceleration(-2000)
	--RainEffect.system:setTangentialAcceleration(1000)
	RainEffect.system:start()
end

function RainEffect:draw()
	--RainEffect.system:draw()
	love.graphics.draw(RainEffect.system, 0, 0)
end

function RainEffect:update(dt)
	RainEffect.system:setPosition(math.random() * love.graphics.getWidth() * 2, 0)
	RainEffect.system:update(dt)
	RainEffect.system:start()
end
