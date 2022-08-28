Mike = {}

function Mike:load()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.width = 20
    self.height = 20
    self.speed = 200
end

function Mike:update(dt)
    self:move(dt)
    self:checkBoundaries()
end

function Mike:move(dt)
    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
    elseif love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
    elseif love.keyboard.isDown("d") then 
        self.x = self.x + self.speed * dt
    end
end

function Mike:checkBoundaries()
    if self.y =< -self.height then -- eu q fiz assinado por rora
        self.y = love.graphics.getHeight()
    elseif self.x =< -self.width then
        self.x = love.graphics.getWidth()
    elseif self.y >= love.graphics.getHeight() then
        self.y = 0 
    elseif self.x >= love.graphics.getWidth() then
        self.x = 0     -- foi _b valeu
    end
end

function Mike:draw()
    love.graphics.rectangle("line", self.x, self.y, self.height, self.width)
end