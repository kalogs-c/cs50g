local Brick = require("entities.brick")

local level_maker = {}

function level_maker.create_bricks()
	local bricks = {}

	local rows = math.random(2, 5)
	local columns = math.random(7, 13)

	for y = 1, rows do
		for x = 1, columns do
			local new_brick = Brick.new(
				-- X
				-- decrement x by 1 because tables are 1-indexed, coords are 0
				-- multiply by 32, the brick width
				-- add 8, the screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
				-- left-side padding for when there are fewer than 13 columns
				(x - 1) * 32
					+ 8
					+ (13 - columns) * 16,

				-- Y
				-- just use y * 16, since we need top padding anyway
				y * 16
			)
			table.insert(bricks, new_brick)
		end
	end

	return bricks
end

return level_maker
