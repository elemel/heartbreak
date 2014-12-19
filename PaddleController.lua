local PaddleController = {}
PaddleController.__index = PaddleController

function PaddleController.new(game, model)
    local controller = {}
    setmetatable(controller, PaddleController)

    controller._game = game
    controller._model = model

    return controller
end

function PaddleController:create()
end

function PaddleController:destroy()
end

function PaddleController:update(dt)
    if love.mouse.isGrabbed() then
        local width, height = self._model:getSize()
        local x1, y1, x2, y2 = self._model:getLine()

        local mouseX, mouseY = heart.mouse.readPosition()
        local transformation = self._game:getCamera():getInverseTransformation()
        local x, y = self._model:getPosition()
        local dx, dy = transformation:transformVector(mouseX, mouseY)
        x = heart.math.clamp(x + dx, x1 + 0.5 * width, x2 - 0.5 * width)
        y = heart.math.clamp(y + dy, y1, y2)
        self._model:setPosition(x, y)
    end
end

return PaddleController
