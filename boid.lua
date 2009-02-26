require 'vector.lua'

Boid = {
   identity = "Boid class",
   radius = 20
}

Boid.MAX_SPEED = 175
Boid.MIN_SPEED = 100
Boid.AVOID_RADIUS = Boid.radius * 3
Boid.AVOID_AMPLIFIER = 6
Boid.ATTRACTION_RADIUS = Boid.radius * 8
Boid.ATTRACTION_DAMPER = 10
Boid.ALIGNMENT_RADIUS = Boid.radius * 3
Boid.ALIGNMENT_DAMPER = 8
Boid.HUNTING_RADIUS = Boid.radius * 10
Boid.HUNTING_DAMPER = 5
Boid.STAY_VISIBLE_DAMPER = 40

function Boid:new(x, y, vx, vy)
   local instance = {}
   setmetatable(instance, self)
   self.__index = self

   instance.velocity = Vector:new(vx, vy)
   instance.position = Vector:new(x, y)
   instance.velocity_delta = Vector:new(0, 0)

   instance.left_sprite = love.graphics.newImage("images/left_chicken.png")
   instance.right_sprite = love.graphics.newImage("images/right_chicken.png")
   instance.left_anim = love.graphics.newAnimation(instance.left_sprite, 18, 18, 
                                                   instance:flap_rate())
   instance.right_anim = love.graphics.newAnimation(instance.right_sprite, 18, 18, 
                                                    instance:flap_rate())
   instance.anim = left_anim

   return instance
end

function Boid:flap_rate()
   return 0.1--self.velocity:r() / Boid.MAX_SPEED / 4
end

function Boid:calculate_avoidance_delta(boids)
   for _, other in ipairs(boids) do
      if self.position:isNearby(Boid.AVOID_RADIUS, other.position) then
         local avoid_vector = (self.position - other.position)
         local unit_avoid_accel = avoid_vector:norm()
         local avoid_multiplier = Boid.AVOID_RADIUS * Boid.AVOID_AMPLIFIER / avoid_vector:r()
         local avoid_accel = unit_avoid_accel * avoid_multiplier
         self.velocity_delta = self.velocity_delta + avoid_accel
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
   self.velocity_delta = self.velocity_delta + 
      ((average_position - self.position) / Boid.ATTRACTION_DAMPER)
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
   self.velocity_delta = self.velocity_delta + 
      ((alignment_delta / Boid.ALIGNMENT_DAMPER))
end

function Boid:calculate_hunting_delta(foodstuffs)
   for _, food in ipairs(foodstuffs) do
      if self.position:isNearby(Boid.HUNTING_RADIUS, food.position) then
         self.velocity_delta = self.velocity_delta + 
            ((food.position - self.position) / Boid.HUNTING_DAMPER)
      end
   end
end

function Boid:calculate_stay_visible_delta(boids)
   local mid_x = love.graphics.getWidth() / 2
   local mid_y = love.graphics.getHeight() / 2
   local center_vector = Vector:new(mid_x, mid_y)
   
   self.velocity_delta = self.velocity_delta - 
      ((self.position - center_vector) / Boid.STAY_VISIBLE_DAMPER)
end

function Boid:apply_deltas()
   self.velocity = self.velocity + self.velocity_delta
   self.velocity_delta = Vector:new(0, 0)
end

function Boid:limit_speed()
   if self.velocity:r() > Boid.MAX_SPEED then
      self.velocity = self.velocity / self.velocity:r() * Boid.MAX_SPEED
   end
   if self.velocity:r() < Boid.MIN_SPEED then
      self.velocity = self.velocity / self.velocity:r() * Boid.MIN_SPEED
   end
end

function Boid:navigate(boids, foodstuffs)
   self:calculate_avoidance_delta(boids)
   self:calculate_attraction_delta(boids)
   self:calculate_alignment_delta(boids)
   self:calculate_hunting_delta(foodstuffs)
   self:calculate_stay_visible_delta(boids)
end

function Boid:move(dt)
   self:apply_deltas()
   self:limit_speed()
   self.position = self.position + self.velocity * dt
end

function Boid:animate(dt)
   if self.velocity.x <= 0 then
      self.anim = self.left_anim
   else
      self.anim = self.right_anim
   end

   self.anim:update(dt)
end

function Boid:draw()
   love.graphics.draw(self.anim, self.position.x, self.position.y, 
                      math.deg(self.velocity:ang()), 1.5)
end
