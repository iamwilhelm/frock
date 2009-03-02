-- Author       : Wilhelm Chung - http://webjazz.blogspot.com

love.filesystem.require 'food.lua'
love.filesystem.require 'boid.lua'

-- variables to show various awareness radii
show_physical_radius = false
show_attraction_radius = false
show_avoidance_radius = false
show_alignment_radius = false
show_hunting_radius = false

function load()
   math.randomseed(os.time())
   num_boids = 25
   num_foodstuff = 1
   boids = {}
   foodstuffs = {}

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
end

function update(dt)
   -- updates vectors for each boid
   for _, boid in ipairs(boids) do
      boid:navigate(boids, foodstuffs)
      boid:move(dt)
      boid:animate(dt)
      
      -- see if each food is isEaten
      for _, food in ipairs(foodstuffs) do
         food:isEaten(boid)
      end
   end

end

function draw()
   -- draw each food
   for _, food in ipairs(foodstuffs) do
      food:draw()
   end
   
   -- draw each boid
   for _, boid in ipairs(boids) do
      boid:draw()
      draw_debug(boid)
   end

   love.graphics.draw("Boids: "..table.getn(boids), 10, 20)
   love.graphics.draw("Plants: "..table.getn(foodstuffs), 10, 35)
   love.graphics.draw("FPS: "..love.timer.getFPS(), 10, 50)
   love.graphics.draw("dt: "..love.timer.getDelta(), 10, 65)
   love.graphics.draw("flap rate:"..boids[1]:flap_rate(), 10, 80)

   love.graphics.draw("physical radius: "..tostring(show_physical_radius), 10, 95)
   love.graphics.draw("attraction radius: "..tostring(show_attraction_radius), 10, 110)
   love.graphics.draw("avoidance radius: "..tostring(show_avoidance_radius), 10, 125)
   love.graphics.draw("alignment radius: "..tostring(show_alignment_radius), 10, 140)
   love.graphics.draw("hunting radius: "..tostring(show_hunting_radius), 10, 155)
end

function mousepressed(x, y, button)
   if button == love.mouse_left then
      table.insert(foodstuffs, Food:new(x, y))
   end
end

function keyreleased(key)
   if key == love.key_1 then
      show_physical_radius = toggle(show_physical_radius)
   elseif key == love.key_2 then
      show_attraction_radius = toggle(show_attraction_radius)
   elseif key == love.key_3 then
      show_avoidance_radius = toggle(show_avoidance_radius)
   elseif key == love.key_4 then
      show_alignment_radius = toggle(show_alignment_radius)
   elseif key == love.key_5 then
      show_hunting_radius = toggle(show_hunting_radius)
   end
end

function draw_debug(boid)
   if show_physical_radius then
      boid:draw_physical()
   end
   if show_attraction_radius then
      boid:draw_attraction()
   end
   if show_avoidance_radius then
      boid:draw_avoidance()
   end
   if show_alignment_radius then
      boid:draw_alignment()
   end
   if show_hunting_radius then
      boid:draw_hunting()
   end   
end

function toggle(variable)
   if (variable == true) then
      return false
   else
      return true
   end
end
