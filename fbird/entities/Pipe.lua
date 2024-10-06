Pipe = {}
Pipe.__index = Pipe

local PIPE_IMAGE = love.graphics.newImage('assets/images/pipe.png')
local PIPE_SCROLL = -60

function Pipe.new()
  local pipe = setmetatable({}, Pipe)
  return pipe:init()
end

function Pipe:init()
  self.x = WINDOW.VIRTUAL.WIDTH
  self.y = math.random(WINDOW.VIRTUAL.HEIGHT / 2, WINDOW.VIRTUAL.HEIGHT - 50)
  self.width = PIPE_IMAGE:getWidth()

  return self
end

function Pipe:update(dt)
  self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:draw()
  love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end

function Pipe:canDestroy()
  return self.x < -self.width
end
