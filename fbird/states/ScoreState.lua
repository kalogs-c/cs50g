ScoreState = BaseState.new()
ScoreState.__index = ScoreState

function ScoreState.new()
	return setmetatable({}, ScoreState)
end

function ScoreState:enter(context)
	self.score = context.score
	
	self.medalsImage = love.graphics.newImage("assets/images/medals.png")
	if self.score < 1 then
		self.medalQuad = love.graphics.newQuad(190, 0, 80, self.medalsImage:getHeight(), self.medalsImage:getDimensions())
	elseif self.score < 2 then
		self.medalQuad = love.graphics.newQuad(100, 0, 80, self.medalsImage:getHeight(), self.medalsImage:getDimensions())
	else
		self.medalQuad = love.graphics.newQuad(10, 0, 80, self.medalsImage:getHeight(), self.medalsImage:getDimensions())
	end
end

function ScoreState:update(dt)
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		gstatemachine:change("countdown")
	end
end

function ScoreState:draw()
	love.graphics.draw(self.medalsImage, self.medalQuad, WINDOW.VIRTUAL.WIDTH / 2 - 40, 0)
	love.graphics.setFont(fonts.flappy)
	love.graphics.printf("Oops! You lost!", 0, 105, WINDOW.VIRTUAL.WIDTH, "center")

	love.graphics.setFont(fonts.medium)
	love.graphics.printf("Score: " .. tostring(self.score), 0, 140, WINDOW.VIRTUAL.WIDTH, "center")

	love.graphics.printf("Press Enter to Play Again!", 0, 200, WINDOW.VIRTUAL.WIDTH, "center")
end
