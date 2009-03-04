-- Author       : Wilhelm Chung - http://webjazz.blogspot.com

love.filesystem.require 'food.lua'
love.filesystem.require 'boid.lua'
love.filesystem.require 'roommates.lua'
love.filesystem.require 'status.lua'

function load()
   math.randomseed(os.time())
   num_boids = 25
   num_foodstuff = 1
   boids = {}
   foodstuffs = {}

   love.graphics.setLineWidth(2)
   font = love.graphics.newFont(love.default_font, 14)
   love.graphics.setFont(font)

   for i = 1, num_boids do
      boids[i] = Boid:new(math.random() * love.graphics.getWidth(),
                          math.random() * love.graphics.getHeight(),
                          math.random(30) - 15,
                          math.random(30) - 15)
   end

   for i = 1, num_foodstuff do
      foodstuffs[i] = Food:new()
   end
   
   spatial_db = Roommates:new(love.graphics.getWidth(), love.graphics.getHeight(), 10, 10)
end

function update(dt)
   -- updates the spatial data structure
   for _, boid in ipairs(boids) do
      --spatial_db:update(boid, boid.position.x, boid.position.y)
   end

   -- updates vectors for each boid
   for _, boid in ipairs(boids) do
      neighbors = boids -- spatial_db:neighbors(boid.position.x, boid.position.y, Boid.ATTRACTION_RADIUS)
      boid:navigate(neighbors, foodstuffs)
      boid:move(dt)
      boid:animate(dt)

      -- wrap boids in torus
      torus(boid)
      
      -- see if each food is isEaten
      for _, food in ipairs(foodstuffs) do
         food:isEaten(boid)
      end
   end
end

function draw()
   draw_world_debug(boid)

   -- draw each food
   for _, food in ipairs(foodstuffs) do
      food:draw()
   end
   
   -- draw each boid
   for _, boid in ipairs(boids) do
      draw_boids_debug(boid)
      boid:draw()
   end

   draw_boid_status(10, 20)
   draw_radius_status(10, 600)
end

function mousepressed(x, y, button)
   if button == love.mouse_left then
      table.insert(foodstuffs, Food:new(x, y))
   end
end

function keyreleased(key)
   toggle_status_keys(key)   
end

function toggle(variable)
   if (variable == true) then
      return false
   else
      return true
   end
end

-- breaks encapsulation
function torus(boid)
   if boid.position.x >= love.graphics.getWidth() then
      boid.position = Vector:new(boid.position.x - love.graphics.getWidth(), boid.position.y)
   elseif boid.position.x <= 0 then
      boid.position = Vector:new(love.graphics.getWidth() + boid.position.x, boid.position.y)
   elseif boid.position.y >= love.graphics.getHeight() then
      boid.position = Vector:new(boid.position.x, boid.position.y - love.graphics.getHeight())
   elseif boid.position.y <= 0 then
      boid.position = Vector:new(boid.position.x, love.graphics.getHeight() + boid.position.y)
   end
end
