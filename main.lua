local BallModel = require "BallModel"
local BrickModel = require "BrickModel"
local Game = require "heart.Game"
local math3D = require "heart.math3D"
local PaddleModel = require "PaddleModel"
local WallModel = require "WallModel"

function love.load()
    love.physics.setMeter(1)

    love.window.setMode(800, 600, {
        resizable = true,
    })

    game = Game.new({
        cameraScale = 0.1,
        gravity = {0, -10},
    })
    game:setWorldViewEnabled(true)

    game:setModelCreator("ball", BallModel.new)
    game:setModelCreator("brick", BrickModel.new)
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

    local z = 1000 * love.math.random()
    local frequency = 0.2
    for y = 0, 8 do
        for x = -9, 8 do
            if math3D.fbm(frequency * x, frequency * y, z) > 0.5 then
                game:newModel("brick", {
                    position = {x + 0.5, y + 0.5},
                    restitution = 0.75,
                })
            end
        end
    end

    game:newModel("paddle", {
        radius = 1.5,
        position = {0, -10},
        linearAcceleration = 50,
        maxLinearVelocity = 20,
        positionBounds = {-9, 0, 9, 0},
        restitution = 0.75,
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
