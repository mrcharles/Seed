require "Base"
require "hump.vector"

PaletteEffect = Base:new()

local path = ...
if type(path) ~= "string" then
	path = "."
end

function PaletteEffect:load(strData)
	local src = [[
		extern vec4 palette;
		extern Image sampler;

		number _hue(number s, number t, number h)
		{
			h = mod(h, 1.);
			number six_h = 6.0 * h;
			if (six_h < 1.) return (t-s) * six_h + s;
			if (six_h < 3.) return t;
			if (six_h < 4.) return (t-s) * (4.-six_h) + s;
			return s;
		}

		vec4 hsl_to_rgb(vec4 c)
		{
			if (c.y == 0)
				return vec4(vec3(c.z), c.a);

			number t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
			number s = 2.0 * c.z - t;
			#define Q 1.0/3.0
			return vec4(_hue(s,t,c.x+Q), _hue(s,t,c.x), _hue(s,t,c.x-Q), c.w);
		}

		vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
		{
			color = hsl_to_rgb(palette);
			color = Texel(sampler, tc);
			return color;
		}
	]]

	PaletteEffect.image = love.graphics.newImage(strData)--.."/palette.png")
	PaletteEffect.image:setFilter("nearest", "nearest")

	PaletteEffect.effect = love.graphics.newPixelEffect(src)
	PaletteEffect.effect:send('palette', {0, 0, 0, 10})
	PaletteEffect.effect:send('sampler', PaletteEffect.image)

end

function PaletteEffect:setEffect()
	love.graphics.setPixelEffect(PaletteEffect.effect)
end

function PaletteEffect:clearEffect()
	love.graphics.setPixelEffect()
end

t = 0
function PaletteEffect:update(dt)
	t = t + dt
	PaletteEffect.effect:send('palette', {t/10,.5 + .5*math.cos(t/5), .5, 10.0})
end
