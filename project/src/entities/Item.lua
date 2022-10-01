local tilesize = require "src.constants.Tilesize"
return function(stage, typ)
    local item = {
        x = 0,
        y = 0,
        typ = typ
    }
    item.draw = function(self)
        love.graphics.draw(Image[typ], self.x * tilesize, self.y * tilesize)
    end
    item.collect = function(self)
        if self.typ == "coin" then
            stage.player.coin = stage.player.coin + 1
        end
        if self.typ == "ammo" then
            stage.player.ammo = stage.player.ammo + 1
        end
        if self.typ == "heart" then
            if stage.player.hp == stage.player.maxhp then
                return true
            end
            stage.player.hp = stage.player.hp + 1
            if stage.player.hp > stage.player.maxhp then
                stage.player.hp = stage.player.maxhp
                return true
            end
        end
    end
    return item
end