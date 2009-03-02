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
end
