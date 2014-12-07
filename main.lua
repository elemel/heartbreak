local BallModel = require "BallModel"
local BrickModel = require "BrickModel"
local Game = require "heart.Game"
local math3D = require "heart.math3D"
local PaddleModel = require "PaddleModel"
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
    game:setModelCreator("wall", WallModel.new)

    game:newModel("wall", {
        size = {20, 2},
        position = {0, 9},
    })
    game:newModel("wall", {
        size = {2, 20},
        position = {-9, 0},
    })
    game:newModel("wall", {
        size = {2, 20},
        position = {9, 0},
    })

    local z = 1000 * love.math.random()
    local frequency = 0.2
    for y = 0, 7 do
        for x = -8, 7, 2 do
            if math3D.fbm(frequency * (x + 1), frequency * (y + 0.5), z) > 0.5 then
                game:newModel("brick", {
                    size = {2, 1},
                    position = {x + 1, y + 0.5},
                    restitution = 0.75,
                })
            end
        end
    end

    game:newModel("paddle", {
        radius = 1,
        position = {0, -9},
        linearAcceleration = 50,
        maxLinearVelocity = 20,
        positionBounds = {-8, 0, 8, 0},
        restitution = 0.75,
    })

    game:newModel("ball", {
        position = {0, -7.5},
        linearVelocity = {love.math.random() - 0.5, 1},
        minLinearVelocity = 10,
        maxLinearVelocity = 10,
        minLinearVelocityY = 2,
        radius = 0.5,
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
