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
    self._sprite = heart.graphics.newSprite({
        color = {255, 255, 255, 255},
        origin = {1.5, 1.5},
    })

    local imageData = love.image.newImageData(3, 3)
    imageData:setPixel(1, 1, 255, 255, 255, 255)
    local image = love.graphics.newImage(imageData)

    self._sprite:setImage(image)
    self._sprite:setShader(self._game:getShader("wall"))
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
