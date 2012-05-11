vector = require "hump.vector"
camera = require "hump.camera"
require "Player"
require "World"


local balls = {
	{400,300}, -- this one will be controlled by the mouse

	{400,300}, -- these will
	{400,300}, -- fly
	{400,300}, -- around

	-- the rest just sits there
	{50,50}, {50,550}, {750,50}, {750,550}
}


function love.load()
	 -- assert(love.graphics.isSupported('pixeleffect'), 'Pixel effects are not supported on your hardware. Sorry about that.')

	cam = camera(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2,1,0)

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

	player = Player:new()
	player.pos = vector(0, love.graphics.getHeight() / 2)
	world = World:new()
	world:create()

	love.graphics.setBackgroundColor(255, 255, 255)
end

function love.draw()
	cam:attach()

	world:draw()
	--love.graphics.setPixelEffect(effect)
	--love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(), love.graphics.getHeight())

	player:draw()
	cam:detach()
end

function love.update(dt)
	world:update(dt)
	player:update(dt)
end

function love.mousepressed(x, y, button)
	if button == "l" then
		if world:getClickedObject(x, y) then

		else
			player:moveTo( vector(x,y) )
		end
	end
end

function love.keyreleased( key, unicode )
	if key == "right" then
		cam:move(10, 0)

	elseif key == "left" then
		cam:move(-10, 0)

	elseif key == "down" then
		cam:move(0, 10)

	elseif key == "up" then
		cam:move(0, -10)

	elseif key == "f1" then
		if DEBUG then
			DEBUG = false
		else
			DEBUG = true
		end


	end

end