-- returns a hash for the 2D spatial
SpatialHash = {}

function SpatialHash:new(xsize, ysize, resx, resy)
   local instance = {}
   setmetatable(instance, self)
   self.__index = self

   instance.xsize = xsize
   instance.ysize = ysize
   instance.resx = resx
   instance.resy = resy

   return instance
end

function SpatialHash:hash_x(x)
   return math.floor((x / self.xsize) * self.resx)
end

function SpatialHash:hash_y(y)
   return math.floor((y / self.ysize) * self.resy)
end

function SpatialHash:hash(x, y)
   return self:hash_x(x) + self:hash_y(y) * self.resx
end
