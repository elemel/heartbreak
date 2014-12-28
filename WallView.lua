local WallView = {}
WallView.__index = WallView

function WallView.new(game, model)
    local view = {}
    setmetatable(view, WallView)

    view._game = game
    view._model = model
    view._blockVersion = 1

    return view
end

function WallView:create()
    local width, height = unpack(self._model:getConfig().size or {1, 1})
    self._sprite = heart.graphics.newSprite()
    self._sprite:setShader(self._game:getShader("wall"))
    self._layer = self._game:getScene():getLayerByName("wall")
    self._layer:addSprite(self._sprite)
end

function WallView:destroy()
    self._layer:removeSprite(self._sprite)
end

function WallView:draw()
    local model = self._model

    if self._blockVersion ~= model:getBlockVersion() then
        local blockTypes = model:getBlockTypes()

        local x1, y1 = math.huge, math.huge
        local x2, y2 = -math.huge, -math.huge
        for y, row in pairs(blockTypes) do
            for x, blockType in pairs(row) do
                x1 = math.min(x, x1)
                y1 = math.min(y, y1)
                x2 = math.max(x, x2)
                y2 = math.max(y, y2)
            end
        end

        local imageData = love.image.newImageData(x2 - x1 + 3, y2 - y1 + 3)
        for y = y1, y2 do
            for x = x1, x2 do
                local blockType = blockTypes[y] and blockTypes[y][x]
                if blockType then
                    local r, g, b, a = self:getBlockColor(x, y)
                    imageData:setPixel(x - x1 + 1, y - y1 + 1, r, g, b, a)
                end
            end
        end
        local image = love.graphics.newImage(imageData)

        local x0, y0 = model:getOrigin()
        self._sprite:setImage(image)
        self._sprite:setOrigin(x0 + 1 - x1, y0 + 1 - y1)

        self._blockVersion = model:getBlockVersion()
    end

    local body = model:getBody()
    self._sprite:setPosition(body:getPosition())
    self._sprite:setAngle(body:getAngle())
end

function WallView:getBlockColor(x, y)
    local model = self._model

    local heat = heart.math.fbm2(0.1 * x, 0.1 * y)
    if model:isBreakable() then
        return heart.math.toByte4(heat + 0.5, heat, heat - 0.5, 1)
    else
        return heart.math.toByte4(0.5 * heat + 0.1, 0.5 * heat, 0.5 * heat - 0.1, 1)
    end
end

return WallView
