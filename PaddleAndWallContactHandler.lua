local PaddleAndWallContactHandler = {}
PaddleAndWallContactHandler.__index = PaddleAndWallContactHandler

function PaddleAndWallContactHandler.new(game)
    local handler = {}
    setmetatable(handler, PaddleAndWallContactHandler)

    handler._game = game

    return handler
end

function PaddleAndWallContactHandler:beginContact(
        paddleFixture, wallFixture, contact, reversed)
    if paddleFixture:getCategory() == 6 then
        local wallModel = wallFixture:getUserData().model
        if wallModel:isBreakable() then
            wallModel:setBroken(true)
            self:_addScore(wallModel:getBlockCount())
            self._game:playSound("break")
        end
    end
end

function PaddleAndWallContactHandler:endContact(
        paddleFixture, wallFixture, contact, reversed)
end

function PaddleAndWallContactHandler:preSolve(
        paddleFixture, wallFixture, contact, reversed)
end

function PaddleAndWallContactHandler:postSolve(
        paddleFixture, wallFixture, contact, normalImpulse1, tangentImpulse1,
        normalImpulse2, tangentImpulse2, reversed)
end

function PaddleAndWallContactHandler:_addScore(score)
    local scoreModel = self._game:getModelByType("score")
    if scoreModel then
        scoreModel:setScore(scoreModel:getScore() + score)
    end
end

return PaddleAndWallContactHandler
