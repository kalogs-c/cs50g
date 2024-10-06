Bird = {}
Bird.__index = Bird

local GRAVITY = 10

function Bird.new()
  local bird = setmetatable({}, Bird)
  return bird:init()
end

function Bird:init()
  self.image = love.graphics.newImage('assets/images/bird.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.x = WINDOW.VIRTUAL.WIDTH / 2 - (self.width / 2)
  self.y = WINDOW.VIRTUAL.HEIGHT / 2 - (self.height / 2)
  self.dy = 0 

  return self
end

function Bird:update(dt)
  self.dy = self.dy + GRAVITY * dt

  if love.keyboard.wasPressed('space') then
    self.dy = -1.25
  end

  self.y = self.y + self.dy
end

function Bird:draw()
  love.graphics.draw(self.image, self.x, self.y)
end
