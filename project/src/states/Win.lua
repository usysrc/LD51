--
--  Win
--

local Gamestate     = requireLibrary("hump.gamestate")
local Camera        = requireLibrary("hump.camera")
local timer         = requireLibrary("hump.timer")
local Vector        = requireLibrary("hump.vector")
local tween         = timer.tween

Win = Gamestate.new()

local stuff

function Win:enter(prev, data)
    stuff = data
end

function Win:update(dt)
    timer.update(dt)
    for thing in all(stuff) do
        thing:update(dt)
    end
end

function Win:draw()
    love.graphics.printf(string.format("You won.\nCoins collected: %s\nTry again?\n- space bar -", stuff.coin or 0), 0, love.graphics.getHeight()/2, love.graphics.getWidth(),"center")
end

function Win:keypressed(key)
    if key == "space" then
        Gamestate.switch(Game)
    end
    if key == "escape" then
        love.event.push('quit')
    end
end