Nemesis = Entity:new()

function Nemesis:load()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.radius = 10
    self.diameter = self.radius * 2
    self.speed = 90
    self.collider = world:newCircleCollider(self.x, self.y, self.radius)
    self.collider:setFixedRotation(true)
    self.directions = {"up", "left", "down", "right"}
    self.currentDirection = "up"
    self.wantDirection = self.currentDirection
    self.changeDirectionTimer = 0
    self.changeDirectionDuration = math.random(1, 5) + math.random()
end

function Nemesis:changeDirectionRandomly(dt)
    self.changeDirectionTimer = self.changeDirectionTimer + dt
    if self.changeDirectionTimer >= self.changeDirectionDuration then
        self.wantDirection = self:getRandomDirection()
        self.changeDirectionTimer = 0
        self.changeDirectionDuration = math.random(1, 5) + math.random()
    end

end

function Nemesis:update(dt)
    self:updateCollider()
    self:checkBoundaries()
    self:move()
    self:turnWantDirection()
    self:center()
    self:changeDirectionRandomly(dt)
end

function Nemesis:getRandomDirection()
    local randomNumber
    local randomDirection = self.currentDirection
    while self.currentDirection == randomDirection or self:isClosestTileWall(randomDirection) do
        randomNumber = math.random(1,4)
        randomDirection = self.directions[randomNumber]
    end
    return randomDirection
end


function Nemesis:draw()
    love.graphics.circle("line", self.x, self.y, self.radius)
    if self.currentClosestTile then -- debugging
        love.graphics.rectangle("line", self.currentClosestTile.x, self.currentClosestTile.y, self.currentClosestTile.width, self.currentClosestTile.height)
    end
end

function Nemesis:setCurrentDirection(direction)
    self.currentDirection = direction
    self.changeDirectionTimer = 0
end

function Nemesis:center()
    if self:isClosestTileWall(self.currentDirection) == true and self:isInTileCenter() == true then
        self:setCurrentDirection(self:getRandomDirection())
    end
end