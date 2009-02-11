-- Author       : Wilhelm Chung - http://webjazz.blogspot.com

love.filesystem.require 'food.lua'
love.filesystem.require 'boid.lua'

function load()
   math.randomseed(os.time())
   num_boids = 30
   num_foodstuff = 5
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
      boid:move()
      boid:update(dt)
      
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
   end

   love.graphics.draw("Boids: "..table.getn(boids), 10, 20)
   love.graphics.draw("Plants: "..table.getn(foodstuffs), 10, 35)
   love.graphics.draw("FPS: "..love.timer.getFPS(), 10, 50)
   love.graphics.draw("dt: "..love.timer.getDelta(), 10, 65)
end

function mousepressed(x, y, button)
   if button == love.mouse_left then
      table.insert(foodstuffs, Food:new(x, y))
   end
end
