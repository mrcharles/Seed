require "Base"
require "hump.vector"

WindEffect = Base:new()
WindEffect.TangentialAcceleration = -50

local path = ...
if type(path) ~= "string" then
	path = "."
end

function WindEffect:load(strData, numParticles)
	WindEffect.image = love.graphics.newImage("res/sprites/"..strData)--.."/palette.png")
	WindEffect.image:setFilter("linear", "linear")

	WindEffect.system = love.graphics.newParticleSystem(WindEffect.image, numParticles) 
	--WindEffect.system:setPosition(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
	WindEffect.system:setEmissionRate(1)
	WindEffect.system:setSpeed(200, 300)
	WindEffect.system:setGravity(0)
	WindEffect.system:setSizes(.5, 1)
	WindEffect.system:setColors(255, 255, 255, 255, 58, 128, 255, 0)
	WindEffect.system:setPosition(love.graphics.getWidth()/2, 0)
	WindEffect.system:setLifetime(1)
	WindEffect.system:setParticleLife(10)
	WindEffect.system:setDirection(0)
	WindEffect.system:setSpin(0, 3.14, 0.5)
	WindEffect.system:setSpread(0.1)
	--WindEffect.system:setRadialAcceleration(-2000)
	--WindEffect.system:setTangentialAcceleration(1000)
	--WindEffect.system:setRadialAcceleration(-200)
	WindEffect.system:setTangentialAcceleration(WindEffect.TangentialAcceleration)
	WindEffect.system:start()
end

function WindEffect:draw()
	--WindEffect.system:draw()
	love.graphics.draw(WindEffect.system, 0, 0)
end

function WindEffect:update(dt)
	WindEffect.system:setPosition(0, math.random() * love.graphics.getHeight())
	--if(WindEffect.TangentialAcceleration == -50) then
	--WindEffect.TangentialAcceleration = 0
	--else WindEffect.TangentialAcceleration = -50
	--end
	WindEffect.TangentialAcceleration = -math.random() * 50

	WindEffect.system:setTangentialAcceleration(WindEffect.TangentialAcceleration)
	WindEffect.system:update(dt)
	WindEffect.system:start()
end
