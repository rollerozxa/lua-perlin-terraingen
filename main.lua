
require('perlin')
require('encode_pxm')
require('vector')

local sea = vector.new(53, 35, 252)
local beach = vector.new(242, 240, 104)
local grass = vector.new(19, 156, 19)

local data = {}

for y = 0, 1023, 1 do
	local row = {}

	for x = 0, 1023, 1 do
		local val = (perlin_noise(x/64,y/64,0)+1)*128+(perlin_noise(x/64,y/64,80.75)*100)

		if val < 110 then
			row[#row+1] = sea:multiply(0.7):floor()
		elseif val < 135 then
			row[#row+1] = sea
			--row[#row+1] = sea:multiply(math.max(0.5, math.min(val/120, 1))):floor()
		elseif val < 145 then
			row[#row+1] = beach
		elseif val < 170 then
			row[#row+1] = grass
		else
			row[#row+1] = grass:multiply(1.1):floor()
		end

	end

	data[#data+1] = row
end

encode_pxm(3, "terrain", data)
