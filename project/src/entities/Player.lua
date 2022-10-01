local tilesize = require "src.constants.Tilesize"
local Gamestate     = requireLibrary("hump.gamestate")

return function(stage)
    local player = {
        x = 0,
        y = 4,
        coin = 0,
    }

    player.update = function(self, dt) end

    player.getTileCoords = function(self)
        return self.x * tilesize, self.y * tilesize
    end

    player.getMouseTileCoords = function(self)
        local x,y = stage.cam:mousePosition()
        local sx, sy = math.floor(x/tilesize), math.floor(y/tilesize)
        return sx, sy
    end

    -- return clamped mouse coordinates
    player.getMouseCoords = function(self)
        local x,y = stage.cam:mousePosition()
        local sx, sy = math.floor(x/tilesize)*tilesize, math.floor(y/tilesize)*tilesize
        return sx, sy
    end

    player.draw = function(self) 
        local px, py = self:getTileCoords()
        love.graphics.draw(Image.player, px, py)
        local sx, sy = self:getMouseCoords()
        love.graphics.setColor(1,0,0)
        if self:canGotoMouse() then
            love.graphics.setColor(1,1,1)
        end
        love.graphics.draw(Image.selector, sx, sy)
    end

    player.drawInventory = function(self)
        love.graphics.printf(self.coin.."C", 32, love.graphics.getHeight() - 32, 32, "center")
    end

    player.canGotoMouse = function(self)
        local px, py = self:getTileCoords()
        local sx, sy = self:getMouseCoords()
        if px == sx or py == sy then
        
            return true
        end
    end

    player.gotoMouse = function(self)
        local px, py = self:getTileCoords()
        local sx, sy = self:getMouseCoords()

        if player:canGotoMouse() then
            player.x, player.y = self:getMouseTileCoords()
            if player.x > 32 then
                Gamestate.switch(Win, {
                    coin = self.coin
                })
            end
            for item in all(stage.items) do 
                if player.x == item.x and player.y == item.y then
                    del(stage.items, item)
                    item:collect()
                end
            end
        end
    end
    return player
end