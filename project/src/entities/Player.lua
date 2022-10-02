local tilesize = require "src.constants.Tilesize"
local Gamestate     = requireLibrary("hump.gamestate")

return function(stage)
    local player = {
        x = 0,
        y = 4,
        coin = 0,
        hp = 3,
        maxhp = 3,
        ammo = 2
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

    player.enemyUnderMouse = function(self)
        local stx, sty = self:getMouseTileCoords()
        for enemy in all(stage.enemies) do
            if enemy.x == stx and enemy.y == sty then
                return enemy
            end
        end
    end

    player.draw = function(self) 
        local px, py = self:getTileCoords()
        love.graphics.draw(Image.player, px, py)
        local sx, sy = self:getMouseCoords()
        love.graphics.setColor(1,0,0)
        if self:canGotoMouse() then
            if self:enemyUnderMouse() then
                love.graphics.draw(Image.crosshair, sx, sy)
            else 
                love.graphics.setColor(1,1,1)
                love.graphics.draw(Image.selector, sx, sy)
            end
        end
    end

    player.drawInventory = function(self)
        love.graphics.printf(self.coin.."C", 32, love.graphics.getHeight() - 32, 32, "center")
        love.graphics.printf(self.ammo.."AMMO", love.graphics.getWidth() - 160, love.graphics.getHeight() - 32, 96, "center")

        -- healthbar
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", love.graphics.getWidth()/2 - 64, 16, 128*self.hp/self.maxhp, 16)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line", love.graphics.getWidth()/2 - 64, 16, 128, 16)
        love.graphics.setColor(0,0,0)
        love.graphics.printf(self.hp.."/"..self.maxhp, love.graphics.getWidth()/2 - 64, 10, 128, "center")
        love.graphics.setColor(1,1,1)
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
        local enemy = player:enemyUnderMouse()
       
        if player:canGotoMouse() then
            if enemy then
                if self.ammo > 0 then
                    self.ammo = self.ammo - 1
                    Sfx.laserShoot:play()
                    del(stage.enemies, enemy)
                else
                    Sfx.invalid:play()
                end
                return
            end

            local tx, ty = self:getMouseTileCoords()
            local move = function()
                for x=player.x, tx, tx > player.x and 1 or -1 do
                    for y=player.y, ty, ty > player.y and 1 or -1 do
                        local terrain = stage.map[x..","..y]
                        local enemy
                        for e in all(stage.enemies) do
                            if e.x == x and e.y == y then
                                enemy = e
                            end
                        end
                        if terrain and terrain.opt.solid then
                            return
                        elseif enemy then
                            return
                        else
                            player.x = x
                            player.y = y
                        end
                    end
                end
            end
            Sfx.jump:play()
            move()
            if player.x > 32 then
                Gamestate.switch(Win, {
                    coin = self.coin
                })
            end
            for item in all(stage.items) do 
                if player.x == item.x and player.y == item.y then
                    local persist = item:collect()
                    if not persist then
                        Sfx.pickupCoin:play()
                        del(stage.items, item)
                    end
                end
            end
            return true
        end
    end

    player.hit = function(self, amt)
        self.hp = self.hp - amt
        if self.hp <= 0 then
            Gamestate.switch(Death)
        end
    end
    return player
end