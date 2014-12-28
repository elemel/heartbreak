local WallModel = {}
WallModel.__index = WallModel

function WallModel.new(game, id, config)
    local model = {}
    setmetatable(model, WallModel)

    config = config or {}

    model._game = game
    model._id = id
    model._config = config
    model._blockTypes = {}
    model._blockVersion = 1
    model._blockFixtures = {}
    model._breakable = config.breakable or false
    model._falling = config.falling or false
    model._broken = config.broken or false
    model._origin = config.origin or {0, 0}

    return model
end

function WallModel:getType()
    return "wall"
end

function WallModel:getId()
    return self._id
end

function WallModel:getConfig()
    return self._config
end

function WallModel:getOrigin()
    return unpack(self._origin)
end

function WallModel:isBreakable()
    return self._breakable
end

function WallModel:isFalling()
    return self._falling
end

function WallModel:setFalling(falling)
    self._falling = falling
end

function WallModel:isBroken()
    return self._broken
end

function WallModel:setBroken(broken)
    self._broken = broken
end

function WallModel:getBlockType(x, y)
    return self._blockTypes[y] and self._blockTypes[y][x]
end

function WallModel:setBlockType(x, y, blockType)
    local oldBlockType = self._blockTypes[y] and self._blockTypes[y][x]
    if blockType ~= oldBlockType then
        self:_destroyBlockFixture(x, y)

        if not self._blockTypes[y] then
            self._blockTypes[y] = {}
        end
        self._blockTypes[y][x] = blockType
        self._blockVersion = self._blockVersion + 1

        if blockType then
            self:_createBlockFixture(x, y)
        end
    end
end

function WallModel:getBlockTypes()
    return self._blockTypes
end

function WallModel:getBlockVersion()
    return self._blockVersion
end

function WallModel:getBlockCount()
    local count = 0
    for y, row in pairs(self._blockTypes) do
        for x, fixture in pairs(row) do
            count = count + 1
        end
    end
    return count
end

function WallModel:create()
    local config = self._config

    local world = self._game:getWorld()
    local x0, y0 = unpack(config.position or {0, 0})
    local bodyType = config.falling and "dynamic" or "static"
    self._body = love.physics.newBody(world, x0, y0, bodyType)
    self._body:setAngle(config.angle or 0)
    self._body:setLinearVelocity(unpack(config.linearVelocity or {0, 0}))
    self._body:setAngularVelocity(config.angularVelocity or 0)

    for key, blockType in pairs(config.blocks or {}) do
        local x, y = unpack(key)
        self:setBlockType(x, y, blockType)
    end

    if bodyType == "dynamic" then
        local blockCount = self:getBlockCount()
        for y, row in pairs(self._blockFixtures) do
            for x, fixture in pairs(row) do
                if blockCount == 1 then
                    fixture:setMask(2, 4, 6)
                else
                    fixture:setMask(2, 4)
                end
            end
        end
    end
end

function WallModel:destroy()
    for y, row in pairs(self._blockFixtures) do
        for x, fixture in pairs(row) do
            fixture:destroy()
        end
    end
    self._body:destroy()
end

function WallModel:update(dt)
    if self._broken and self:getBlockCount() >= 2 then
        self:split()
        return
    end

    local x, y = self._body:getPosition()
    if y < -11.5 then
        self:_addScore(self:getBlockCount())
        self._game:removeModel(self)
        self._game:playSound("score")
        return
    end

    if self._falling and self._body:getType() ~= "dynamic" then
        local angularVelocity = (love.math.random() < 0.5 and -1 or 1) * (0.1 + 0.9 * love.math.random())
        self._body:setType("dynamic")
        self._body:setAngularVelocity(angularVelocity)

        local blockCount = self:getBlockCount()
        for y, row in pairs(self._blockFixtures) do
            for x, fixture in pairs(row) do
                if blockCount == 1 then
                    fixture:setMask(2, 4, 6)
                else
                    fixture:setMask(2, 4)
                end
            end
        end
    end
end

function WallModel:getBody()
    return self._body
end

function WallModel:split()
    local x, y = self._body:getPosition()
    local angle = self._body:getAngle()
    local angularVelocity = self._body:getAngularVelocity()
    local x0, y0 = unpack(self._origin)

    for gridY, row in pairs(self._blockFixtures) do
        for gridX, fixture in pairs(row) do
            local blockX, blockY = x, y
            local dx, dy = self._body:getLinearVelocityFromWorldPoint(blockX, blockY)
            self._game:newModel("wall", {
                position = {blockX, blockY},
                angle = angle,
                linearVelocity = {dx, dy},
                angularVelocity = angularVelocity,
                origin = self._origin,
                breakable = true,
                falling = true,
                blocks = {
                    [{gridX, gridY}] = "metal",
                },
                friction = fixture:getFriction(),
                restitution = fixture:getRestitution(),
            })
        end
    end

    self._game:removeModel(self)
end

function WallModel:_destroyBlockFixture(x, y)
    local fixture = self._blockFixtures[y] and self._blockFixtures[y][x]
    if fixture then
        fixture:destroy()
    end
end

function WallModel:_createBlockFixture(x, y)
    local config = self._config

    local x0, y0 = unpack(self._origin)
    local shape = love.physics.newRectangleShape(x + 0.5 - x0, y + 0.5 - y0, 1, 1)
    local fixture = love.physics.newFixture(self._body, shape)
    fixture:setFriction(config.friction or 0)
    fixture:setRestitution(config.restitution or 1)
    fixture:setCategory(2)
    fixture:setUserData({
        model = self,
    })

    if not self._blockFixtures[y] then
        self._blockFixtures[y] = {}
    end
    self._blockFixtures[y][x] = fixture
end

function WallModel:_addScore(score)
    local scoreModel = self._game:getModelByType("score")
    if scoreModel then
        scoreModel:setScore(scoreModel:getScore() + score)
    end
end

return WallModel
