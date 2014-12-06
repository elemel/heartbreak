local BallModel = require "BallModel"
local Game = require "heart.Game"

function love.load()
    game = Game.new()
    game:setWorldViewEnabled(true)

    game:setModelCreator("ball", BallModel.new)

    game:newModel("ball")
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end
