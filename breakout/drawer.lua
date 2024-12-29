local drawer = {}

function drawer.draw_score(score)
	love.graphics.setFont(G.FONTS.SMALL)
	love.graphics.print("Score: ", G.WINDOW.VIRTUAL.WIDTH - 60, 5)
	love.graphics.printf(tostring(score), G.WINDOW.VIRTUAL.WIDTH - 50, 5, 40, "right")
end

function drawer.draw_health(health)
	local health_x = G.WINDOW.VIRTUAL.WIDTH - 100

	for _ = 1, health do
		love.graphics.draw(G.TEXTURES.HEARTS, G.FRAMES.HEARTS[1], health_x, 4)
		health_x = health_x + 10
	end

	for _ = 1, 3 - health do
		love.graphics.draw(G.TEXTURES.HEARTS, G.FRAMES.HEARTS[2], health_x, 4)
		health_x = health_x + 10
	end
end

function drawer.draw_level(level)
	love.graphics.setFont(G.FONTS.SMALL)
	love.graphics.print("Level: ", G.WINDOW.VIRTUAL.WIDTH - 60, 20)
	love.graphics.printf(tostring(level), G.WINDOW.VIRTUAL.WIDTH - 50, 20, 40, "right")
end

return drawer
