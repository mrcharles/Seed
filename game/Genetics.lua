
Genetics = {}


MutationRate = 
{

	Rare = 1,
	Uncommon = 2,
	Common = 3,
}

local MutationTable = 
{
}

function Genetics:registerValue( val, rate, change )
	MutationTable[val] = { rate, change }

end

function Genetics:mutateValue( val )

function Genetics:reproduce( a, b )

end