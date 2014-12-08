local BallModel = require "BallModel"
local BallView = require "BallView"
local BrickModel = require "BrickModel"
local BrickView = require "BrickView"
local Game = require "heart.Game"
local math3D = require "heart.math3D"
local PaddleModel = require "PaddleModel"
local PaddleView = require "PaddleView"
local ScoreModel = require "ScoreModel"
local ScoreView = require "ScoreView"
local SpriteLayer = require "heart.SpriteLayer"
local TextSpriteLayer = require "TextSpriteLayer"
local WallModel = require "WallModel"
local WallView = require "WallView"

function love.load()
    love.window.setMode(800, 600, {
        fullscreen = false,
        resizable = true,
    })
    love.window.setTitle("Heartbreak")

    love.physics.setMeter(1)
    love.graphics.setBackgroundColor(63, 0, 0, 255)
    love.graphics.setNewFont(100)

    game = Game.new({
        cameraScale = 0.1,
        gravity = {0, -5},
    })
    game:setWorldViewEnabled(false)

    game:setModelCreator("ball", BallModel.new)
    game:setModelCreator("brick", BrickModel.new)
    game:setModelCreator("paddle", PaddleModel.new)
    game:setModelCreator("score", ScoreModel.new)
    game:setModelCreator("wall", WallModel.new)

    game:setViewCreator("ball", BallView.new)
    game:setViewCreator("brick", BrickView.new)
    game:setViewCreator("paddle", PaddleView.new)
    game:setViewCreator("score", ScoreView.new)
    game:setViewCreator("wall", WallView.new)

    game:getScene():addLayer(SpriteLayer.new("wall"))
    game:getScene():addLayer(SpriteLayer.new("paddle"))
    game:getScene():addLayer(SpriteLayer.new("brick"))
    game:getScene():addLayer(SpriteLayer.new("ball"))
    game:getScene():addLayer(TextSpriteLayer.new("score"))

    game:newModel("score")

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

    game:newModel("paddle", {
        radius = 1,
        position = {0, -9},
        linearAcceleration = 50,
        maxLinearVelocity = 20,
        positionBounds = {-8, -9, 8, -9},
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
