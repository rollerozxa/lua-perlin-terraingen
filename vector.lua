
-- Taken from Minetest: builtin/common/vector.lua

--[[
Vector helpers
Note: The vector.*-functions must be able to accept old vectors that had no metatables
]]

vector = {}

local metatable = {}
vector.metatable = metatable

local xyz = {"x", "y", "z"}

-- only called when rawget(v, key) returns nil
function metatable.__index(v, key)
	return rawget(v, xyz[key]) or vector[key]
end

-- only called when rawget(v, key) returns nil
function metatable.__newindex(v, key, value)
	rawset(v, xyz[key] or key, value)
end

-- constructors

local function fast_new(x, y, z)
	return setmetatable({x = x, y = y, z = z}, metatable)
end

function vector.new(a, b, c)
	return fast_new(a, b, c)
end

function vector.zero()
	return fast_new(0, 0, 0)
end

function vector.copy(v)
	assert(v.x and v.y and v.z, "Invalid vector passed to vector.copy()")
	return fast_new(v.x, v.y, v.z)
end

function vector.from_string(s, init)
	local x, y, z, np = string.match(s, "^%s*%(%s*([^%s,]+)%s*[,%s]%s*([^%s,]+)%s*[,%s]" ..
			"%s*([^%s,]+)%s*[,%s]?%s*%)()", init)
	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)
	if not (x and y and z) then
		return nil
	end
	return fast_new(x, y, z), np
end

function vector.to_string(v)
	return string.format("(%g, %g, %g)", v.x, v.y, v.z)
end
metatable.__tostring = vector.to_string

function vector.equals(a, b)
	return a.x == b.x and
	       a.y == b.y and
	       a.z == b.z
end
metatable.__eq = vector.equals

-- unary operations

function vector.length(v)
	return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
end
-- Note: we cannot use __len because it is already used for primitive table length

function vector.normalize(v)
	local len = vector.length(v)
	if len == 0 then
		return fast_new(0, 0, 0)
	else
		return vector.divide(v, len)
	end
end

function vector.floor(v)
	return vector.apply(v, math.floor)
end

function vector.round(v)
	return fast_new(
		math.round(v.x),
		math.round(v.y),
		math.round(v.z)
	)
end

function vector.apply(v, func)
	return fast_new(
		func(v.x),
		func(v.y),
		func(v.z)
	)
end

function vector.combine(a, b, func)
	return fast_new(
		func(a.x, b.x),
		func(a.y, b.y),
		func(a.z, b.z)
	)
end

function vector.distance(a, b)
	local x = a.x - b.x
	local y = a.y - b.y
	local z = a.z - b.z
	return math.sqrt(x * x + y * y + z * z)
end

function vector.direction(pos1, pos2)
	return vector.subtract(pos2, pos1):normalize()
end

function vector.angle(a, b)
	local dotp = vector.dot(a, b)
	local cp = vector.cross(a, b)
	local crossplen = vector.length(cp)
	return math.atan2(crossplen, dotp)
end

function vector.dot(a, b)
	return a.x * b.x + a.y * b.y + a.z * b.z
end

function vector.cross(a, b)
	return fast_new(
		a.y * b.z - a.z * b.y,
		a.z * b.x - a.x * b.z,
		a.x * b.y - a.y * b.x
	)
end

function metatable.__unm(v)
	return fast_new(-v.x, -v.y, -v.z)
end

-- add, sub, mul, div operations

function vector.add(a, b)
	if type(b) == "table" then
		return fast_new(
			a.x + b.x,
			a.y + b.y,
			a.z + b.z
		)
	else
		return fast_new(
			a.x + b,
			a.y + b,
			a.z + b
		)
	end
end
function metatable.__add(a, b)
	return fast_new(
		a.x + b.x,
		a.y + b.y,
		a.z + b.z
	)
end

function vector.subtract(a, b)
	if type(b) == "table" then
		return fast_new(
			a.x - b.x,
			a.y - b.y,
			a.z - b.z
		)
	else
		return fast_new(
			a.x - b,
			a.y - b,
			a.z - b
		)
	end
end
function metatable.__sub(a, b)
	return fast_new(
		a.x - b.x,
		a.y - b.y,
		a.z - b.z
	)
end

function vector.multiply(a, b)
	if type(b) == "table" then
		return fast_new(
			a.x * b.x,
			a.y * b.y,
			a.z * b.z
		)
	else
		return fast_new(
			a.x * b,
			a.y * b,
			a.z * b
		)
	end
end
function metatable.__mul(a, b)
	if type(a) == "table" then
		return fast_new(
			a.x * b,
			a.y * b,
			a.z * b
		)
	else
		return fast_new(
			a * b.x,
			a * b.y,
			a * b.z
		)
	end
end

function vector.divide(a, b)
	if type(b) == "table" then
		return fast_new(
			a.x / b.x,
			a.y / b.y,
			a.z / b.z
		)
	else
		return fast_new(
			a.x / b,
			a.y / b,
			a.z / b
		)
	end
end
function metatable.__div(a, b)
	-- scalar/vector makes no sense
	return fast_new(
		a.x / b,
		a.y / b,
		a.z / b
	)
end

-- misc stuff

function vector.offset(v, x, y, z)
	return fast_new(
		v.x + x,
		v.y + y,
		v.z + z
	)
end

function vector.sort(a, b)
	return fast_new(math.min(a.x, b.x), math.min(a.y, b.y), math.min(a.z, b.z)),
		fast_new(math.max(a.x, b.x), math.max(a.y, b.y), math.max(a.z, b.z))
end

function vector.check(v)
	return getmetatable(v) == metatable
end
