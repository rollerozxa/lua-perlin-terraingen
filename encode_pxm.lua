
-- P: The type (1 - PBM, 2 - PGM, 3 - PPM)
-- name: Filename (extension gets automatically appended)
-- data: Two-dimensional table, format depends on type
function encode_pxm(P, name, data)
	local buf = {}

	buf[#buf+1] = 'P'..P..'\n'..#data[1]..' '..#data..'\n' -- w & h

	if P == 3 or P == 2 then
		buf[#buf+1] = '255'..'\n'
	end

	for _,row in ipairs(data) do
		for _,cell in ipairs(row) do
			if P == 3 then
				buf[#buf+1] = cell[1]..' '..cell[2]..' '..cell[3]..'\n'
			else
				buf[#buf+1] = cell..'\n'
			end
		end
	end

	local f = io.open(name..'.'..({"pbm", "pgm", "ppm"})[P], "w")
	f:write(table.concat(buf))
	f:close()
end
