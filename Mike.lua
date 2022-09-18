Mike = {}

function Mike:load()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.width = 20
    self.height = 20
    self.speed = 200
    self.collider = world:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setFixedRotation(true)
end

function Mike:update(dt)
    self:move(dt)
    self:checkBoundaries()
    self:updateCollider()
end

function Mike:move(dt)
    local vx = 0
    local vy = 0
    if love.keyboard.isDown("w") then
        vy = -self.speed
    end

    if love.keyboard.isDown("a") then
        vx = -self.speed
    end

    if love.keyboard.isDown("s") then
        vy = self.speed
    end

    if love.keyboard.isDown("d") then 
        vx = self.speed
    end

    self.collider:setLinearVelocity(vx, vy)
end

function Mike:updateCollider()
    self.x = self.collider:getX() - self.width / 2
    self.y = self.collider:getY() - self.height / 2
end

function Mike:checkBoundaries()
    if self.y <= -self.height then -- eu q fiz assinado por rora
        self.collider:setY(love.graphics.getHeight())
    elseif self.x <= -self.width then
        self.collider:setX(love.graphics.getWidth())
    elseif self.y >= love.graphics.getHeight() then
        self.collider:setY(0)
    elseif self.x >= love.graphics.getWidth() then
        self.collider:setX(0)
    end
end

function Mike:draw()
    love.graphics.rectangle("line", self.x, self.y, self.height, self.width)
end