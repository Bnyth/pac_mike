require("Mike")
require("walls")

function love.load()
    
    wf = require('libraries/windfield')
    world = wf.newWorld(0, 0)
    sti = require('libraries/sti')
    gameMap = sti('maps/testMap.lua')
    walls:load()
    Mike:load()
    
end

function love.update(dt)
    Mike:update(dt)
    world:update(dt)
end

function love.draw()
    gameMap:drawLayer(gameMap.layers["Ground"])
    gameMap:drawLayer(gameMap.layers["WallsDrawing"])
    Mike:draw()
end