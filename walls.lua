walls = {}

function walls:load()
    self.walls = {} 
    if gameMap.layers["Walls"] then
        for _, object in pairs(gameMap.layers["Walls"].objects) do 
            local wall = world:newRectangleCollider(object.x, object.y, object.width, object.height)
            wall.x, wall.y = object.x, object.y
            wall.width, wall.height = object.width, object.height
            wall:setType('static') 
            table.insert(self.walls, wall) 
        end 
    end
end

function walls:getWalls()
    return self.walls
end

function walls:isTileWall(tile)
    for _, wall in pairs(self.walls) do
        if checkCollision(wall, tile) == true then
            return true
        end
    end
    return false
end