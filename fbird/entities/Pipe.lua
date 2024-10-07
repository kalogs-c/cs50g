Pipe = {}
Pipe.__index = Pipe

local PIPE_IMAGE = love.graphics.newImage('assets/images/pipe.png')
local PIPE_SCROLL = -60

local PIPE_HEIGHT = PIPE_IMAGE:getHeight();
local PIPE_WIDTH = PIPE_IMAGE:getWidth();

function Pipe.new(orientation, y)
  local pipe = setmetatable({}, Pipe)
  return pipe:init(orientation, y)
end

function Pipe.getHeight()
  return PIPE_HEIGHT
end

function Pipe.getWidth()
  return PIPE_WIDTH
end

function Pipe:init(orientation, y)
  self.x = WINDOW.VIRTUAL.WIDTH
  self.y = y
  self.width = PIPE_WIDTH
  self.height = PIPE_HEIGHT
  self.orientation = orientation

  return self
end

function Pipe:update(dt)
  self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:draw()
  local y = self.y
  local spriteOrientation = 1

  if self.orientation == "top" then
    y = self.y + self.height
    spriteOrientation = -1
  end

  love.graphics.draw(PIPE_IMAGE, self.x, y, 0, 1, spriteOrientation)
end