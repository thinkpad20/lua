function foo(a, b)
	return a + b
end

function bar()
	foo
end

print(bar(8, 9))