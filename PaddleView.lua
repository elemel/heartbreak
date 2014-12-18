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
    local width, height = unpack(self._model:getConfig().size or {1, 1})
    self._sprite = heart.graphics.newPolygonSprite({
        vertices = {
            -0.5 * width, -0.5 * height,
            0.5 * width, -0.5 * height,
            0.5 * width, 0.5 * height,
            -0.5 * width, 0.5 * height,
        },
        color = {255, 127, 0, 255},
    })
    self._layer = self._game:getScene():getLayerByName("paddle")
    self._layer:addSprite(self._sprite)
end

function PaddleView:destroy()
    self._layer:removeSprite(self._sprite)
end

function PaddleView:draw()
    self._sprite:setPosition(self._model:getPosition())
end

return PaddleView
