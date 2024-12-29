Brick = {}
Brick.__index = Brick

local new_palette = function(r, g, b)
	return {
		r = r / 255,
		g = g / 255,
		b = b / 255,
	}
end

local particles_palette = {
	-- blue
	new_palette(99, 155, 255),
	-- green
	new_palette(106, 190, 47),
	-- red
	new_palette(217, 87, 99),
	-- purple
	new_palette(215, 123, 186),
	-- gold
	new_palette(251, 242, 54),
}

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

	-- https://love2d.org/wiki/ParticleSystem
	self.psystem = love.graphics.newParticleSystem(G.TEXTURES.PARTICLES, 64)
	self.psystem:setParticleLifetime(0.5, 1)
	self.psystem:setLinearAcceleration(-15, 0, 15, 80)
	self.psystem:setEmissionArea("normal", 10, 10)

	return self
end

function Brick:hit()
	local next_color = math.max(1, self.color - 1)
	self.psystem:setColors(
		particles_palette[self.color].r,
		particles_palette[self.color].g,
		particles_palette[self.color].b,
		(55 * self.tier) / 255,
		particles_palette[next_color].r,
		particles_palette[next_color].g,
		particles_palette[next_color].b,
		0
	)

	self.psystem:emit(64)

	G.SOUNDS.BRICK_HIT2:stop()
	G.SOUNDS.BRICK_HIT2:play()

	if self.tier > 1 then
		self.tier = self.tier - 1
	elseif self.color > 1 then
		self.color = self.color - 1
		self.tier = 4
	else
		G.SOUNDS.BRICK_HIT1:stop()
		G.SOUNDS.BRICK_HIT1:play()
		self.in_scene = false
	end
end

function Brick:update(dt)
	self.psystem:update(dt)
end

function Brick:draw()
	if self.in_scene then
		love.graphics.draw(G.TEXTURES.BREAKOUT, G.FRAMES.BRICKS[self.tier + (self.color - 1) * 4], self.x, self.y)
	end
end

function Brick:drawParticles()
	love.graphics.draw(self.psystem, self.x + self.width / 2, self.y + self.height / 2)
end

return Brick
