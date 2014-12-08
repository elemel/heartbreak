local TextSprite = require "TextSprite"

local ScoreView = {}
ScoreView.__index = ScoreView

function ScoreView.new(game, model)
    local view = {}
    setmetatable(view, ScoreView)

    view._game = game
    view._model = model
    view._fonts = {}

    return view
end

function ScoreView:create()
    local width, height = unpack(self._model:getConfig().size or {1, 1})
    self._sprite = TextSprite.new({
        alignment = "center",
    })
    self._layer = self._game:getScene():getLayerByName("score")
    self._layer:addSprite(self._sprite)
end

function ScoreView:destroy()
    self._layer:removeSprite(self._sprite)
end

function ScoreView:draw()
    local width, height = love.window.getDimensions()
    self._sprite:setPosition(0, 0)
    self._sprite:setWidth(width)
    self._sprite:setFont(self:_getFont(0.08 * height))
    self._sprite:setText("LEVEL " .. self._model:getLevel() .. " / SCORE " .. self._model:getScore())
end

function ScoreView:_getFont(size)
    size = math.floor(size + 0.5)
    if not self._fonts[size] then
        self._fonts[size] = love.graphics.newFont(size)
    end
    return self._fonts[size]
end


return ScoreView
