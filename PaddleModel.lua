local PaddleModel = {}
PaddleModel.__index = PaddleModel

function PaddleModel.new(game, id, config)
    local model = {}
    setmetatable(model, PaddleModel)

    model._game = game
    model._id = id
    model._config = config or {}
    model._position = config.position or {0, 0}
    model._size = config.size or {1, 1}
    model._line = config.line or {-1, 0, 1, 0}

    return model
end

function PaddleModel:getType()
    return "paddle"
end

function PaddleModel:getId()
    return self._id
end

function PaddleModel:getConfig()
    return self._config
end

function PaddleModel:getPosition()
    return unpack(self._position)
end

function PaddleModel:setPosition(x, y)
    self._position = {x, y}
    self._brickBody:setPosition(x, y)
end

function PaddleModel:getSize()
    return unpack(self._size)
end

function PaddleModel:getLine()
    return unpack(self._line)
end

function PaddleModel:create()
    local config = self._config
    local world = self._game:getWorld()
    local width, height = self:getSize()
    local x1, y1, x2, y2 = self:getLine()

    self._body = love.physics.newBody(world, 0.5 * (x1 + x2), 0.5 * (y1 + y2), "static")

    local shape = love.physics.newRectangleShape(x2 - x1, height)
    self._fixture = love.physics.newFixture(self._body, shape)
    self._fixture:setSensor(true)
    self._fixture:setCategory(5)
    self._fixture:setUserData({model = self})

    self._brickBody = love.physics.newBody(world, 0.5 * (x1 + x2), 0.5 * (y1 + y2), "static")

    local brickShape = love.physics.newRectangleShape(width, height)
    self._brickFixture = love.physics.newFixture(self._brickBody, brickShape)
    self._brickFixture:setCategory(6)
    self._brickFixture:setUserData({model = self})
end

function PaddleModel:destroy()
    self._fixture:destroy()
    self._body:destroy()
end

function PaddleModel:update(dt)
end

function PaddleModel:getBody()
    return self._body
end

return PaddleModel
