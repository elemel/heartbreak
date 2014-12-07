local math3D = require "heart.math3D"

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
end

function ScoreModel:destroy()
end

function ScoreModel:update(dt)
    local brickModels = self._game:getModelsByType("brick")
    if #brickModels == 0 then
        for i, ballModel in pairs(self._game:getModelsByType("ball")) do
            self._game:removeModel(ballModel)
        end

        local z = 1000 * love.math.random()
        local frequency = 0.2
        for y = 0, 7 do
            for x = -8, 7, 2 do
                if math3D.fbm(frequency * (x + 1), frequency * (y + 0.5), z) > 0.5 then
                    game:newModel("brick", {
                        size = {2, 1},
                        position = {x + 1, y + 0.5},
                        friction = 0.5,
                        restitution = 0.5,
                    })
                end
            end
        end
    end

    local ballModels = self._game:getModelsByType("ball")
    if #ballModels == 0 then
        self._game:newModel("ball", {
            position = {15 * love.math.random() - 7.5, -10.5},
            linearVelocity = {1 - 2 * love.math.random(), 1},
            minLinearVelocity = 10,
            maxLinearVelocity = 10,
            minLinearVelocityX = 2,
            minLinearVelocityY = 2,
            radius = 0.5,
            friction = 0.5,
            restitution = 0.5,
        })
    end
end

return ScoreModel
