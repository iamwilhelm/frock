require 'vector'

Boid = {
   identity = "Boid class",
   radius = 20
}

Boid.MAX_SPEED = 20
Boid.AVOID_RADIUS = Boid.radius * 3
Boid.AVOID_DAMPER = 50
Boid.ATTRACTION_RADIUS = Boid.radius * 8
Boid.ALIGNMENT_RADIUS = Boid.radius * 3
Boid.ALIGNMENT_DAMPER = 50
Boid.HUNTING_RADIUS = Boid.radius * 5
Boid.HUNTING_DAMPER = 10
Boid.STAY_VISIBLE_DAMPER = 400

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

function Boid:calculate_stay_visible_delta(boids)
   local mid_x = love.graphics.getWidth() / 2
   local mid_y = love.graphics.getHeight() / 2
   local center_vector = Vector:new(mid_x, mid_y)
   
   self.velocity_delta = self.velocity_delta - (self.position - center_vector) / Boid.STAY_VISIBLE_DAMPER
end

function Boid:apply_deltas()
   self.velocity = self.velocity + self.velocity_delta
   self.velocity_delta = Vector:new(0, 0)
end

function Boid:limit_speed()
   if self.velocity:r() > Boid.MAX_SPEED then
      self.velocity = self.velocity / self.velocity:r()
   end
end

function Boid:navigate(boids)
   self:calculate_stay_visible_delta(boids)
end

function Boid:move()
   self:apply_deltas()
   self:limit_speed()
   self.position = self.position + self.velocity
end

function Boid:draw()
   love.graphics.draw(self.sprite, self.position.x, self.position.y)
end
