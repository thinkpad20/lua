--[[
It would be nice to be able to curry in Lua. Take the list printing function. 

function list.print(l)
   io.write("[")
   if l.cons then
      val, nxt = l.cons()
      io.write(val)
      list.map(function (a) io.write(", ", a) end, nxt)
   end
   print("]")
end

It's a little silly to have to declare a new function. If we had 
currying, we could do something like this:

list.map(io.write(", "), nxt)

But unlike Haskell, a multivariable function in is not really a function 
which returns another function, but instead a proper multivariate function,
so that io.write(",") is a value (or nil in this case). What we need is 
something to simulate this:
]]

function curry (fun, arg)
   return function (a) --takes one argument
      return fun(arg, a)
   end
end

--[[
and now we can call

list.map(curry(io.write, ", "), nxt)

Which we don't in the code (because in this case it's not really any better)
but it would work.

]]


function plus(a, b) return a + b end
plus5 = curry(plus, 5)

print(plus5(6)) -- prints 11

print5and = curry(print, 5) -- works

-- Unfortunately, this approach doesn't work with more than one argument
print5and6and = curry(print, 5, 6)
print5and6and(7) -- only prints 5 and 7

-- We can hack this with curry2:
function curry2 (fun, arg1, arg2)
   return function(a)
      return fun(arg1, arg2, a)
   end
end

print5and6and = curry2(print, 5, 6)
print5and6and(7) -- prints 5 6 7 correctly


--[[
One solution to this is to always structure your code so that everything 
returns a function, so that you can use currying natively:
]]

function add(a)
   return function (b)
      return a + b
   end
end

print(add(34)(10)) -- prints 44

add17 = add(17)

print(add17(11)) -- prints 28


-- Let's try reformulating the list code like this. Fin is the same as before:
function newfin() return {fin = true} end

-- But the other stuff is a little different:
function newcons(val)
   return function(nxt)
      return {cons=function () return val, nxt end}
   end
end

function newmap(f)
   return function(l)
      if l.fin then 
         return l
      else 
         val, nxt = l.cons()
         return newcons(f(val))(newmap(f)(nxt))
      end
   end
end

-- a simplified print, just prints on lines
function simpleprint(l)
   newmap(print)(l)
end

-- let's test it out
l = newfin()
for i = 1,10 do l = newcons(i)(l) end

print("Simpleprint test:")
simpleprint(l) -- prints as expected

-- now let's beef print up a little. First let's make a currying writer:

function write(a)
   io.write(a)
   return function(b)
      return write(b) -- ain't that a nifty little trick? :)
   end
end

--testing out this writer, it seems to work:
print("Writer test:")
write('hello')(', world!')('\n')

function newprint(l)
   write("[")
   if l.cons then
      val, nxt = l.cons()
      write(val)
      newmap(write(", "))(nxt)
   end
   print("]")
end

-- let's try it out:
print("Newprint test:")
newprint(l)

-- prints: [10, 987654321]
-- Drat! What happened? 

-- Ah well, I guess we can use a lambda after all
function newprint(l)
   write("[")
   if l.cons then
      val, nxt = l.cons()
      write(val)
      newmap(function (a) write(", ")(a) end)(nxt)
   end
   print("]")
end

--and now, it works
print("Newprint test:")
newprint(l)

-- function compose(f1)
--    return function (f2)
--       return function(a)
--          f1(f2)(a)
--       end
--    end
-- end

-- function mult(a)
--    return function(b)
--       return a * b
--    end
-- end

-- function yo(a)
--    print(yo)
-- end

-- l = newmap(mult(5))(l)

-- newprint(l)

-- l = compose(newmap)(yo)(l)

-- newprint(l)