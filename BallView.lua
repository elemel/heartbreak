local BallView = {}
BallView.__index = BallView

function BallView.new(game, model)
    local view = {}
    setmetatable(view, BallView)

    view._game = game
    view._model = model

    return view
end

function BallView:create()
    local radius = self._model:getConfig().radius or 1
    self._sprite = heart.graphics.newCircleSprite({
        radius = radius,
        color = {255, 255, 255, 255},
    })
    self._layer = self._game:getScene():getLayerByName("ball")
    self._layer:addSprite(self._sprite)
end

function BallView:destroy()
    self._layer:removeSprite(self._sprite)
end

function BallView:draw()
    local body = self._model:getBody()
    self._sprite:setPosition(body:getPosition())
    self._sprite:setAngle(body:getAngle())
end

return BallView
