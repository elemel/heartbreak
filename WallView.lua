local PolygonSprite = require "heart.PolygonSprite"

local WallView = {}
WallView.__index = WallView

function WallView.new(game, model)
    local view = {}
    setmetatable(view, WallView)

    view._game = game
    view._model = model

    return view
end

function WallView:create()
    local width, height = unpack(self._model:getConfig().size or {1, 1})
    self._sprite = PolygonSprite.new({
        vertices = {
            -0.5 * width, -0.5 * height,
            0.5 * width, -0.5 * height,
            0.5 * width, 0.5 * height,
            -0.5 * width, 0.5 * height,
        },
        fillColor = {127, 0, 0, 255},
    })
    self._layer = self._game:getScene():getLayerByName("wall")
    self._layer:addSprite(self._sprite)
end

function WallView:destroy()
    self._layer:removeSprite(self._sprite)
end

function WallView:draw()
    local body = self._model:getBody()
    self._sprite:setPosition(body:getPosition())
    self._sprite:setAngle(body:getAngle())
end

return WallView
