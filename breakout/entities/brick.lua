Brick = {}
Brick.__index = Brick

function Brick.new(x, y)
	local brick = setmetatable({}, Brick)
	return brick:init(x, y)
end

function Brick:init(x, y)
	self.x = x
	self.y = y

	self.width = 32
	self.height = 16

	self.tier = 1
	self.color = 1

	self.in_scene = true

	return self
end

function Brick:hit()
	G.SOUNDS.BRICK_HIT2:stop()
	G.SOUNDS.BRICK_HIT2:play()

	if self.tier > 1 then
		self.tier = self.tier - 1
	elseif self.color > 1 then
		self.color = self.color - 1
	else
		G.SOUNDS.BRICK_HIT1:stop()
		G.SOUNDS.BRICK_HIT1:play()
		self.in_scene = false
	end
end

function Brick:draw()
	if self.in_scene then
		love.graphics.draw(G.TEXTURES.BREAKOUT, G.FRAMES.BRICKS[self.tier + (self.color - 1) * 4], self.x, self.y)
	end
end

return Brick
