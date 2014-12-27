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
    local x0, y0 = unpack(self._model:getConfig().position or {0, 0})
    local width, height = self._model:getSize()
    local heat = heart.math.fbm2(0.1 * x0, 0.1 * y0)
    self._sprite = heart.graphics.newSprite({
        color = {heart.math.toByte4(heat + 0.5, heat, heat - 0.5, 1)},
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
