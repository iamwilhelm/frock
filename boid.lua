require 'vector'

Boid = {
   identity = "Boid class",
   radius = 20
}

-- Boid.MAX_SPEED = 20
-- Boid.AVOID_RADIUS = Boid.radius * 3
-- Boid.AVOID_DAMPER = 50
-- Boid.ATTRACTION_RADIUS = Boid.radius * 8
--    alignmentRadius = self.radius * 3,
--    alignmentDamper = 50,
--    huntingRadius = self.radius * 5,
--    huntingDamper = 10,
--    stayVisibleDamper = 400


function Boid:new(x, y, vx, vy)
   local instance = {}
   setmetatable(instance, self)
   self.__index = self

   instance.velocity = Vector:new(vx, vy)
   instance.position = Vector:new(x, y)
   instance.velocity_delta = Vector:new(0, 0)
   instance.sprite = love.graphics.newImage("cow.png")

   return instance
end

function Boid:draw()
   love.graphics.draw(self.sprite, self.position.x, self.position.y)
end
