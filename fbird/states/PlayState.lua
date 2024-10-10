PlayState = BaseState.new()
PlayState.__index = PlayState

function PlayState.new()
    local ps = setmetatable({}, PlayState)
    return ps:init()
end

function PlayState:init()
    self.bird = Bird.new()
    self.pipe_manager = {
        pipes = {},
        timer = 0,
        previousY = -Pipe.getHeight() + math.random(20, Pipe.getHeight() / 2),
    }
    self.score = 0

    self.time = 0

    return self
end

function PlayState:lost()
    gstatemachine:change('score', { score = self.score })
    sounds.explosion:play()
    sounds.hurt:play()
end

function PlayState:update(dt)
  self.pipe_manager.timer = self.pipe_manager.timer + dt

  if PipePair.canSpawn(self.pipe_manager) then
    local tooHighBaseCase = -Pipe.getHeight() + 40
    local tooLowBaseCase = WINDOW.VIRTUAL.HEIGHT - PipePair.getGap() - Pipe.getHeight() - 50
    local targetY = math.min(
      self.pipe_manager.previousY + math.random(-80, 80),
      tooLowBaseCase
    )
    local y = math.max(tooHighBaseCase, targetY)
    self.pipe_manager.previousY = y

    table.insert(self.pipe_manager.pipes, PipePair.new(y))
    self.pipe_manager.timer = 0
  end

  self.bird:update(dt)
  for _, pair in pairs(self.pipe_manager.pipes) do
    if not pair.scored then
        self.time = self.time + dt
        if self.bird.x + self.bird.width > pair.x + Pipe.getWidth() then
            self.score = self.score + 1
            pair:setScored()
            sounds.score:play()
        end
    end

    pair:update(dt)
  end

  for _, pair in pairs(self.pipe_manager.pipes) do
    for _, pipe in pairs(pair.pipes) do
        if self.bird:collides(pipe) then
            self:lost()
        end
    end
  end

  if self.bird.y + self.bird.height > WINDOW.VIRTUAL.HEIGHT then
    self:lost()
  end

  for k, pair in pairs(self.pipe_manager.pipes) do
    if pair:canDestroy() then
      table.remove(self.pipe_manager.pipes, k)
    end
  end
end

function PlayState:draw()
    for _, pipe in pairs(self.pipe_manager.pipes) do
      pipe:draw()
    end
    self.bird:draw()

    love.graphics.setFont(fonts.flappy)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
end