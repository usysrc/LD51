local tilesize  = require "src.constants.Tilesize"
local timer     = requireLibrary("hump.timer")
local Gamestate = requireLibrary("hump.gamestate")

return function(stage)
    local timer = {
        time = 10,
        scale = 1,
        turn = 1,
        moveTiles = 5,
        events = {
            function(self)
                local tx = stage.cam.x + tilesize*self.moveTiles
                timer.tween(1, stage.cam, {x = tx},"linear", function()
                    if stage.player.x * tilesize < stage.cam.x - (love.graphics.getWidth()/6) then
                        Gamestate.switch(Death)
                    end 
                end)
            end,
            function(self)
                timer.tween(0.2, self, {scale = 2}, "quad", function()
                    timer.tween(0.5, self, {scale = 1}, "quad")
                end)
            end,
            function(self)
                self.turn = self.turn + 1
            end
        }
    }
    timer.update = function(self, dt)
        self.time = self.time - dt
        if self.time <= 0 then
            self.time = 10
            for event in all(self.events) do
                event(self)
            end
        end
    end
    timer.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.push()
        love.graphics.setColor(0.2,0.2,0.2)
        local x,y = love.graphics.getWidth()/2, love.graphics.getHeight() - 32
        love.graphics.circle("fill", x, y+12, self.scale*32)
        love.graphics.setColor(1,1,1)
        love.graphics.printf(string.format("%02d", math.ceil(self.time)), x - 16, y, 32, "center")
        love.graphics.pop()
    end

    timer.highlight = function(self)
        love.graphics.setColor(1,0,0,2*(self.time%0.5))
        love.graphics.rectangle("line", 0,0, self.turn * self.moveTiles * tilesize,9*tilesize)
    end
    return timer
end