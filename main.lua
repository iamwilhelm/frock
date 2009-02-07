-- Author       : Wilhelm Chung - http://webjazz.blogspot.com
-- Summary      : A port of Wally Glutton (http://stungeye.com)'s hungry boids
--                to Lua's Love
--
-- Boid Algo    : http://www.vergenet.net/~conrad/boids/pseudocode.html 

require 'food'

function load()
   math.randomseed(os.time())
   num_boids = 20
   num_foodstuff = 5
   boids = {}
   foodstuffs = {}

   for i = 1, num_boids do
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
   -- draw each food
   for _, food in ipairs(foodstuffs) do
      food:draw()
   end
end

function mousepressed()
end
