local tilesize = require "src.constants.Tilesize"
local timer    = requireLibrary("hump.timer")

return function(stage, typ)
    local enemy = {
        x = 0,
        y = 0,
        typ = typ,
        dir = {x = 0, y = 0}
    }
    enemy.randomDirection = function()
        enemy.dir = {x = 0, y = 0}
        if math.random() < 0.5 then
            enemy.dir.x = math.random() < 0.5 and -1 or 1
        else
            enemy.dir.y = math.random() < 0.5 and -1 or 1
        end
    end
    enemy:randomDirection()
    enemy.draw = function(self)
        local px, py = self.x * tilesize, self.y * tilesize
        love.graphics.draw(Image[typ], px, py)
        if self.dir.x == -1 then love.graphics.draw(Image.arrowleft, px, py) end
        if self.dir.x == 1 then love.graphics.draw(Image.arrowright, px, py) end
        if self.dir.y == 1 then love.graphics.draw(Image.arrowdown, px, py) end
        if self.dir.y == -1 then love.graphics.draw(Image.arrowup, px, py) end
    end
    enemy.update = function(self, dt) end
    enemy.turn = function(self)
        for k=1,4 do
            if self.x + self.dir.x*k == stage.player.x and self.y + self.dir.y*k == stage.player.y then
                local bullet = {
                    x = self.x,
                    y = self.y
                }
                bullet.draw = function(self)
                    love.graphics.circle("fill", self.x * tilesize + tilesize/2, self.y * tilesize + tilesize/2, 2, 32)
                end
                bullet.update = function(self, dt) end
                table.insert(stage.stuff, bullet)
                timer.tween(0.05, bullet, {x = stage.player.x, y = stage.player.y}, "linear", function()
                    del(stage.stuff, bullet)
                    stage.player:hit(1)
                end)
                
            end
        end
        -- enemy:randomDirection()
    end
    return enemy
end