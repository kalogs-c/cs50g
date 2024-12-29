local Brick = require("entities.brick")

local level_maker = {
	Patterns = {
		Global = {
			NONE = 1,
			SINGLE_PYRAMID = 2,
			MULTI_PYRAMID = 3,
		},
		PerRow = {
			SOLID = 1,
			ALTERNATE = 2,
			SKIP = 3,
			NONE = 4,
		},
	},
}

function level_maker.create_bricks(level)
	local bricks = {}

	local rows = math.random(1)

	local random_columns = math.random(1)
	local columns = random_columns % 2 == 0 and random_columns + 1 or random_columns

	local highest_tier = math.min(3, math.floor(level / 5))
	local highest_color = math.min(5, level % 5 + 3)

	for y = 1, rows do
		local skip_pattern = math.random(2) == 1
		local alternate_pattern = math.random(2) == 1

		local alter_colors = {
			math.random(1, highest_color),
			math.random(1, highest_color),
		}

		local alter_tiers = {
			math.random(1, highest_tier),
			math.random(1, highest_tier),
		}

		local skip_flag = math.random(2) == 1
		local altternate_flag = math.random(2) == 1

		-- solid color we'll use if we're not alternating
		local solid_color = math.random(highest_color)
		local solid_tier = math.random(highest_tier)

		for x = 1, columns do
			if skip_pattern and skip_flag then
				skip_flag = not skip_flag
				goto continue
			else
				skip_flag = not skip_flag
			end

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

			if alternate_pattern and altternate_flag then
				new_brick.color = alter_colors[1]
				new_brick.tier = alter_tiers[1]
			else
				new_brick.color = alter_colors[2]
				new_brick.tier = alter_tiers[2]
			end

			altternate_flag = not altternate_flag
			if not alternate_pattern then
				new_brick.color = solid_color
				new_brick.tier = solid_tier
			end

			table.insert(bricks, new_brick)

			::continue::
		end
	end

	if #bricks == 0 then
		return level_maker.create_bricks(level)
	end

	return bricks
end

return level_maker
