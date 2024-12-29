Ball = {}
Ball.__index = Ball

function Ball.new(assigns)
	local ball = setmetatable({}, Ball)
	return ball:init(assigns)
end

function Ball:init(assigns)
	self.x = assigns.x
	self.y = assigns.y

	self.dx = assigns.dx
	self.dy = assigns.dy

	self.width = 8
	self.height = 8

	-- Set the color of the ball, 7 in total
	self.skin = assigns.skin

	return self
end

function Ball:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	if self.x <= 0 then
		self.x = 0
		self.dx = -self.dx
		G.SOUNDS.WALL_HIT:play()
	end

	if self.x >= G.WINDOW.VIRTUAL.WIDTH - self.width then
		self.x = G.WINDOW.VIRTUAL.WIDTH - self.width
		self.dx = -self.dx
		G.SOUNDS.WALL_HIT:play()
	end

	if self.y <= 0 then
		self.y = 0
		self.dy = -self.dy
		G.SOUNDS.WALL_HIT:play()
	end
end

function Ball:draw()
	love.graphics.draw(G.TEXTURES.BREAKOUT, G.FRAMES.BALLS[self.skin], self.x, self.y)
end

function Ball:collides(target)
	if self.x + self.width < target.x or self.x > target.x + target.width then
		return false
	end

	if self.y + self.height < target.y or self.y > target.y + target.height then
		return false
	end

	return true
end

function Ball:reset()
	self.x = G.WINDOW.VIRTUAL.WIDTH / 2 - 4
	self.y = G.WINDOW.VIRTUAL.HEIGHT / 2 - 4
	self.dx = 0
	self.dy = 0
end

function Ball:followPaddle(paddle)
	self.x = paddle.x + (paddle.width / 2) - self.width / 2
	self.y = paddle.y - self.height
end

return Ball
