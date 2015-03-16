--Settings
scale = {}

local gameWidth = 360 --set game width
local gameHeight = 640 --set game height
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local xscale = math.min(screenWidth / gameWidth, screenHeight / gameHeight)
local yscale = xscale

local realWidth = gameWidth * xscale
local realHeight = gameHeight * yscale

local offsety = 0
local offsety = 0

offsetx, offsety = (screenWidth - realWidth) / 2,(screenHeight - realHeight)/2

--[[
print("game: " .. gameWidth .. ":" .. gameHeight)
print("screen: " .. screenWidth .. ":" .. screenHeight)
print("scale: " .. xscale .. ":" .. yscale)
print("real: " .. realWidth .. ":" .. realHeight)
print("offset: " .. offsetx .. ":" .. offsety)
]]--

function scale.first() --call this function before draw
	love.graphics.push()
	love.graphics.setScissor(offsetx, offsety, realWidth, realHeight)
	love.graphics.translate(offsetx, offsety)
	love.graphics.scale(xscale, yscale)
end

function scale.last() --call this function after draw
	love.graphics.setScissor()
	love.graphics.pop()
end

function scale.mousePosition(x, y) --convert real x/y axis to game x/y axis
	local clampedX,clampedY = math.min(math.max(x,offsetx),offsetx+realWidth), math.min(math.max(y,offsety),offsety+realHeight)
	return (clampedX - offsetx) / xscale, (clampedY - offsety) / yscale
end

function scale.getScale() --return current scale
	return xscale
end