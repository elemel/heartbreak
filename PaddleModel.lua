local PaddleModel = {}
PaddleModel.__index = PaddleModel

function PaddleModel.new(game, id, config)
    local model = {}
    setmetatable(model, PaddleModel)

    model._game = game
    model._id = id
    model._config = config or {}
    model._position = config.position or {0, 0}

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

function PaddleModel:getSize()
    return unpack(self._config.size or {1, 1})
end

function PaddleModel:create()
    local config = self._config
    local world = self._game:getWorld()
    local width, height = unpack(config.size or {1, 1})
    local x1, y1, x2, y2 = unpack(config.line or {-1, 0, 1, 0})

    self._body = love.physics.newBody(world, 0.5 * (x1 + x2), 0.5 * (y1 + y2), "static")

    local shape = love.physics.newRectangleShape(x2 - x1, height)
    self._fixture = love.physics.newFixture(self._body, shape, density)
    self._fixture:setSensor(true)
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
        local x1, y1, x2, y2 = unpack(config.line or {-1, 0, 1, 0})

        local mouseX, mouseY = heart.mouse.readPosition()
        local transformation = self._game:getCamera():getInverseTransformation()
        local x, y = unpack(self._position)
        local dx, dy = transformation:transformVector(mouseX, mouseY)
        local width, height = unpack(self._config.size or {1, 1})
        x = heart.math.clamp(x + dx, x1 + 0.5 * width, x2 - 0.5 * width)
        y = heart.math.clamp(y + dy, y1, y2)
        self._position = {x, y}
    end
end

function PaddleModel:getBody()
    return self._body
end

return PaddleModel
