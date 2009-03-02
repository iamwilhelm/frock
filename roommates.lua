require 'lib/core_ext'

require 'roommates/bucket'
require 'roommates/spatial_hash'

-- A basic spatial database
Roommates = {}

function Roommates:new(xsize, ysize, xres, yres)
   local instance = {}
   setmetatable(instance, self)
   self.__index = self

   instance.xsize = xsize
   instance.ysize = ysize
   instance.bxsize = xsize / xres
   instance.bysize = ysize / yres
   
   instance.hasher = SpatialHash:new(xsize, ysize, xres, yres)

   instance.buckets = {}
   for by = 0, ysize, instance.bysize do
      for bx = 0, xsize, instance.bxsize do
         instance.buckets[instance.hasher:hash(bx, by)] = 
           Bucket:new(bx, by, instance.bxsize, instance.bysize)
      end
   end

   instance.items = {}

   return instance
end

function Roommates:bucket(x, y)
   return self.buckets[hasher:hash(x, y)]
end

function Roommates:insert(item, x, y)
   table.insert(self:bucket(x, y), item)
   self.items[item] = self:bucket(x, y)
end

function Roommates:update(item, x, y)
end

function Roommates:nearest_neighbors(x, y, range)
   local range_xres = math.ceil(range / self.bxsize)
   local range_yres = math.ceil(range / self.bysize)

   neighbors = {}
   for xrange = (x - range), (x + range), range_xres do
      for yrange = (y - range), (y + range), range_yres do
         table_concat(neighbors, self:bucket(xrange, yrange))
      end
   end
   return neighbors
end

function Roommates:draw()
   for _, bucket in ipairs(self.buckets) do
      bucket:draw()
   end
end
