local BallModel = require "BallModel"
local BrickModel = require "BrickModel"
local Game = require "heart.Game"
local math3D = require "heart.math3D"
local PaddleModel = require "PaddleModel"
local ScoreModel = require "ScoreModel"
local WallModel = require "WallModel"

function love.load()
    love.window.setMode(800, 600, {
        fullscreen = false,
        resizable = true,
    })
    love.window.setTitle("Heartbreak")

    love.physics.setMeter(1)

    game = Game.new({
        cameraScale = 0.1,
        gravity = {0, -5},
    })
    game:setWorldViewEnabled(true)

    game:setModelCreator("ball", BallModel.new)
    game:setModelCreator("brick", BrickModel.new)
    game:setModelCreator("paddle", PaddleModel.new)
    game:setModelCreator("score", ScoreModel.new)
    game:setModelCreator("wall", WallModel.new)

    game:newModel("score")

    game:newModel("wall", {
        size = {20, 2},
        position = {0, 9},
        friction = 0.5,
        restitution = 0.5,
    })
    game:newModel("wall", {
        size = {2, 20},
        position = {-9, 0},
        friction = 0.5,
        restitution = 0.5,
    })
    game:newModel("wall", {
        size = {2, 20},
        position = {9, 0},
        friction = 0.5,
        restitution = 0.5,
    })

    game:newModel("paddle", {
        radius = 1,
        position = {0, -9},
        linearAcceleration = 50,
        maxLinearVelocity = 20,
        positionBounds = {-8, -9, 8, -9},
        friction = 0.5,
        restitution = 0.5,
    })
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key, isrepeat)
    if key == "return" and not isrepeat then
        local screenshot = love.graphics.newScreenshot()
        screenshot:encode("heartbreak-screenshot.png")
    end
end
