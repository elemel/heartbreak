local math_ = require "heart.math"

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
    self._level = 1
    self._score = 0
    self._nextExtraBallScore = 20
end

function ScoreModel:destroy()
end

function ScoreModel:update(dt)
    if self._score >= self._nextExtraBallScore then
        self:_createBall()
        self._nextExtraBallScore = self._nextExtraBallScore + 20
    end

    local brickCount = #self._game:getModelsByType("brick")
    if brickCount == 0 then
        local ballCount = #self._game:getModelsByType("ball")
        self:_destroyBalls()
        self._level = self._level + 1
        self:_createBricks()
        for i = 1, math.max(ballCount, 1) do
            self:_createBall()
        end
        return
    end

    local ballCount = #self._game:getModelsByType("ball")
    if ballCount == 0 then
        self:_destroyBricks()
        self._level = 1
        self._score = 0
        self._nextExtraBallScore = 20
        self:_createBricks()
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
    local linearVelocity = 10 + 2 * (self._level - 1)
    self._game:newModel("ball", {
        position = {15 * love.math.random() - 7.5, -10.5},
        linearVelocity = {1 - 2 * love.math.random(), 1},
        minLinearVelocity = linearVelocity,
        maxLinearVelocity = linearVelocity,
        minLinearVelocityX = 2,
        minLinearVelocityY = 2,
        radius = 0.5,
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
    for y = 0, 7 do
        for x = -8, 7, 2 do
            if math_.fbm3(frequency * (x + 1), frequency * (y + 0.5), z) > 0.5 then
                game:newModel("brick", {
                    size = {2, 1},
                    position = {x + 1, y + 0.5},
                    restitution = 0.5,
                })
            end
        end
    end
end

function ScoreModel:_destroyBricks()
    for i, brickModel in pairs(self._game:getModelsByType("brick")) do
        self._game:removeModel(brickModel)
    end
end

return ScoreModel
