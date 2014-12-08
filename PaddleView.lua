local CircleSprite = require "heart.CircleSprite"

local PaddleView = {}
PaddleView.__index = PaddleView

function PaddleView.new(game, model)
    local view = {}
    setmetatable(view, PaddleView)

    view._game = game
    view._model = model

    return view
end

function PaddleView:create()
    local radius = self._model:getConfig().radius or 1
    self._sprite = CircleSprite.new({
        radius = radius,
        fillColor = {255, 127, 0, 255},
    })
    self._layer = self._game:getScene():getLayerByName("paddle")
    self._layer:addSprite(self._sprite)
end

function PaddleView:destroy()
    self._layer:removeSprite(self._sprite)
end

function PaddleView:draw()
    local body = self._model:getBody()
    self._sprite:setPosition(body:getPosition())
    self._sprite:setAngle(body:getAngle())
end

return PaddleView
