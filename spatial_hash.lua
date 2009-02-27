SpatialHash = {
}

-- Why is there no default table concat method?  Gotta roll my own
-- currently, it destructive alters table1
function table_concat(t1, t2)
   for _, v in iparis(t2) do
      table.insert(t1, v)
   end
   return t1
end

function SpatialHash.new(xsize, ysize, resx, resy)
   local instance = {}
   setmetatable(instance, self)
   self.__index = self

   instance.xsize = xsize
   instance.ysize = ysize
   instance.resx = resx
   instance.resy = resy

   instance.buckets = {}
   for i = 1, (resx * resy) do
      buckets[i] = {}
   end

   return instance
end

function SpatialHash.insert(item, x, y)
   table.insert(self:bucket(x, y), item)
end

function SpatialHash.update(item, x, y)
   -- if the item's new x and y exceeds its bucket boundaries...
end

function SpatialHash.hash_x(x)
   return math.floor((x / self.xsize) * self.resx)
end

function SpatialHash.hash_y(y)
   return math.floor((y / self.ysize) * self.resy)
end

function SpatialHash.hash(x, y)
   return self:hash_x(x) + self:hash_y(y) * self.resx
end

function SpatialHash.bucket(x, y)
   return buckets[self:hash(x, y)]
end

function SpatialHash.nearest_neighbors(x, y, range)
   local range_xres = math.ceil(range / self.xres)
   local range_yres = math.ceil(range / self.yres)

   neighbors = {}
   for xrange = (x - range), (x + range), range_xres do
      for yrange = (y - range), (y + range), range_yres do
         table_concat(neighbors, self:bucket(xrange, yrange))
      end
   end
   return neighbors
end

