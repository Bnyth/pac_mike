Entity = {}

function Entity:new()
    local newEntity = {}
    setmetatable(newEntity, self)
    self.__index = self
    return newEntity
end

function Entity:move()
    local vx, vy = 0, 0
    if self.currentDirection == "up" then
        vy = -self.speed
    elseif self.currentDirection == "left" then
        vx = -self.speed
    elseif self.currentDirection == "down" then
        vy = self.speed
    elseif self.currentDirection == "right" then
        vx = self.speed
    end

    self.collider:setLinearVelocity(vx, vy)
end

function Entity:updateCollider()
    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function Entity:checkBoundaries()
    if self.y < -self.diameter then -- eu q fiz assinado por rora
        self.collider:setY(love.graphics.getHeight() + self.radius)
    elseif self.x < -self.diameter then
        self.collider:setX(love.graphics.getWidth() + self.radius)
    elseif self.y > love.graphics.getHeight() + self.radius then
        self.collider:setY(-self.radius)
    elseif self.x > love.graphics.getWidth() + self.radius then
        self.collider:setX(-self.radius)
    end
end

function Entity:getPixelPosition()
    return self.x, self.y
end

function Entity:getCenteredPixelPosition()
    return self.x + self.radius, self.y + self.radius
end

function Entity:getTilePosition()
    local x, y = gameMap:convertPixelToTile(self:getCenteredPixelPosition())
    return math.floor(x), math.floor(y)
end

function Entity:getClosestTile(direction)
    local currentTileX, currentTileY = self:getTilePosition()
    local closestTileX, closestTileY = currentTileX, currentTileY
    local closestTile = {}

    if direction == "up" then
        closestTileY = currentTileY - 1
    elseif direction == "left" then
        closestTileX = currentTileX - 1
    elseif direction == "down" then
        closestTileY = currentTileY + 1
    elseif direction == "right" then
        closestTileX = currentTileX + 1
    end

    closestTile.x, closestTile.y = gameMap:convertTileToPixel(closestTileX, closestTileY)
    closestTile.width, closestTile.height = gameMap:getTileDimensions()
    self.currentClosestTile = closestTile
    return closestTile

end

function Entity:isInTileCenter()
    local currentTileX, currentTileY = gameMap:convertTileToPixel(self:getTilePosition())
    local currentTileWidth, currentTileHeight = gameMap:getTileDimensions()
    local entityCenterX = self.x + self.diameter / 2
    local entityCenterY = self.y + self.diameter / 2
    local tileCenterX = currentTileX + currentTileWidth
    local tileCenterY = currentTileY + currentTileHeight 
    local approximation = 1 / self.radius * 75 

    if approximatelyEquals(entityCenterX, tileCenterX, approximation) and 
       approximatelyEquals(entityCenterY, tileCenterY, approximation) then
        return true
    end -- boa tudo funcionando ate agr
    return false
end

function Entity:isClosestTileWall(direction)
    local closestTileWall = self:getClosestTile(direction)
    return walls:isTileWall(closestTileWall)
end

function Entity:center()
    if self:isClosestTileWall(self.currentDirection) == true and self:isInTileCenter() == true then
        self.currentDirection, self.wantDirection = nil, nil 
    end
end

function Entity:isAbleToTurn()
    if self:isInTileCenter() == true and walls:isTileWall(self:getClosestTile(self.wantDirection)) == false then
        return true
    end
    return false
end

function Entity:turnWantDirection() -- após finalizar, colocar função no update e testar
    if self.currentDirection ~= self.wantDirection and self:isAbleToTurn() == true then
        self.currentDirection = self.wantDirection -- n ta conseguindo abrir o chat?
    end
end