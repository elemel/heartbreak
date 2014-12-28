local BallAndWallContactHandler = {}
BallAndWallContactHandler.__index = BallAndWallContactHandler

function BallAndWallContactHandler.new(game)
    local handler = {}
    setmetatable(handler, BallAndWallContactHandler)

    handler._game = game

    return handler
end

function BallAndWallContactHandler:beginContact(
        ballFixture, wallFixture, contact, reversed)
    local wallModel = wallFixture:getUserData().model
    if wallModel:isBreakable() and not wallModel:isFalling() then
        wallModel:setFalling(true)
        self:_addScore(1)
        self._game:playSound("hit")
    end
end

function BallAndWallContactHandler:endContact(
        ballFixture, wallFixture, contact, reversed)
end

function BallAndWallContactHandler:preSolve(
        ballFixture, wallFixture, contact, reversed)
end

function BallAndWallContactHandler:postSolve(
        ballFixture, wallFixture, contact, normalImpulse1, tangentImpulse1,
        normalImpulse2, tangentImpulse2, reversed)
end

function BallAndWallContactHandler:_addScore(score)
    local scoreModel = self._game:getModelByType("score")
    if scoreModel then
        scoreModel:setScore(scoreModel:getScore() + score)
    end
end

return BallAndWallContactHandler
