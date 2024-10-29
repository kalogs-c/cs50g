local quads = {}

function quads.generate_quads(atlas, tile_width, tile_height)
	local sheet_width = atlas:getWidth() / tile_width
	local sheet_height = atlas:getHeigth() / tile_height

	local spritesheet = {}

	for y = 0, sheet_height - 1 do
		for x = 0, sheet_width - 1 do
			table.insert(
				spritesheet,
				love.graphics.newQuad(x * tile_width, y * tile_height, tile_width, tile_height, atlas:getDimensions())
			)
		end
	end

	return spritesheet
end

function quads.generate_paddles_quad(atlas)
	local x, y = 0, 64

	local counter = 1
	local spritesheet = {}

	for _ = 1, 4 do
		spritesheet[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
		counter = counter + 1

		spritesheet[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
		counter = counter + 1

		spritesheet[counter] = love.graphics.newQuad(x + 64, y, 96, 16, atlas:getDimensions())
		counter = counter + 1

		spritesheet[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
		counter = counter + 1

		x = 0
		y = y + 32
	end

	return spritesheet
end

return quads
