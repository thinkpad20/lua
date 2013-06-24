function main()
	n = 10
	function fact(a)
		if a <= 1 then return 1
		else return a * fact(a-1)
		end
	end
	print(fact(n))
end