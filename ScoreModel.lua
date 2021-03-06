local ScoreModel = {}
ScoreModel.__index = ScoreModel

function ScoreModel.new(game, id, config)
    local model = {}
    setmetatable(model, ScoreModel)

    model._game = game
    model._id = id
    model._config = config or {}

    return model
end

function ScoreModel:getType()
    return "score"
end

function ScoreModel:getId()
    return self._id
end

function ScoreModel:getConfig()
    return self._config
end

function ScoreModel:create()
    self._level = 0
    self._score = 0
    self._nextExtraBallScore = 50
end

function ScoreModel:destroy()
end

function ScoreModel:update(dt)
    if self._score >= self._nextExtraBallScore then
        self:_createBall()
        self._nextExtraBallScore = self._nextExtraBallScore + 50
    end

    local wallCount = #self._game:getModelsByType("wall")
    if wallCount == 1 then
        local ballCount = #self._game:getModelsByType("ball")
        self:_destroyBalls()
        self._level = self._level + 1
        self:_createBricks()
        for i = 1, math.max(ballCount, 2) do
            self:_createBall()
        end
        return
    end

    local ballCount = #self._game:getModelsByType("ball")
    if ballCount == 0 then
        self:_destroyBricks()
        self._level = 1
        self._score = 0
        self._nextExtraBallScore = 50
        self:_createBricks()
        self:_createBall()
        self:_createBall()
        return
    end
end

function ScoreModel:getScore()
    return self._score
end

function ScoreModel:setScore(score)
    self._score = score
end

function ScoreModel:getLevel()
    return self._level
end

function ScoreModel:_createBall()
    local linearVelocity = 10 + self._level
    self._game:newModel("ball", {
        position = {15 * love.math.random() - 7.5, -10.5},
        angle = 2 * math.pi * love.math.random(),
        linearVelocity = {1 - 2 * love.math.random(), 1},
        angularDamping = 1,
        minLinearVelocity = linearVelocity,
        maxLinearVelocity = linearVelocity,
        minLinearVelocityX = 2,
        minLinearVelocityY = 2,
        radius = 0.5,
        friction = 1,
    })
end

function ScoreModel:_destroyBalls()
    for i, ballModel in pairs(self._game:getModelsByType("ball")) do
        self._game:removeModel(ballModel)
    end
end

function ScoreModel:_createBricks()
    local z = 1000 * love.math.random()
    local frequency = 0.2
    local positions = {}
    for y = 0, 7 do
        for x = -8, 7, 2 do
            if heart.math.fbm3(frequency * x, frequency * y, z) > 0.5 then
                table.insert(positions, {x, y})
            end
        end
    end
    heart.math.shuffle(positions)
    for i, position in ipairs(positions) do
        local x, y = unpack(position)
        local angle = (love.math.random() < 0.5 and -1 or 1) * (0.01 + 0.09 * love.math.random())
        game:newModel("wall", {
            position = {x + 1, y + 0.5},
            origin = {x + 1, y + 0.5},
            blocks = {
                [{x, y}] = "metal",
                [{x + 1, y}] = "metal",
            },
            angle = angle,
            friction = 1,
            restitution = 0.5,
            breakable = true,
        })
    end
end

function ScoreModel:_destroyBricks()
    for i, wallModel in pairs(self._game:getModelsByType("wall")) do
        if wallModel:isBreakable() then
            self._game:removeModel(wallModel)
        end
    end
end

return ScoreModel
