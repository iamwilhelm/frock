-- returns a hash for the 2D spatial
SpatialHash = {}

function SpatialHash:new(xsize, ysize, xres, yres)
   local instance = {}
   setmetatable(instance, self)
   self.__index = self

   instance.xsize = xsize
   instance.ysize = ysize
   instance.xres = xres
   instance.yres = yres

   return instance
end

function SpatialHash:hash_x(x)
   return math.floor(x / (self.xsize / self.xres))
end

function SpatialHash:hash_y(y)
   return math.floor(y / (self.ysize / self.yres))
end

function SpatialHash:hash(x, y)
   return self:hash_x(x) + self:hash_y(y) * self.xres
end
