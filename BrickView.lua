local math_ = require "heart.math"

local PolygonSprite = require "heart.PolygonSprite"

local BrickView = {}
BrickView.__index = BrickView

function BrickView.new(game, model)
    local view = {}
    setmetatable(view, BrickView)

    view._game = game
    view._model = model

    return view
end

function BrickView:create()
    local width, height = unpack(self._model:getConfig().size or {1, 1})
    local heat = love.math.random()
    self._sprite = PolygonSprite.new({
        vertices = {
            -0.5 * width, -0.5 * height,
            0.5 * width, -0.5 * height,
            0.5 * width, 0.5 * height,
            -0.5 * width, 0.5 * height,
        },
        fillColor = {math_.toByte4(heat + 0.5, heat, heat - 0.5, 1)},
    })
    self._layer = self._game:getScene():getLayerByName("brick")
    self._layer:addSprite(self._sprite)
end

function BrickView:destroy()
    self._layer:removeSprite(self._sprite)
end

function BrickView:draw()
    local body = self._model:getBody()
    self._sprite:setPosition(body:getPosition())
    self._sprite:setAngle(body:getAngle())
end

return BrickView
