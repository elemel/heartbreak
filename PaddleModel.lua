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
    local width, height = unpack(config.size or {1, 1})
    local friction = config.friction or 0
    local restitution = config.restitution or 1

    self._linearVelocity = {0, 0}

    self._body = love.physics.newBody(world, x, y, "static")

    local shape = love.physics.newRectangleShape(width, height)
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
    if love.mouse.isGrabbed() then
        local config = self._config
        local x1, y1, x2, y2 = unpack(config.positionBounds or {-1, -1, 1, 1})

        local mouseX, mouseY = heart.mouse.readPosition()
        local transformation = self._game:getCamera():getInverseTransformation()
        local x, y = self._body:getPosition()
        local dx, dy = transformation:transformVector(mouseX, mouseY)
        x = heart.math.clamp(x + dx, x1, x2)
        y = heart.math.clamp(y + dy, y1, y2)
        self._body:setPosition(x, y)
    end
end

function PaddleModel:getBody()
    return self._body
end

return PaddleModel
