heart = require "heart"

local BallAndPaddleContactHandler = require "BallAndPaddleContactHandler"
local BallModel = require "BallModel"
local BallView = require "BallView"
local BrickModel = require "BrickModel"
local BrickView = require "BrickView"
local PaddleModel = require "PaddleModel"
local PaddleView = require "PaddleView"
local ScoreModel = require "ScoreModel"
local ScoreView = require "ScoreView"
local TextSpriteLayer = require "TextSpriteLayer"
local WallModel = require "WallModel"
local WallView = require "WallView"

function love.load()
    love.window.setMode(800, 600, {
        fullscreen = false,
        fullscreentype = "desktop",
        resizable = true,
    })
    love.window.setTitle("Heartbreak")
    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)

    love.physics.setMeter(1)
    love.graphics.setBackgroundColor(63, 0, 0, 255)
    love.graphics.setNewFont(100)

    game = heart.game.newGame({
        cameraScale = 0.1,
        gravity = {0, -5},
    })
    game:setWorldViewEnabled(false)

    game:setModelCreator("ball", BallModel.new)
    game:setModelCreator("brick", BrickModel.new)
    game:setModelCreator("paddle", PaddleModel.new)
    game:setModelCreator("score", ScoreModel.new)
    game:setModelCreator("wall", WallModel.new)

    game:setContactHandler("ball", "paddle", BallAndPaddleContactHandler.new())

    game:setViewCreator("ball", BallView.new)
    game:setViewCreator("brick", BrickView.new)
    game:setViewCreator("paddle", PaddleView.new)
    game:setViewCreator("score", ScoreView.new)
    game:setViewCreator("wall", WallView.new)

    game:getScene():addLayer(heart.graphics.newSpriteLayer("wall"))
    game:getScene():addLayer(heart.graphics.newSpriteLayer("paddle"))
    game:getScene():addLayer(heart.graphics.newSpriteLayer("brick"))
    game:getScene():addLayer(heart.graphics.newSpriteLayer("ball"))
    game:getScene():addLayer(TextSpriteLayer.new("score"))

    game:setSound("break", love.audio.newSource("resources/sounds/break.ogg", "static"))
    game:setSound("hit", love.audio.newSource("resources/sounds/hit.ogg", "static"))
    game:setSound("score", love.audio.newSource("resources/sounds/score.ogg", "static"))

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
        size = {4, 1},
        position = {0, -8.5},
        positionBounds = {-6, -8.5, 6, -8.5},
        restitution = 0.5,
    })
end

function love.update(dt)
    if love.mouse.isGrabbed() then
        game:update(dt)
    end
end

function love.draw()
    game:draw()
end

function love.keypressed(key, isrepeat)
    if key == "escape" and not isrepeat then
        love.mouse.setVisible(true)
        love.mouse.setGrabbed(false)
    end
    if key == "return" and not isrepeat then
        local screenshot = love.graphics.newScreenshot()
        screenshot:encode("heartbreak-screenshot.png")
    end
end

function love.mousepressed(x, y, button)
    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)
    heart.mouse.readPosition()
end
