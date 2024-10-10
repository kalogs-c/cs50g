PipePair = {}
PipePair.__index = PipePair

local PIPES_GAP = 90

function PipePair.new(y)
    local pair = setmetatable({}, PipePair)
    return pair:init(y)
end

function PipePair:init(y)
    self.x = WINDOW.VIRTUAL.WIDTH
    self.y = y

    self.pipes = {
        ["upper"] = Pipe.new("top", self.y),
        ["lower"] = Pipe.new("bottom", self.y + Pipe.getHeight() + PIPES_GAP)
    }

    self.scored = false

    return self
end

function PipePair.getGap()
    return PIPES_GAP
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
  return manager.timer > 2.25
end

function PipePair:canDestroy()
  return self.x < -Pipe.getWidth()
end

function PipePair:setScored()
    self.scored = true
end