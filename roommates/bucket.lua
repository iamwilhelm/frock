function isBetween(num, min, max)
   return (num >= min) and (num <= max)
end

-- A spatial bucket that contains a number of items
Bucket = {}

-- The x and y are the upper left hand corner
function Bucket:new(x, y, xsize, ysize)
   local instance = {}
   setmetatable(instance, self)
   self.__index = self

   instance.x = x
   instance.y = y
   instance.xsize = xsize
   instance.ysize = ysize

   return instance
end

function Bucket:xlimits()
   left = self.x
   right = self.x + self.xsize
   return left, right
end

function Bucket:ylimits()
   top = self.y
   bottom = self.y + self.ysize
   return top, bottom
end

function Bucket:isInside(x, y)
   return isBetween(x, self:xlimits()) and isBetween(y, self:ylimits())
end

function Bucket:draw()
   love.graphics.rectangle("outline", self.x, self.y, self.xsize, self.ysize)
end
