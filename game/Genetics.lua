
Genetics = {}


MutationRate = 
{
	Rare = 1,
	Uncommon = 2,
	Common = 3,
}

MutationProbabilities =
{
	0.01,
	0.2,
	0.5
}

local MutationTable = 
{
}

function Genetics:registerValue( val, _rate, _change, _min, _max, _floor )
	MutationTable[val] = { rate=_rate, change=_change, min=_min, max=_max, floor = _floor }
end

function Genetics:adjust(val, amt)
	if type(val) == "number" then
		local ret = nil
		if amt < 1 then -- percentage
			ret = val + (val * math.random() * amt * 2 - amt)
		else
			if math.random() < 0.5 then
				ret = val + amt
			else
				ret = val - amt
			end
		end
		print( string.format("\t%s -> %s", val, ret))

		return ret
	elseif type(val) == "boolean" then
		return not val
	elseif type(val) == "table" then
		local t = {}
		for k,v in pairs(val) do
			t[k] = Genetics:adjust(v, amt)
		end
		return t
	else
		assert(false, type(val))
	end
end

function Genetics:clampValue(val, min, max)
	if val == nil then
		assert(false, "WTF yo")
	end

	if type(val) == "table" then
		local t = {}
		for k,v in pairs(val) do
			t[k] = Genetics:clampValue(val[k], min, max)
		end
		return t
	elseif type(val) == "boolean" then
		return val
	else
		if min and max then
			return math.min( max, math.max( min, val ))
		elseif min then
			return math.max( min, val )
		elseif max then
			return math.min( max, val )
		else
			return val
		end
	end
end

function Genetics:mutateValue( name, val, r )
	local mut = MutationTable[name]

	local r = r or math.random()

	if mut == nil or MutationProbabilities[ mut.rate ] < r then
		return val
	else
		local adjusted = Genetics:adjust(val, mut.change)
		adjusted = Genetics:clampValue(adjusted, mut.min, mut.max)
		if mut.floor then
			return math.floor(adjusted)
		else
			return adjusted
		end
	end

end

function Genetics:asexualMutate( g, r )
	local gn = {}
	local rads = r or 0
	print("ASEXUAL REPRODUCTION")
	for k,v in pairs(g) do
		print ( "MUTATING: "..k.."...")
		gn[k] = Genetics:mutateValue( k, g[k], rads + math.random() )
	end
	return gn
end

function Genetics:reproduce( a, b )

end