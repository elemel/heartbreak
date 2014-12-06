local BallModel = {}
BallModel.__index = BallModel

function BallModel.new(game, id, config)
    local model = {}
    setmetatable(model, BallModel)

    model._game = game
    model._id = id
    model._config = config or {}

    return model
end

function BallModel:getType()
    return "ball"
end

function BallModel:getId()
    return self._id
end

function BallModel:getConfig()
    return self._config
end

function BallModel:create()
    local config = self._config

    local world = self._game:getWorld()
    local x, y = unpack(config.position or {0, 0})
    self._body = love.physics.newBody(world, x, y, "dynamic")
    self._body:setLinearVelocity(unpack(config.linearVelocity or {0, 0}))
    self._body:setFixedRotation(true)

    local radius = config.radius or 1
    local shape = love.physics.newCircleShape(0, 0, radius)
    self._fixture = love.physics.newFixture(self._body, shape)
    self._fixture:setFriction(config.friction or 0)
    self._fixture:setRestitution(config.restitution or 1)
end

function BallModel:destroy()
    self._fixture:destroy()
    self._body:destroy()
end

function BallModel:update(dt)
end

return BallModel
