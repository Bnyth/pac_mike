Nemesis = {}

function Nemesis:load()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.width = 20
    self.height = 20
    self.speed = 90
    self.collider = world:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setFixedRotation(true)
end

function Nemesis:draw()
    love.graphics.rectangle("line", self.x, self.y, self.height, self.width)
end