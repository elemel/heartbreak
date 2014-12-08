local LinkedSet = require "heart.LinkedSet"

local TextSpriteLayer = {}
TextSpriteLayer.__index = TextSpriteLayer

function TextSpriteLayer.new(name)
    local layer = {}
    setmetatable(layer, TextSpriteLayer)

    layer._name = name
    layer._sprites = LinkedSet.new()

    return layer
end

function TextSpriteLayer:getName()
    return self._name
end

function TextSpriteLayer:addSprite(sprite)
    self._sprites:addLast(sprite)
end

function TextSpriteLayer:removeSprite(sprite)
    self._sprites:remove(sprite)
end

function TextSpriteLayer:draw()
    love.graphics.push()
    love.graphics.origin()

    for sprite in self._sprites:iterate() do
        sprite:draw()
    end

    love.graphics.pop()
end

return TextSpriteLayer
