local BrickModel = {}
BrickModel.__index = BrickModel

function BrickModel.new(game, id, config)
    local model = {}
    setmetatable(model, BrickModel)

    model._game = game
    model._id = id
    model._config = config or {}
    model._size = config.size or {1, 1}

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

function BrickModel:getSize()
    return unpack(self._size)
end

function BrickModel:create()
    local config = self._config

    self._falling = false
    self._broken = false

    local world = self._game:getWorld()
    local x, y = unpack(config.position or {0, 0})
    local bodyType = config.bodyType or "static"
    self._body = love.physics.newBody(world, x, y, bodyType)
    self._body:setAngle(config.angle or 0)
    self._body:setLinearVelocity(unpack(config.linearVelocity or {0, 0}))
    self._body:setAngularVelocity(config.angularVelocity or 0)

    local width, height = unpack(config.size or {1, 1})
    local shape = love.physics.newRectangleShape(width, height)
    self._fixture = love.physics.newFixture(self._body, shape)
    self._fixture:setFriction(config.friction or 0)
    self._fixture:setRestitution(config.restitution or 1)
    self._fixture:setCategory(3)
    if bodyType == "dynamic" then
        if width > 1.5 or height > 1.5 then
            self._fixture:setMask(2, 3, 4, 5)
        else
            self._fixture:setMask(2, 3, 4, 5, 6)
        end
    else
        self._fixture:setMask(2, 3)
    end
    self._fixture:setUserData({model = self})
end

function BrickModel:destroy()
    self._fixture:destroy()
    self._body:destroy()
end

function BrickModel:update(dt)
    local x, y = self._body:getPosition()
    if y < -11.5 then
        self:_addScore(1)
        self._game:removeModel(self)
        self._game:playSound("score")
        return
    end

    if self._broken then
        local width, height = unpack(self._config.size or {1, 1})
        if width > 1.5 or height > 1.5 then
            if width > height then
                self._game:newModel("brick", {
                    bodyType = "dynamic",
                    size = {0.5 * width, height},
                    position = {self._body:getWorldPoint(-0.25 * width, 0)},
                    angle = self._body:getAngle(),
                    linearVelocity = {self._body:getLinearVelocityFromLocalPoint(-0.25 * width, 0)},
                    angularVelocity = self._body:getAngularVelocity() + 0.5 * (1 - 2 * love.math.random()),
                })
                self._game:newModel("brick", {
                    bodyType = "dynamic",
                    size = {0.5 * width, height},
                    position = {self._body:getWorldPoint(0.25 * width, 0)},
                    angle = self._body:getAngle(),
                    linearVelocity = {self._body:getLinearVelocityFromLocalPoint(0.25 * width, 0)},
                    angularVelocity = self._body:getAngularVelocity() + 0.5 * (1 - 2 * love.math.random()),
                })
            else
                self._game:newModel("brick", {
                    bodyType = "dynamic",
                    size = {width, 0.5 * height},
                    position = {self._body:getWorldPoint(0, -0.25 * height)},
                    angle = self._body:getAngle(),
                    linearVelocity = {self._body:getLinearVelocityFromLocalPoint(0, -0.25 * height)},
                    angularVelocity = self._body:getAngularVelocity() + 0.5 * (1 - 2 * love.math.random()),
                })
                self._game:newModel("brick", {
                    bodyType = "dynamic",
                    size = {width, 0.5 * height},
                    position = {self._body:getWorldPoint(0, 0.25 * height)},
                    angle = self._body:getAngle(),
                    linearVelocity = {self._body:getLinearVelocityFromLocalPoint(0, 0.25 * height)},
                    angularVelocity = self._body:getAngularVelocity() + 0.5 * (1 - 2 * love.math.random()),
                })
            end
            self:_addScore(1)
            self._game:removeModel(self)
            self._game:playSound("break")
            return
        end
    end

    if self._falling and self._body:getType() == "static" then
        self._body:setType("dynamic")
        self._body:setAngularVelocity(0.5 * (1 - 2 * love.math.random()))
        local width, height = unpack(self._config.size or {1, 1})
        if width > 1.5 or height > 1.5 then
            self._fixture:setMask(2, 3, 4, 5)
        else
            self._fixture:setMask(2, 3, 4, 5, 6)
        end
        self:_addScore(1)
        self._game:playSound("hit")
    end
end

function BrickModel:beginContact(fixture1, fixture2, contact, reversed)
    if fixture2:getCategory() == 4 then
        self._falling = true
    end
    if fixture2:getCategory() == 6 then
        self._broken = true
    end
end

function BrickModel:_addScore(score)
    local scoreModel = self._game:getModelByType("score")
    if scoreModel then
        scoreModel:setScore(scoreModel:getScore() + score)
    end
end

function BrickModel:getBody()
    return self._body
end

return BrickModel
