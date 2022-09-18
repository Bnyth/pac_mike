walls = {}

function walls:load()
    self.walls = {}
    if gameMap.layers["Walls"] then
        for i, object in pairs(gameMap.layers["Walls"].objects) do
            local wall = world:newRectangleCollider(object.x, object.y, object.width, object.height)
            wall:setType('static')
            table.insert(self.walls, wall)
        end
    end
end