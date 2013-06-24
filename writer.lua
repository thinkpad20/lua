function write(a)
   return function(b)
      io.write(a)
      return write(b) -- ain't that a nifty little trick? :)
   end
end

--testing out this writer, it seems to work:
print("Writer test:")
write('hello')