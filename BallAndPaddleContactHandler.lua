local BallAndPaddleContactHandler = {}
BallAndPaddleContactHandler.__index = BallAndPaddleContactHandler

function BallAndPaddleContactHandler.new()
    local handler = {}
    setmetatable(handler, BallAndPaddleContactHandler)
    return handler
end

function BallAndPaddleContactHandler:beginContact(
        ballFixture, paddleFixture, contact, reversed)
    local ballBody = ballFixture:getBody()
    local dx, dy = ballBody:getLinearVelocity()
    if dy < 0 then
        local ballX, ballY = ballBody:getPosition()

        local paddleModel = paddleFixture:getUserData().model
        local paddleX, paddleY = paddleModel:getPosition()
        local paddleWidth, paddleHeight = paddleModel:getSize()
        if paddleX - 0.5 * paddleWidth < ballX and
                ballX < paddleX + 0.5 * paddleWidth then
            dy = -dy
            ballBody:setLinearVelocity(dx, dy)
        end
    end
end

function BallAndPaddleContactHandler:endContact(
        ballFixture, paddleFixture, contact, reversed)
end

function BallAndPaddleContactHandler:preSolve(
        ballFixture, paddleFixture, contact, reversed)
end

function BallAndPaddleContactHandler:postSolve(
        ballFixture, paddleFixture, contact, normalImpulse1, tangentImpulse1,
        normalImpulse2, tangentImpulse2, reversed)
end

return BallAndPaddleContactHandler
