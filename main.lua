local BallModel = require "BallModel"
local Game = require "heart.Game"
local PaddleModel = require "PaddleModel"
local WallModel = require "WallModel"

function love.load()
    love.physics.setMeter(1)

    game = Game.new({
        cameraScale = 0.1,
    })
    game:setWorldViewEnabled(true)

    game:setModelCreator("ball", BallModel.new)
    game:setModelCreator("paddle", PaddleModel.new)
    game:setModelCreator("wall", WallModel.new)

    game:newModel("wall", {
        size = {20, 1},
        position = {0, 9.5},
    })
    game:newModel("wall", {
        size = {1, 20},
        position = {-9.5, 0},
    })
    game:newModel("wall", {
        size = {1, 20},
        position = {9.5, 0},
    })

    game:newModel("paddle", {
        size = {3, 1},
        position = {0, -8.5},
        force = 500,
        torque = 100,
        maxLinearVelocity = 10,
        maxAngularVelocity = 5,
    })

    game:newModel("ball", {
        linearVelocity = {5, 10},
        radius = 0.5,
    })
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end
