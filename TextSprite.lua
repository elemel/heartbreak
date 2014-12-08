local TextSprite = {}
TextSprite.__index = TextSprite

function TextSprite.new(config)
    local sprite = {}
    setmetatable(sprite, TextSprite)

    config = config or {}
    sprite._text = config.text or ""
    sprite._color = config.color or {255, 255, 255, 255}
    sprite._position = config.position or {0, 0}
    sprite._width = config.width or 1
    sprite._alignment = config.alignment or "left"

    return sprite
end

function TextSprite:getPosition()
    return unpack(self._position)
end

function TextSprite:setPosition(x, y)
    self._position = {x, y}
end

function TextSprite:getWidth()
    return self._width
end

function TextSprite:setWidth(width)
    self._width = width
end

function TextSprite:getText()
    return self._text
end

function TextSprite:setText(text)
    self._text = text
end

function TextSprite:getFont()
    return self._font
end

function TextSprite:setFont(font)
    self._font = font
end

function TextSprite:getAlignment()
    return self._alignment
end

function TextSprite:setAlignment(alignment)
    self._alignment = alignment
end

function TextSprite:draw()
    if self._font then
        local x, y = unpack(self._position)
        love.graphics.setFont(self._font)
        love.graphics.setColor(unpack(self._color))
        love.graphics.printf(self._text, x, y, self._width, self._alignment)
    end
end

return TextSprite
