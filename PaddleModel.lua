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
    local width, height = unpack(config.size or {1, 1})
    local radius = 0.5 * math.min(width, height)
    local friction = config.friction or 1
    local restitution = config.resititon or 1

    self._groundBody = love.physics.newBody(world, 0, 0, "static")

    self._prismaticBody = love.physics.newBody(world, x, y, "dynamic")

    local prismaticShape = love.physics.newCircleShape(radius)
    self._prismaticFixture = love.physics.newFixture(self._prismaticBody, prismaticShape, density)
    self._prismaticFixture:setFriction(friction)
    self._prismaticFixture:setRestitution(restitution)

    self._prismaticJoint = love.physics.newPrismaticJoint(self._groundBody, self._prismaticBody, x, y, 1, 0)
    self._prismaticJoint:setMotorEnabled(true)
    self._prismaticJoint:setMaxMotorForce(force)
    self._prismaticJoint:setLimitsEnabled(false)

    self._revoluteBody = love.physics.newBody(world, x, y, "dynamic")

    local revoluteShape = love.physics.newRectangleShape(width, height)
    self._revoluteFixture = love.physics.newFixture(self._revoluteBody, revoluteShape, density)
    self._revoluteFixture:setFriction(friction)
    self._revoluteFixture:setRestitution(restitution)
    self._revoluteFixture:setMask(2)

    self._revoluteJoint = love.physics.newRevoluteJoint(self._prismaticBody, self._revoluteBody, x, y)
    self._revoluteJoint:setMotorEnabled(true)
    self._revoluteJoint:setMaxMotorTorque(torque)
    self._prismaticJoint:setLimitsEnabled(false)
end

function PaddleModel:destroy()
    self._revoluteJoint:destroy()
    self._revoluteFixture:destroy()
    self._revoluteBody:destroy()

    self._prismaticJoint:destroy()
    self._prismaticFixture:destroy()
    self._prismaticBody:destroy()

    self._groundBody:destroy()
end

function PaddleModel:update(dt)
    local maxLinearVelocity = self._config.maxLinearVelocity or 1
    local maxAngularVelocity = self._config.maxAngularVelocity or 1

    local upInput = love.keyboard.isDown("up")
    local leftInput = love.keyboard.isDown("left")
    local downInput = love.keyboard.isDown("down")
    local rightInput = love.keyboard.isDown("right")

    local inputX = (rightInput and 1 or 0) - (leftInput and 1 or 0)
    local inputY = (upInput and 1 or 0) - (downInput and 1 or 0)

    self._prismaticJoint:setMotorSpeed(inputX * maxLinearVelocity)
    self._revoluteJoint:setMotorSpeed(inputY * maxAngularVelocity)
end

return PaddleModel
