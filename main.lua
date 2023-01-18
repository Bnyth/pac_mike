require("Mike")
require("walls")
require("Nemesis")

function love.load()
    
    wf = require('libraries/windfield')
    world = wf.newWorld(0, 0)
    sti = require('libraries/sti')
    gameMap = sti('maps/testMap.lua')
    walls:load()
    Mike:load()
    Nemesis:load()
    
end

function love.update(dt)
    Mike:update(dt)
    world:update(dt)
end

function love.draw()
    gameMap:drawLayer(gameMap.layers["Ground"])
    gameMap:drawLayer(gameMap.layers["WallsDrawing"])
    Mike:draw()
    -- Nemesis:draw()
    -- world:draw()
end

function love.keypressed(key, scancode, isrepeat)
    Mike:turnDirections(key)
end

function checkCollision(a, b)
    if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
        return true
    end
    return false
end

function approximatelyEquals(a, b, approximation)
    if a >= b - approximation and a <= b + approximation then
        print("e")
        return true
    end
    return false
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end
  