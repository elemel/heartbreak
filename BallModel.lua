local math1D = require "heart.math1D"
local math2D = require "heart.math2D"

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

    self._spawning = true

    local world = self._game:getWorld()
    local x, y = unpack(config.position or {0, 0})
    self._body = love.physics.newBody(world, x, y, "dynamic")
    self._body:setLinearVelocity(unpack(config.linearVelocity or {0, 0}))
    self._body:setGravityScale(0)

    local radius = config.radius or 1
    local shape = love.physics.newCircleShape(0, 0, radius)
    self._fixture = love.physics.newFixture(self._body, shape)
    self._fixture:setFriction(config.friction or 0)
    self._fixture:setRestitution(config.restitution or 1)
    self._fixture:setCategory(4)
    self._fixture:setMask(5)
    self._fixture:setUserData({model = self})
end

function BallModel:destroy()
    self._fixture:destroy()
    self._body:destroy()
end

function BallModel:update(dt)
    local minLinearVelocity = self._config.minLinearVelocity or 0
    local maxLinearVelocity = self._config.maxLinearVelocity or 1
    local minLinearVelocityX = self._config.minLinearVelocityX or 0
    local minLinearVelocityY = self._config.minLinearVelocityY or 0

    local x, y = self._body:getPosition()
    local dx, dy = self._body:getLinearVelocity()

    if self._spawning and y > -7.5 then
        self._fixture:setMask()

        self._spawning = false
    end

    if y < -10.5 and not self._spawning then
        x, y = 15 * love.math.random() - 7.5, -10.5
        dx, dy = 1 - 2 * love.math.random(), 1
        self._body:setAngle(2 * math.pi * love.math.random())
        self._body:setAngularVelocity(0)
        self._fixture:setMask(5)

        self._spawning = true
    end

    local directionX, directionY, length = math2D.normalize(dx, dy)
    length = math1D.clamp(length, minLinearVelocity, maxLinearVelocity)
    dx, dy = directionX * length, directionY * length

    dx = math1D.sign(dx) * math.max(math.abs(dx), minLinearVelocityX)
    dy = math1D.sign(dy) * math.max(math.abs(dy), minLinearVelocityY)

    self._body:setPosition(x, y)
    self._body:setLinearVelocity(dx, dy)
end

return BallModel
