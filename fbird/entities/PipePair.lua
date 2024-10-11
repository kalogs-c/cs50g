PipePair = {}
PipePair.__index = PipePair

function PipePair.new(y)
	local pair = setmetatable({}, PipePair)
	return pair:init(y)
end

function PipePair:init(y)
	self.x = WINDOW.VIRTUAL.WIDTH
	self.y = y

	local pipes_gap = math.random(90, 120);
	self.pipes = {
		["upper"] = Pipe.new("top", self.y),
		["lower"] = Pipe.new("bottom", self.y + Pipe.getHeight() + pipes_gap),
	}

	self.scored = false

	return self
end

function PipePair:update(dt)
	for _, pipe in pairs(self.pipes) do
		pipe:update(dt)
		self.x = pipe.x
	end
end

function PipePair:draw()
	for _, pipe in pairs(self.pipes) do
		pipe:draw()
	end
end

function PipePair.canSpawn(manager)
	local time_to_spawn = math.random(2, 2.5)
	return manager.timer > time_to_spawn
end

function PipePair:canDestroy()
	return self.x < -Pipe.getWidth()
end

function PipePair:setScored()
	self.scored = true
end

