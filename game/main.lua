vector = require "hump.vector"
camera = require "hump.camera"
require "Player"
require "World"
require "LayeredSprite"
require "RainEffect"
require "WindEffect"

local balls = {
	{400,300}, -- this one will be controlled by the mouse

	{400,300}, -- these will
	{400,300}, -- fly
	{400,300}, -- around

	-- the rest just sits there
	{50,50}, {50,550}, {750,50}, {750,550}
}

testLayeredSprite = {}
testRainEffect = {}
testWindEffect = {}
zoom = 1

function love.load()
	 -- assert(love.graphics.isSupported('pixeleffect'), 'Pixel effects are not supported on your hardware. Sorry about that.')

	math.randomseed(os.time())
	cameraX = love.graphics.getWidth() / 2
	cameraY = love.graphics.getHeight() / 2
	cameraZoom = 1
	cam = camera(cameraX, cameraY, cameraZoom, 0)

	gameRight = love.graphics.getWidth() * 3 / 2
	gameLeft = love.graphics.getWidth() / 2
	gameTop = love.graphics.getHeight() / 2
	gameBottom = love.graphics.getHeight() / 2
	

	-- print("loaded some shit")
	-- -- yep, Lua can be used for meta-programming an effect :D
	-- local loop_unroll = {}
	-- for i = 1,#balls do
	-- 	loop_unroll[i] = ("p += metaball(pc - balls[%d]);\n"):format(i-1)
	-- end
	-- local src = [[
	-- 	extern vec2[%d] balls;
	-- 	extern vec4 palette;

	-- 	float metaball(vec2 x)
	-- 	{
	-- 		x /= 20.0;
	-- 		return 1.0 / (dot(x, x) + .00001) * 3.0;
	-- 		//return exp(-dot(x,x)/6000.0) * 3.0;
	-- 	}

	-- 	number _hue(number s, number t, number h)
	-- 	{
	-- 		h = mod(h, 1.);
	-- 		number six_h = 6.0 * h;
	-- 		if (six_h < 1.) return (t-s) * six_h + s;
	-- 		if (six_h < 3.) return t;
	-- 		if (six_h < 4.) return (t-s) * (4.-six_h) + s;
	-- 		return s;
	-- 	}

	-- 	vec4 hsl_to_rgb(vec4 c)
	-- 	{
	-- 		if (c.y == 0)
	-- 			return vec4(vec3(c.z), c.a);

	-- 		number t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
	-- 		number s = 2.0 * c.z - t;
	-- 		#define Q 1.0/3.0
	-- 		return vec4(_hue(s,t,c.x+Q), _hue(s,t,c.x), _hue(s,t,c.x-Q), c.w);
	-- 	}

	-- 	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
	-- 	{
	-- 		float p = 0.0;
	-- 		%s

	-- 		color = .5 * (p + ceil(p*5.)/5.) * hsl_to_rgb(palette);
	-- 		return color;
	-- 	}
	-- ]]
	-- src = src:format(#balls, table.concat(loop_unroll))
	-- print(src)

	-- effect = love.graphics.newPixelEffect(src)
	-- effect:send('balls', unpack(balls))
	-- effect:send('palette', {0, 0, 0, 10})

	--DRAWPHYSICS = true
	--DRAWPLANTS = true

	player = Player:new()
	player:init()
	world = World:new()
	world:init()

	world:create()

	player.pos = vector(0, world:getGroundHeight())

	player.world = world

	love.graphics.setBackgroundColor(255, 255, 255)

	testLayeredSprite = LayeredSprite:new()
	testLayeredSprite:load("dude", "dude")
	testLayeredSprite.speed = 100

	testRainEffect = RainEffect:new()
	testRainEffect:load("raindrop.png", 500)

	testWindEffect = WindEffect:new()
	testWindEffect:load("wind_leaf.png", 500)
end

function love.draw()
	cam:attach()

	world:draw()
	--love.graphics.setPixelEffect(effect)
	--love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(), love.graphics.getHeight())

	--testLayeredSprite:draw()
	testRainEffect:draw()
	testWindEffect:draw()

	player:draw()
	cam:detach()
end

