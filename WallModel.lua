local WallModel = {}
WallModel.__index = WallModel

function WallModel.new(game, id, config)
    local model = {}
    setmetatable(model, WallModel)

    model._game = game
    model._id = id
    model._config = config or {}

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

function WallModel:create()
    local config = self._config

    local world = self._game:getWorld()
    local x, y = unpack(config.position or {0, 0})
    self._body = love.physics.newBody(world, x, y, "static")

    local width, height = unpack(config.size or {1, 1})
    local shape = love.physics.newRectangleShape(width, height)
    self._fixture = love.physics.newFixture(self._body, shape)
    self._fixture:setFriction(config.friction or 0)
    self._fixture:setRestitution(config.restitution or 1)
end

function WallModel:destroy()
    self._fixture:destroy()
    self._body:destroy()
end

function WallModel:update(dt)
end

return WallModel
