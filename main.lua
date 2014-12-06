local BallModel = require "BallModel"
local Game = require "heart.Game"
local WallModel = require "WallModel"

function love.load()
    game = Game.new({
        cameraScale = 0.1,
    })
    game:setWorldViewEnabled(true)

    game:setModelCreator("ball", BallModel.new)
    game:setModelCreator("wall", WallModel.new)

    game:newModel("ball", {radius = 0.5})

    game:newModel("wall", {
        size = {20, 1},
        position = {0, 10},
    })
    game:newModel("wall", {
        size = {1, 20},
        position = {-10, 0},
    })
    game:newModel("wall", {
        size = {1, 20},
        position = {10, 0},
    })
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end
