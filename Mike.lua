Mike = Entity:new()

function Mike:load()
    local spawnTileX, spawnTileY = 10, 11
    local spawnPixelX, spawnPixelY = gameMap:convertTileToPixel(spawnTileX, spawnTileY)
    local tileWidth, tileHeight = gameMap:getTileDimensions()
    self.radius = 14
    self.diameter = 2 * self.radius
    self.x = spawnPixelX + self.radius + tileWidth 
    self.y = spawnPixelY + self.radius / 2 + tileHeight
    self.speed = 90
    self.collider = world:newCircleCollider(self.x, self.y, self.radius)
    self.collider:setFixedRotation(true)
    self.currentDirection = "up"
    self.wantDirection = self.currentDirection 
end

function Mike:update(dt)
    self:checkBoundaries()
    self:updateCollider()
    self:move()
    self:turnWantDirection()
    self:center()
end

function Mike:turnDirections(key)
    local vx = 0
    local vy = 0
    if key == "w" then
        self.wantDirection = "up"
        if self:isClosestTileWall(self.wantDirection) == false then
            self.currentDirection = self.wantDirection
        end
    elseif key == "a" then
        self.wantDirection = "left"
        if self:isClosestTileWall(self.wantDirection) == false then
            self.currentDirection = self.wantDirection
        end
    elseif key == "s" then
        self.wantDirection = "down"
        if self:isClosestTileWall(self.wantDirection) == false then
            self.currentDirection = self.wantDirection
        end
    elseif key == "d" then
        self.wantDirection = "right"
        if self:isClosestTileWall(self.wantDirection) == false then
            self.currentDirection = self.wantDirection
        end
    end 
end

function Mike:draw()
    love.graphics.circle("line", self.x, self.y, self.radius)
    if self.currentClosestTile then -- debugging
        love.graphics.rectangle("line", self.currentClosestTile.x, self.currentClosestTile.y, self.currentClosestTile.width, self.currentClosestTile.height)
    end
end