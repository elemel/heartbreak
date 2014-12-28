heart = require "heart"

local BallAndPaddleContactHandler = require "BallAndPaddleContactHandler"
local BallAndWallContactHandler = require "BallAndWallContactHandler"
local BallModel = require "BallModel"
local BallView = require "BallView"
local BrickModel = require "BrickModel"
local BrickView = require "BrickView"
local PaddleController = require "PaddleController"
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
    love.graphics.setBackgroundColor(heart.math.toByte4(0.2, 0.15, 0.1, 1))
    love.graphics.setNewFont(100)

    game = heart.game.newGame({
        cameraScale = 0.1,
        gravity = {0, -5},
    })
    game:setWorldViewEnabled(false)

    game:setModelFactory("ball", BallModel.new)
    game:setModelFactory("brick", BrickModel.new)
    game:setModelFactory("paddle", PaddleModel.new)
    game:setModelFactory("score", ScoreModel.new)
    game:setModelFactory("wall", WallModel.new)

    game:setContactHandler("ball", "paddle", BallAndPaddleContactHandler.new(game))
    game:setContactHandler("ball", "wall", BallAndWallContactHandler.new(game))

    game:setViewFactory("ball", BallView.new)
    game:setViewFactory("brick", BrickView.new)
    game:setViewFactory("paddle", PaddleView.new)
    game:setViewFactory("score", ScoreView.new)
    game:setViewFactory("wall", WallView.new)

    game:setControllerFactory("paddle", PaddleController.new)

    game:getScene():addLayer(heart.graphics.newSpriteLayer("wall"))
    game:getScene():addLayer(heart.graphics.newSpriteLayer("paddle"))
    game:getScene():addLayer(heart.graphics.newSpriteLayer("brick"))
    game:getScene():addLayer(heart.graphics.newSpriteLayer("ball"))
    game:getScene():addLayer(TextSpriteLayer.new("score"))

    local wallShaderSource = love.filesystem.read("resources/shaders/wall.glsl")
    local wallShader = love.graphics.newShader(wallShaderSource)
    game:setShader("wall", wallShader)

    game:setSound("break", love.audio.newSource("resources/sounds/break.ogg", "static"))
    game:setSound("hit", love.audio.newSource("resources/sounds/hit.ogg", "static"))
    game:setSound("score", love.audio.newSource("resources/sounds/score.ogg", "static"))

    game:newModel("score")

    local blocks = {}
    for y = -10, 7 do
        blocks[{-10, y}] = "metal"
        blocks[{-9, y}] = "metal"
        blocks[{8, y}] = "metal"
        blocks[{9, y}] = "metal"
    end
    for x = -10, 9 do
        blocks[{x, 8}] = "metal"
        blocks[{x, 9}] = "metal"
    end
    game:newModel("wall", {
        blocks = blocks,
        friction = 1,
    })

    game:newModel("paddle", {
        size = {4, 1},
        position = {0, -8.5},
        line = {-8, -8.5, 8, -8.5},
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
    if key == "1" and not isrepeat then
        game:setWorldViewEnabled(not game:isWorldViewEnabled())
    end
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
