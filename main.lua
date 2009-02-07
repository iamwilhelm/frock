-- Author       : Wilhelm Chung - http://webjazz.blogspot.com
-- Summary      : A port of Wally Glutton (http://stungeye.com)'s hungry boids
--                to Lua's Love
--
-- Boid Algo    : http://www.vergenet.net/~conrad/boids/pseudocode.html 

require 'food'
require 'boid'

function load()
   math.randomseed(os.time())
   num_boids = 20
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
   -- see if each food is isEaten
end

function draw()
   -- draw each boid
   for _, boid in ipairs(boids) do
      boid:draw()
   end

   -- draw each food
   for _, food in ipairs(foodstuffs) do
      food:draw()
   end

   love.graphics.draw(table.getn(boids), 10, 20)
end

function mousepressed(x, y, button)
   if button == love.mouse_left then
      table.insert(foodstuffs, Food:new(x, y))
   end
end
