-- variables to show various awareness radii
show_physical_radius = false
show_attraction_radius = false
show_avoidance_radius = false
show_alignment_radius = false
show_hunting_radius = false
show_buckets = false

function toggle_status_keys(key)
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
   elseif key == love.key_b then
      show_buckets = toggle(show_buckets)
   end
end

function draw_boids_debug(boid)
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

function draw_world_debug()
   if show_buckets then
      -- draw the buckets
      spatial_db:draw()
   end
end

function draw_boid_status(x, y)
   love.graphics.draw("Boids: "..table.getn(boids), x, y)
   y = y + 15
   love.graphics.draw("Plants: "..table.getn(foodstuffs), x, y)
   y = y + 15
   love.graphics.draw("FPS: "..love.timer.getFPS(), x, y)
   y = y + 15
   love.graphics.draw("flap rate:"..boids[1]:flap_rate(), x, y)
   y = y + 15
end

function draw_radius_status(x, y)
   love.graphics.draw("1) physical radius: "..tostring(show_physical_radius), x, y)
   y = y + 15
   love.graphics.draw("2) attraction radius: "..tostring(show_attraction_radius), x, y)
   y = y + 15
   love.graphics.draw("3) avoidance radius: "..tostring(show_avoidance_radius), x, y)
   y = y + 15
   love.graphics.draw("4) alignment radius: "..tostring(show_alignment_radius), x, y)
   y = y + 15
   love.graphics.draw("5) hunting radius: "..tostring(show_hunting_radius), x, y)
   y = y + 15
   love.graphics.draw("b) buckets: "..tostring(show_buckets), x, y)
end
