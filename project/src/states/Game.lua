--
--  Game
--

local Gamestate     = requireLibrary("hump.gamestate")
local Camera        = requireLibrary("hump.camera")
local timer         = requireLibrary("hump.timer")
local Vector        = requireLibrary("hump.vector")
local tween         = timer.tween
local Item          = require("src.entities.Item")
local Timer         = require("src.entities.Timer")
local Player        = require "src.entities.Player"
local tilesize      = require "src.constants.Tilesize"

Game = Gamestate.new()

local stuff
local items
local player
local secTimer
local cam

function Game:enter()
    local stage = {}
    items = {}
    for i=1, 32 do
        if math.random() < 1 then
            local item = Item(stage, "coin")
            item.x = i
            item.y = math.random(1, 8)
            table.insert(items, item)
        end
    end
    cam = Camera(tilesize*11,tilesize*6,3)
    secTimer = Timer(stage)

    player = Player(stage)

    stage.cam = cam
    stage.items = items
    stage.stuff = stuff
    stage.player = player
end

function Game:update(dt)
    timer.update(dt)
    secTimer:update(dt)
    player:update(dt)
    for thing in all(stuff) do
        thing:update(dt)
    end
end

function Game:draw()
    cam:attach()
    secTimer:highlight()
    love.graphics.setColor(1,1,1)
    for i=0,32 do
        for j=0,8 do
            love.graphics.draw(Image.grass, i*tilesize, j*tilesize)
        end
    end
    for item in all(items) do
        item:draw()
    end
    for thing in all(stuff) do
        thing:draw()
    end
    player:draw()
    cam:detach()
    secTimer:draw()
    player:drawInventory()
end

function Game:keypressed(key)
    if key == "escape" then
        love.event.push('quit')
    end
end

function Game:mousepressed(x,y,btn)
    if btn == 1 then
        player:gotoMouse()
    end
end