function love.update(dt)
	if SPEEDUP then
		dt = dt * 10.0
	end
	world:update(dt)
	player:update(dt)

	if love.keyboard.isDown("right") then
		testLayeredSprite.position.x = testLayeredSprite.position.x + (testLayeredSprite.speed * dt)
		--ninja.flipH = false
		--testLayeredSprite:setAnimation("runRight", true)
	elseif love.keyboard.isDown("left") then
		testLayeredSprite.position.x = testLayeredSprite.position.x - (testLayeredSprite.speed * dt)
		--ninja.flipH = true
		--testLayeredSprite:setAnimation("runLeft", true)
	end

	if love.keyboard.isDown("down") then
		testLayeredSprite.position.y = testLayeredSprite.position.y + (testLayeredSprite.speed * dt)
	elseif love.keyboard.isDown("up") then
		testLayeredSprite.position.y = testLayeredSprite.position.y - (testLayeredSprite.speed * dt)
	end
	testLayeredSprite:update(dt)

	testRainEffect:update(dt)
	testWindEffect:update(dt)
end

function love.mousereleased(x, y, button)
	if button == "l" then
		local hit = world:getClickedObject(x, y)
		if hit then
			print("moving to pick up a thing")
			player:moveToObjAndDo(hit, "pickUp", hit)
		elseif player:hasSeeds() then
			print("moving to plant a seed")
			local plantpos = vector(x,y)
			player:moveToAndDo( plantpos, "plant", plantpos )
		else
			print('just moving')
			player:moveTo( vector(x,y) )
		end
	elseif  button == "wu" then
		cameraZoom = cameraZoom + 0.1
		cam = camera(cameraX, cameraY, cameraZoom, 0)

		-- already correct coordinates, just fix edges with zoom
	elseif  button == "wd" then
		--if cameraZoom > 1 then
			cameraZoom = cameraZoom - 0.1
			cam = camera(cameraX, cameraY, cameraZoom, 0)
		--end
	end
end

function getClampedPos(pos)
	minx = gameLeft + (love.graphics.getWidth() / 2) / zoom;
    maxx = gameRight - (love.graphics.getWidth()/ 2) / zoom;
    miny = gameTop + (love.graphics.getHeight() / 2) / zoom;
    maxy = gameBottom - (love.graphics.getHeigth() / 2) / zoom;

    ret = vector(0, 0)

    ret.x = math.min(math.max(pos.x, minx), maxx);
    ret.y = math.min(math.max(pos.y, miny), maxy);
    return ret
end

function love.mousepressed(x, y, button)
	if button == "l" then
	elseif  button == "r" then
	end
end

function love.keyreleased( key, unicode )
	cameraDelta = 0
	cameraPrev = 0

	if key == "right" then
		cameraPrev = cameraX
		if cameraX < gameRight then	
			if cameraX + 50 < gameRight then
				cameraDelta = 50
			else
				cameraDelta = gameRight - cameraPrev
			end
			cameraX = cameraPrev + cameraDelta
			cam:move(cameraDelta, 0)
		end
	elseif key == "left" then
		cameraPrev = cameraX
		if cameraX > gameLeft then
			if cameraX - 50 > gameLeft then
				cameraDelta = -50
			else
				cameraDelta = gameLeft - cameraPrev
			end
			cameraX = cameraPrev + cameraDelta
			cam:move(cameraDelta, 0)
		end
	elseif key == "down" then
		cameraPrev = cameraY
		if cameraY < gameBottom then	
			if cameraY + 50 > gameBottom then
				cameraDelta = gameBottom - cameraPrev
			else
				cameraDelta = 50
			end
			cameraY = cameraPrev + cameraDelta
			cam:move(0, cameraDelta)
		end
	elseif key == "up" then
		cameraPrev = cameraY
		if cameraY > gameTop then
			if cameraY - 50 < gameTop then
				cameraDelta = cameraPrev - gameTop
			else
				cameraDelta = -50
			end
			cameraY = cameraPrev + cameraDelta
			cam:move(0, cameraDelta)
		end	
	elseif key == "f1" then
		if DEBUG then
			DEBUG = false
		else
			DEBUG = true
		end
	elseif key == "f12" then
		if SPEEDUP then
			SPEEDUP = false
		else
			SPEEDUP = true
		end
	elseif key == "f11" then
		if DRAWGROUND then
			DRAWGROUND = false
		else
			DRAWGROUND = true
		end
	elseif key == "f10" then
		if DRAWPHYSICS then
			DRAWPHYSICS = false
		else
			DRAWPHYSICS = true
		end
	elseif key == "f9" then
		if DRAWPLANTS then
			DRAWPLANTS = false
		else
			DRAWPLANTS = true
		end
	end


end