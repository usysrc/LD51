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
local Enemy         = require "src.entities.Enemy"
local Terrain       = require "src.entities.Terrain"
local tilesize      = require "src.constants.Tilesize"

Game = Gamestate.new()

local stuff
local items
local enemies
local terrain
local player
local secTimer
local cam
local map

function Game:enter()
    local stage = {}
    enemies = {}
    items = {}
    stuff = {}
    map = {}
    terrain = {}
    
    for i=1, 32 do
        for j=1, 8 do
            if math.random() < 0.2 then
                local rock = Terrain(stage, "rock", { solid = true })
                rock.x, rock.y = i, j
                add(terrain, rock)
                map[i..","..j] = rock
            end
        end
    end
    for i=1, 32 do
        if math.random() < 1 then
            local item = Item(stage, ({"coin", "ammo", "heart"})[math.random(1,3)])
            item.x = i
            item.y = math.random(1, 8)
            if not map[item.x..","..item.y] then
                table.insert(items, item)
            end
        end
        if math.random() < 1 then
            local enemy = Enemy(stage, "enemy")
            enemy.x = i
            enemy.y = math.random(1, 8)
            if not map[enemy.x..","..enemy.y] then
                table.insert(enemies, enemy)
            end
        end
    end

    cam = Camera(tilesize*11,tilesize*6,3)
    secTimer = Timer(stage)

    player = Player(stage)

    stage.cam = cam
    stage.items = items
    stage.stuff = stuff
    stage.player = player
    stage.enemies = enemies
    stage.terrain = terrain
    stage.map = map
end

function Game:update(dt)
    timer.update(dt)
    secTimer:update(dt)
    player:update(dt)
    for thing in all(stuff) do
        thing:update(dt)
    end
    for enemy in all(enemies) do
        enemy:update(dt)
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
    for feature in all(terrain) do
        feature:draw()
    end
    for item in all(items) do
        item:draw()
    end
    for thing in all(stuff) do
        thing:draw()
    end
    for enemy in all(enemies) do
        enemy:draw()
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
        local ok = player:gotoMouse()
        if not ok then return end
        for enemy in all(enemies) do
            enemy:turn()
        end
    end
end