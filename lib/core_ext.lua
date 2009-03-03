-- Why is there no default table concat method?  Gotta roll my own
-- currently, it destructive alters table1
function table_concat(t1, t2)
   for _, v in ipairs(t2) do
      table.insert(t1, v)
   end
   return t1
end
