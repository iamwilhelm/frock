require 'vector'

Boid = {
   identity = "Boid class",
   radius = 20
}

Boid.MAX_SPEED = 15
Boid.MIN_SPEED = 5
Boid.AVOID_RADIUS = Boid.radius * 3
Boid.AVOID_DAMPER = 200
Boid.ATTRACTION_RADIUS = Boid.radius * 8
Boid.ATTRACTION_DAMPER = 70
Boid.ALIGNMENT_RADIUS = Boid.radius * 3
Boid.ALIGNMENT_DAMPER = 50
Boid.HUNTING_RADIUS = Boid.radius * 10
Boid.HUNTING_DAMPER = 100
Boid.STAY_VISIBLE_DAMPER = 1000

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

function Boid:calculate_avoidance_delta(boids)
   for _, other in ipairs(boids) do
      if self.position:isNearby(Boid.AVOID_RADIUS, other.position) then
         self.velocity_delta = self.velocity_delta + ((self.position - other.position) / Boid.AVOID_DAMPER)
      end
   end
end

function Boid:calculate_attraction_delta(boids)
   local average_position = Vector:new(0, 0)
   local visible_boids = 0
   for _, other in ipairs(boids) do
      if self.position:isNearby(Boid.ATTRACTION_RADIUS, other.position) then
         average_position = average_position + other.position
         visible_boids = visible_boids + 1
      end
   end
   average_position = average_position / visible_boids
   self.velocity_delta = self.velocity_delta + ((average_position - self.position) / Boid.ATTRACTION_DAMPER)
end

function Boid:calculate_alignment_delta(boids)
   alignment_delta = Vector:new(0, 0)
   visible_boids = 0
   for _, other in ipairs(boids) do
      if self.position:isNearby(Boid.ALIGNMENT_RADIUS, other.position) then
         alignment_delta = alignment_delta + other.velocity
         visible_boids = visible_boids + 1
      end
   end
   alignment_delta = alignment_delta / visible_boids
   self.velocity_delta = self.velocity_delta + ((alignment_delta / Boid.ALIGNMENT_DAMPER))
end

function Boid:calculate_hunting_delta(foodstuffs)
   for _, food in ipairs(foodstuffs) do
      if self.position:isNearby(Boid.HUNTING_RADIUS, food.position) then
         self.velocity_delta = self.velocity_delta + ((food.position - self.position) / Boid.HUNTING_DAMPER)
      end
   end
end

function Boid:calculate_stay_visible_delta(boids)
   local mid_x = love.graphics.getWidth() / 2
   local mid_y = love.graphics.getHeight() / 2
   local center_vector = Vector:new(mid_x, mid_y)
   
   self.velocity_delta = self.velocity_delta - ((self.position - center_vector) / Boid.STAY_VISIBLE_DAMPER)
end

function Boid:apply_deltas()
   self.velocity = self.velocity + self.velocity_delta
   self.velocity_delta = Vector:new(0, 0)
end

function Boid:limit_speed()
   if self.velocity:r() > Boid.MAX_SPEED then
      self.velocity = self.velocity / self.velocity:r() * Boid.MAX_SPEED
   end
end

function Boid:navigate(boids, foodstuffs)
   self:calculate_avoidance_delta(boids)
   self:calculate_attraction_delta(boids)
   self:calculate_alignment_delta(boids)
   self:calculate_hunting_delta(foodstuffs)
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
