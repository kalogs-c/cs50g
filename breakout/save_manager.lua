local stringsplit = require("vendor.split")
local save_manager = {}

function save_manager.load_highscores()
	love.filesystem.setIdentity("breakout")

	if not love.filesystem.getInfo("breakout.lst") then
		local scores = ""
		for i = 10, 1, -1 do
			scores = scores .. "CTO\t" .. tostring(i * 1000) .. "\n"
		end

		love.filesystem.write("breakout.lst", scores)
	end

	local scores = {}
	for line in love.filesystem.lines("breakout.lst") do
		local curr_score = stringsplit(line, "\t")
		table.insert(scores, {
			name = curr_score[1],
			score = curr_score[2],
		})
	end

	return scores
end

return save_manager
