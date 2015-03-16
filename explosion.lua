explosion = {}

function explosion.init()
	local a
	for a = 1, #explosion do
		explosion[a].enabled = false
	end
end

function explosion.new(x, y)
	local a
	local index
	
	index = #explosion + 1
	
	for a = 1, #explosion do
		if explosion[a].enabled == false then
			index = a
			break
		end
	end
	
	explosion[index] = {}
	explosion[index].x = x
	explosion[index].y = y
	explosion[index].timer = 0
	explosion[index].sequence = 1
	explosion[index].enabled = true
	
	se.play("explosion")
end

function explosion.update(dt)
	local a
	for a = 1, #explosion do
		if explosion[a].enabled == true then
			explosion[a].timer = explosion[a].timer + dt
			if explosion[a].timer >= 0.07 then
				explosion[a].timer = explosion[a].timer - 0.07
				if explosion[a].sequence == 4 then
					explosion[a].enabled = false
				else
					explosion[a].sequence = explosion[a].sequence + 1
				end
			end
		end
	end
end

function explosion.draw()
	local a
	for a = 1, #explosion do
		if explosion[a].enabled == true then
			love.graphics.draw(imgexplosion, quadexplosion[explosion[a].sequence], explosion[a].x, explosion[a].y)
		end
	end
end