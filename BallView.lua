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
    local radius = self._model:getRadius()

    self._sprite = heart.graphics.newSprite({
        color = {255, 255, 255, 255},
        origin = {radius + 1, radius + 1},
    })

    local imageData = love.image.newImageData(2 * radius + 2, 2 * radius + 2)
    for y = 1, 2 * radius do
        for x = 1, 2 * radius do
            imageData:setPixel(x, y, 255, 255, 255, 255)
        end
    end
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
