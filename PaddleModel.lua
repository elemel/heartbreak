local PaddleModel = {}
PaddleModel.__index = PaddleModel

function PaddleModel.new(game, id, config)
    local model = {}
    setmetatable(model, PaddleModel)

    model._game = game
    model._id = id
    model._config = config or {}

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

function PaddleModel:create()
    local config = self._config
    local world = self._game:getWorld()

    self._groundBody = love.physics.newBody(world, 0, 0, "static")

    local x, y = unpack(config.position or {0, 0})
    self._body = love.physics.newBody(world, x, y, "dynamic")

    local width, height = unpack(config.size or {1, 1})
    local shape = love.physics.newRectangleShape(width, height)
    self._fixture = love.physics.newFixture(self._body, shape)
end

function PaddleModel:destroy()
    self._fixture:destroy()
    self._body:destroy()
    self._groundBody:destroy()
end

function PaddleModel:update(dt)
end

return PaddleModel
