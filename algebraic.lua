-- local list = ...
-- local L = {}
-- _G[list] = L
-- package.loaded[list] = L
-- setmetatable(L, {__index = _G})
-- setfenv(1, M)

local list = {}

-- returns an empty list
function list.fin()
   return {fin = true}
end

-- returns a
function list.cons(a, list)
   return {cons = function() return a, list end}
end

-- maps a function over a list
function list.map(f, l)
   if l.fin then 
      return l
   else 
      val, nxt = l.cons()
      return list.cons(f(val), list.map(f, nxt))
   end
end

-- prints a list in [a,b,c] form
function list.print(l)
   io.write("[")
   if l.cons then
      val, nxt = l.cons()
      io.write(val)
      list.map(function (a) io.write(", ", a) end, nxt)
   end
   print("]")
end

function list.concat(list1, list2)
   if list1.fin then
      return list2
   else
      val, nxt = list1.cons()
      return list.cons(val, list.concat(nxt, list2))
   end
end

-- converts a string to a list of characters
function list.str(s)
   if #s == 0 then
      return list.fin()
   else
      return list.cons(s:sub(1, 1), list.str(s:sub(2, #s)))
   end
end

-- prints a list of characters as a string
function list.printstr(str)
   if str.cons then
      ch, nxt = str.cons()
      io.write(ch); list.printstr(nxt)
   else
      print()
   end
end

function list.single(a)
   return list.cons(a, list.fin())
end

function list.range_asc(start, fin, asc)
   if (asc and start > fin) or (not asc and start < fin) then
      return list.fin()
   else
      return list.cons(start, list.range_asc(asc and start+1 or start-1, fin, asc))
   end
end

function list.range(start, fin)
   return list.range_asc(start, fin, start < fin)
end


-- Examples:
-- a = list.str("hello")
-- b = list.str(", world!")
-- list.printstr(a)
-- list.printstr(list.concat(a, b))
-- list.print(list.single(5))
-- list.print(list.range(1, 10))
-- list.print(list.map(function (x) return x^3 end, list.range(1, 20)))

return list