WINDOW = {
  TITLE = "F Bird",
  WIDTH = 1280,
  HEIGHT = 720,
  VIRTUAL = {
    WIDTH = 512,
    HEIGHT = 288
  }
}

function love.conf(t)
  math.randomseed(os.time())
  t.console = true
end