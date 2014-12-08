local math1D = require "heart.math1D"

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
    local force = self._config.force or 1
    local torque = self._config.torque or 1
    local density = self._config.density or 1
    local x, y = unpack(config.position or {0, 0})
    local radius = config.radius or 1
    local friction = config.friction or 0
    local restitution = config.restitution or 1

    self._linearVelocity = {0, 0}

    self._body = love.physics.newBody(world, x, y, "static")

    local shape = love.physics.newCircleShape(radius)
    self._fixture = love.physics.newFixture(self._body, shape, density)
    self._fixture:setFriction(friction)
    self._fixture:setRestitution(restitution)
    self._fixture:setCategory(5)
    self._fixture:setUserData({model = self})
end

function PaddleModel:destroy()
    self._fixture:destroy()
    self._body:destroy()
end

function PaddleModel:update(dt)
    local config = self._config
    local linearAcceleration = config.linearAcceleration or 1
    local maxLinearVelocity = config.maxLinearVelocity or 1
    local x1, y1, x2, y2 = unpack(config.positionBounds or {-1, -1, 1, 1})

    local upInput = love.keyboard.isDown("up")
    local leftInput = love.keyboard.isDown("left")
    local downInput = love.keyboard.isDown("down")
    local rightInput = love.keyboard.isDown("right")

    local inputX = (rightInput and 1 or 0) - (leftInput and 1 or 0)
    local inputY = (upInput and 1 or 0) - (downInput and 1 or 0)

    local x, y = self._body:getPosition()
    local dx, dy = unpack(self._linearVelocity)

    if inputX ~= 0 then
        dx = dx + inputX * linearAcceleration * dt
        dx = math1D.sign(dx) * math.min(math.abs(dx), maxLinearVelocity)
    else
        dx = math1D.sign(dx) * math.max(math.abs(dx) - linearAcceleration * dt, 0)
    end

    x = x + dx * dt
    y = y + dy * dt

    if x < x1 then
        x = x1
        dx = math.max(dx, 0)
    end
    if x > x2 then
        x = x2
        dx = math.min(dx, 0)
    end
    if y < y1 then
        y = y1
        dy = math.max(dy, 0)
    end
    if y > y2 then
        y = y2
        dy = math.min(dy, 0)
    end

    self._body:setPosition(x, y)
    self._body:setLinearVelocity(dx, dy)
    self._linearVelocity = {dx, dy}
end

function PaddleModel:getBody()
    return self._body
end

return PaddleModel
