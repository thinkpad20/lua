function Baz()
	local bobo = 0
	local hooba = 1
	return function()
		return {bobo=bobo, hooba=hooba}
	end
end