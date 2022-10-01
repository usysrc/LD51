--
--  Death
--

local Gamestate     = requireLibrary("hump.gamestate")
local Camera        = requireLibrary("hump.camera")
local timer         = requireLibrary("hump.timer")
local Vector        = requireLibrary("hump.vector")
local tween         = timer.tween

Death = Gamestate.new()

local stuff

function Death:enter()
    stuff = {}
end

function Death:update(dt)
    timer.update(dt)
    for thing in all(stuff) do
        thing:update(dt)
    end
end

function Death:draw()
    love.graphics.printf("You lost. Try again?\n- space bar -", 0, love.graphics.getHeight()/2, love.graphics.getWidth(),"center")
end

function Death:keypressed(key)
    if key == "space" then
        Gamestate.switch(Game)
    end
    if key == "escape" then
        love.event.push('quit')
    end
end