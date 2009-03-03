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
   instance.items = {}

   return instance
end

function Bucket:center()
   return self.x + self.xsize / 2, self.y + self.ysize / 2
end

function Bucket:xlimits()
   return self.x, self.x + self.xsize
end

function Bucket:ylimits()
   return self.y, self.y + self.ysize
end

function Bucket:contains(x, y)
   return isBetween(x, self:xlimits()) and isBetween(y, self:ylimits())
end

function Bucket:toArray()
   local items = {}
   for item, _ in ipairs(self.items) do
      table.insert(items, item)
   end
   return items
end

function Bucket:add(item)
   self.items[item] = true
end

function Bucket:remove(item)
   self.items[item] = nil
end

function Bucket:draw()
   love.graphics.setColor(178, 226, 246, 128)
   love.graphics.rectangle(love.draw_line, self.x, self.y, self.xsize, self.ysize)
   love.graphics.setColor(255, 255, 255, 255)
end
