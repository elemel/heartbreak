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
    local width, height = self._model:getSize()
    self._sprite = heart.graphics.newSprite({
        color = {255, 255, 255, 255},
        origin = {1 + 0.5 * width, 1 + 0.5 * height},
    })

    local imageData = love.image.newImageData(width + 2, height + 2)
    for y = 1, height do
        for x = 1, width do
            imageData:setPixel(x, y, 255, 255, 255, 255)
        end
    end
    local image = love.graphics.newImage(imageData)

    self._sprite:setImage(image)
    self._sprite:setShader(self._game:getShader("wall"))
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
