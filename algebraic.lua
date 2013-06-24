-- returns an empty list
function list_end()
  return {list_end = function() return true end}
end

-- returns a
function cons(a, list)
  return {cons = function() return a, list end}
end

-- prints a list in [a,b,c] form
function print_list(list)
  printR = function(list, isfirst)
    if isfirst and list.cons then
        val, nxt = list.cons()
        io.write(val); printR(nxt, false)
    else if list.cons then
        val, nxt = list.cons()
        io.write(", ", val); printR(nxt, false)
      end
    end
  end
  io.write("[")
  printR(list, true)
  print("]")
end

function concat(list1, list2)
  if list1.list_end then
    return list2
  else
    val, nxt = list1.cons()
    return cons(val, concat(nxt, list2))
  end
end

-- converts a string to a list of characters
function strlist(str)
  if #str == 0 then
    return list_end()
  else
    return cons(str:sub(1, 1), strlist(str:sub(2, #str)))
  end
end

-- prints a list of characters as a string
function printstr(str)
  if str.cons then
    ch, nxt = str.cons()
    io.write(ch); printstr(nxt)
  else
    print()
  end
end

function singleton(a)
  return cons(a, list_end())
end

function list_range_asc(start, fin, asc)
  if (asc and start > fin) or (not asc and start < fin) then
    return list_end()
  else
    return cons(start, list_range_asc(asc and start+1 or start-1, fin, asc))
  end
end

function list_range(start, fin)
  return list_range_asc(start, fin, start < fin)
end

function list_map(fun, list)
  if list.list_end then 
    return list
  else 
    val, nxt = list.cons()
    return cons(fun(val), list_map(fun, nxt))
  end
end

lst = list_end()
lst2 = list_end()

for i=1,10 do
  lst = cons(i, lst)
end

for i=11,20 do
  lst2 = cons(i, lst2)
end

a = "hello"

printstr(strlist(a))

print_list(list_range(1, 10))

print_list(list_map(function (x) return x^3 end, list_range(1, 20)))