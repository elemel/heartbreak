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
    local density = self._config.density or 1

    self._groundBody = love.physics.newBody(world, 0, 0, "static")

    local x, y = unpack(config.position or {0, 0})
    self._body = love.physics.newBody(world, x, y, "dynamic")

    local width, height = unpack(config.size or {1, 1})
    local shape = love.physics.newRectangleShape(width, height)
    self._fixture = love.physics.newFixture(self._body, shape, density)
    self._fixture:setFriction(config.friction or 0)
    self._fixture:setRestitution(config.restitution or 1)

    self._joint = love.physics.newPrismaticJoint(self._groundBody, self._body, x, y, 1, 0)
    self._joint:setMotorEnabled(true)
    self._joint:setMaxMotorForce(force)
    self._joint:setLimitsEnabled(false)
end

function PaddleModel:destroy()
    self._joint:destroy()
    self._fixture:destroy()
    self._body:destroy()
    self._groundBody:destroy()
end

function PaddleModel:update(dt)
    local speed = self._config.speed or 1

    local leftDown = love.keyboard.isDown("left")
    local rightDown = love.keyboard.isDown("right")
    local inputX = (rightDown and 1 or 0) - (leftDown and 1 or 0)
    self._joint:setMotorSpeed(inputX * speed)
end

return PaddleModel
