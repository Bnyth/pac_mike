Mike = {}

function Mike:load()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.radius = 14
    self.speed = 90
    self.diameter = 2 * self.radius
    self.collider = world:newCircleCollider(self.x, self.y, self.radius)
    self.collider:setFixedRotation(true)
    self.currentDirection = "up"
    self.wantDirection = self.currentDirection 
end

function Mike:update(dt)
    self:checkBoundaries()
    self:updateCollider()
    self:move()
    -- self:turnWantDirection()
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

function Mike:move()
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

function Mike:updateCollider()
    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function Mike:checkBoundaries()
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

function Mike:draw()
    love.graphics.circle("line", self.x, self.y, self.radius)
    if self.currentClosestTile then -- debugging
        love.graphics.rectangle("line", self.currentClosestTile.x, self.currentClosestTile.y, self.currentClosestTile.width, self.currentClosestTile.height)
    end
end

function Mike:getPixelPosition()
    return self.x, self.y
end

function Mike:getCenteredPixelPosition()
    return self.x + self.radius, self.y + self.radius
end

function Mike:getTilePosition()
    local x, y = gameMap:convertPixelToTile(self:getCenteredPixelPosition())
    return math.floor(x), math.floor(y)
end

function Mike:getClosestTile(direction)
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

function Mike:isClosestTileWall(direction)
    local closestTileWall = self:getClosestTile(direction)
    return walls:isTileWall(closestTileWall)
end

-- 1. pegar tile atual
-- 2. pegar centro x do mike: x + width / 2
-- 3. pegar  centro y do mike: y + height / 2
-- 4. pegar centro x da tile: x + width / 2
-- 5. pegar centro y da tile: y + height / 2
-- 6. retornar se centros x sao iguais e se centros y sao iguais
function Mike:isInTileCenter()
    local currentTileX, currentTileY = gameMap:convertTileToPixel(self:getTilePosition())
    local currentTileWidth, currentTileHeight = gameMap:getTileDimensions()
    local mikeCenterX = self.x + self.diameter / 2
    local mikeCenterY = self.y + self.diameter / 2
    local tileCenterX = currentTileX + currentTileWidth / 2
    local tileCenterY = currentTileY + currentTileHeight / 2
    local approximation = 5

    print("x: ", mikeCenterX, tileCenterX)
    print("y: ", mikeCenterY, tileCenterY)
    if approximatelyEquals(mikeCenterX, tileCenterX, approximation) and 
       approximatelyEquals(mikeCenterY, tileCenterY, approximation) then
        return true
    end -- boa tudo funcionando ate agr
    return false
end

function Mike:center()
    if self:isClosestTileWall(self.currentDirection) == true and self:isInTileCenter() == true then
        self.currentDirection, self.wantDirection = nil, nil 
    end
end

-- 1. verificar se mike está centralizado no tile (isInTileCenter)
-- 2. verificar se tile próxima a direção desejada não é uma parede
-- 3. retornar (1 && 2)
function Mike:isAbleToTurn()
    if self:isInTileCenter() == true and walls:isTileWall(self:getClosestTile(self.wantDirection)) == false then
        return true
    end
    return false
end

-- 1. verificar se direction é diferente de currentDirection
-- 2. verificar se mike está apto a virar
-- 3. caso (1 && 2) verdadeiro, virar
function Mike:turnWantDirection() -- após finalizar, colocar função no update e testar
    if self.currentDirection ~= self.wantDirection and self:isAbleToTurn() == true then
        self.currentDirection = self.wantDirection -- n ta conseguindo abrir o chat?
    end
end

-- data de entrega: 17/01, no MÁXIMO às 19:00!!!!!!!!!!
-- valendo 100 PONTOS. Boa sorte, meus alunos queridos! Amo vcs.
-- grupo zap da sala: https://web.whatsapp.com/groups/a279bfm290cd92dfkgn/

-- CRITÉRIO DE NOTA:  (média = 60)
-- rodou sem problemas = 100; 
-- rodou = 70 - 90 pontos; 
-- erro = 10 - 60 pontos;
-- nem tentou = 0 pontos;

-- caso sintam que vão reprovar, podem me chamar no zapzap, 
-- que a profa. Aurora dá uma atividade extra pra vcs...