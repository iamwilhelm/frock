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

   instance.bucket_of_items = {}

   return instance
end

function Roommates:bucket(x, y)
   return self.buckets[self.hasher:hash(x, y)]
end

function Roommates:insert(item, x, y)
   self:bucket(x, y):add(item)
   self.bucket_of_items[item] = self:bucket(x, y)
end

function Roommates:remove(item, x, y)
   self:bucket(x, y):remove(item)
   self.bucket_of_items[item] = nil
end

function Roommates:update(item, x, y)
   local bucket_of_item = self.bucket_of_items[item]
   if bucket_of_item == nil then
      self:insert(item, x, y)
      return
   end
   if bucket_of_item:contains(x, y) then
      return
   end
   
   self:remove(item, x, y)
   self:insert(item, x, y)
end

function Roommates:neighbors(x, y, range)
   local range_xres = math.ceil(range / self.bxsize)
   local range_yres = math.ceil(range / self.bysize)
   local neighbors = {}

   for xrange = (x - range), (x + range), math.floor(range_xres) do
      for yrange = (y - range), (y + range), math.floor(range_yres) do
         --table_concat(neighbors, self:bucket(xrange, yrange):toArray())
      end
   end
   return neighbors
end

function Roommates:draw()
   for hash, bucket in ipairs(self.buckets) do
      bucket:draw()
      love.graphics.draw(hash, bucket:center())
   end
end
