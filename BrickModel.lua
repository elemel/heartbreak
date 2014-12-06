local BrickModel = {}
BrickModel.__index = BrickModel

function BrickModel.new(game, id, config)
    local model = {}
    setmetatable(model, BrickModel)

    model._game = game
    model._id = id
    model._config = config or {}

    return model
end

function BrickModel:getType()
    return "brick"
end

function BrickModel:getId()
    return self._id
end

function BrickModel:getConfig()
    return self._config
end

function BrickModel:create()
    local config = self._config

    self._broken = false

    local world = self._game:getWorld()
    local x, y = unpack(config.position or {0, 0})
    self._body = love.physics.newBody(world, x, y, "static")
    self._body:setLinearVelocity(unpack(config.linearVelocity or {0, 0}))

    local width, height = unpack(config.size or {1, 1})
    local shape = love.physics.newRectangleShape(width, height)
    self._fixture = love.physics.newFixture(self._body, shape)
    self._fixture:setFriction(config.friction or 0)
    self._fixture:setRestitution(config.restitution or 1)
    self._fixture:setCategory(3)
    self._fixture:setMask(3)
    self._fixture:setUserData({model = self})
end

function BrickModel:destroy()
    self._fixture:destroy()
    self._body:destroy()
end

function BrickModel:update(dt)
    if self._broken and self._body:getType() == "static" then
        self._body:setType("dynamic")
        self._fixture:setMask(3, 4)
    end

    local x, y = self._body:getPosition()
    if y < -10 then
        self._game:removeModel(self)
    end
end

function BrickModel:beginContact(fixture1, fixture2, contact, reversed)
    self._broken = true
end

return BrickModel
