local WallModel = {}
WallModel.__index = WallModel

function WallModel.new(game, id, config)
    local model = {}
    setmetatable(model, WallModel)

    model._game = game
    model._id = id
    model._config = config or {}
    model._blockTypes = {}
    model._blockVersion = 1
    model._blockFixtures = {}

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

function WallModel:create()
    local config = self._config

    local world = self._game:getWorld()
    local x0, y0 = unpack(config.position or {0, 0})
    self._body = love.physics.newBody(world, x0, y0, "static")

    for key, blockType in pairs(config.blocks or {}) do
        local x, y = unpack(key)
        self:setBlockType(x, y, blockType)
    end
end

function WallModel:destroy()
    for x, y, fixture in self._fixtures:iterate() do
        fixture:destroy()
    end
    self._body:destroy()
end

function WallModel:update(dt)
end

function WallModel:getBody()
    return self._body
end

function WallModel:_destroyBlockFixture(x, y)
    local fixture = self._blockFixtures[y] and self._blockFixtures[y][x]
    if fixture then
        fixture:destroy()
    end
end

function WallModel:_createBlockFixture(x, y)
    local config = self._config

    local shape = love.physics.newRectangleShape(x - 0.5, y - 0.5, 1, 1)
    local fixture = love.physics.newFixture(self._body, shape)
    fixture:setFriction(config.friction or 0)
    fixture:setRestitution(config.restitution or 1)
    fixture:setCategory(2)

    if not self._blockFixtures[y] then
        self._blockFixtures[y] = {}
    end
    self._blockFixtures[y][x] = fixture
end

return WallModel
