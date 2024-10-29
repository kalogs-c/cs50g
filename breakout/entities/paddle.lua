Paddle = {}
Paddle.__index = Paddle

function Paddle.new()
	local paddle = setmetatable({}, Paddle)
	return paddle:init()
end

function Paddle:init()
	self.x = G.WINDOW.VIRTUAL.WIDTH / 2 - 32
	self.y = G.WINDOW.VIRTUAL.HEIGHT - 32

	self.dx = 0

	self.width = 64
	self.height = 16

	-- Set the color of the paddle
	-- 1 = blue, 2 = green, 3 = red, 4 = pink
	self.skin = 1

	-- Set the current paddle on spritesheet
	-- 1 = small, 2 = medium, 3 = large, 4 = huge
	self.size = 2

	return self
end

function Paddle:update(dt)
	-- Input
	if love.keyboard.isDown("left") then
		self.dx = -G.CONSTANTS.PADDLE_SPEED
	elseif love.keyboard.isDown("right") then
		self.dx = G.CONSTANTS.PADDLE_SPEED
	else
		self.dx = 0
	end

	local next_position = self.x + self.dx * dt
	if self.dx < 0 then
		self.x = math.max(0, next_position)
	else
		self.x = math.min(G.WINDOW.VIRTUAL.WIDTH - self.width, next_position)
	end
end

function Paddle:draw()
	love.graphics.draw(G.TEXTURES.BREAKOUT, G.FRAMES.PADDLES[self.skin * self.size], self.x, self.y)
end

return Paddle
