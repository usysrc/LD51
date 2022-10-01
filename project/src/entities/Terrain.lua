local tilesize = require "src.constants.Tilesize"
return function(stage, typ, opt)
    local item = {
        x = 0,
        y = 0,
        typ = typ,
        opt = opt
    }
    item.draw = function(self)
        love.graphics.draw(Image[typ], self.x * tilesize, self.y * tilesize)
    end
    return item
end