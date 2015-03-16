enemybullet = {}

function enemybullet.init()
	local a
	for a = 1, #enemybullet do
		if enemybullet[a].enabled == true then
			enemybullet[a].enabled = false
		end
	end
	enemybullet.width = 8
	enemybullet.height = 8
	enemybullet.offsetx = 1
	enemybullet.offsety = 1
end

function enemybullet.new(x, y, bulletpattern, argv)
	--enemybullet.new(x, y, 1/2/3/4/5/6/7, {table, of arguments})
	local a
	local index
	
	index = #enemybullet + 1
	
	for a = 1, #enemybullet do
		if enemybullet[a].enabled == false then
			index = a
			break
		end
	end
	
	enemybullet[index] = {}
	enemybullet[index].x = x
	enemybullet[index].y = y
	enemybullet[index].bulletpattern = bulletpattern
	if bulletpattern == 1 then --no shoot
		
	elseif bulletpattern == 2 then --straight
		enemybullet[index].yvel = argv[1]
	elseif bulletpattern == 3 then --diagonal-two-way
		enemybullet[index].yvel = argv[1]
		enemybullet[index].xvel = argv[2]
	elseif bulletpattern == 4 then --circle
		enemybullet[index].yvel = argv[1]
		enemybullet[index].speed = argv[2]
		enemybullet[index].radius = argv[3]
		enemybullet[index].phase = argv[4]
		enemybullet[index].diay = argv[5]
		enemybullet[index].ox = argv[6]
		enemybullet[index].oy = argv[7]
	elseif bulletpattern == 5 then --homing
		enemybullet[index].yvel = argv[1]
		enemybullet[index].xvel = argv[2]
		enemybullet[index].accelation = argv[3]
	elseif bulletpattern == 6 then --player straight
		enemybullet[index].yvel = argv[1]
		enemybullet[index].xvel = argv[2]
	elseif bulletpattern == 7 then --eight direction
		enemybullet[index].yvel = argv[1]
		enemybullet[index].xvel = argv[2]
	end
	enemybullet[index].enabled = true
end

function enemybullet.update(dt)
	local a
	for a = 1, #enemybullet do
		if enemybullet[a].enabled == true then
			--move enemy bullet
			if enemybullet[a].bulletpattern == 1 then --no shooting
				enemybullet[a].enabled = false
			elseif enemybullet[a].bulletpattern == 2 then --straight
				enemybullet[a].y = enemybullet[a].y + enemybullet[a].yvel * dt
			elseif enemybullet[a].bulletpattern == 3 then --diagonal two way
				enemybullet[a].x = enemybullet[a].x + enemybullet[a].xvel * dt
				enemybullet[a].y = enemybullet[a].y + enemybullet[a].yvel * dt
			elseif enemybullet[a].bulletpattern == 4 then --circle
				enemybullet[a].y = enemybullet[a].y + enemybullet[a].yvel * dt
				
				enemybullet[a].phase = enemybullet[a].phase + dt * enemybullet[a].speed 
				enemybullet[a].diay = enemybullet[a].diay + 70 * dt
				
				enemybullet[a].x = enemybullet[a].radius * math.cos(enemybullet[a].phase) + enemybullet[a].ox
				enemybullet[a].y = enemybullet[a].radius * math.sin(enemybullet[a].phase) + enemybullet[a].oy + enemybullet[a].diay
			elseif enemybullet[a].bulletpattern == 5 then --homing
				enemybullet[a].x = enemybullet[a].x + enemybullet[a].xvel * dt
				enemybullet[a].y = enemybullet[a].y + enemybullet[a].yvel * dt
				--homing
				if enemybullet[a].y < player.y then
					if enemybullet[a].x > player.x + player.width then
						enemybullet[a].xvel = enemybullet[a].xvel - enemybullet[a].accelation * dt
						--maximum speed limit
						if math.abs(enemybullet[a].xvel) >= stage[game.stage].bxvelmax then
							enemybullet[a].xvel = stage[game.stage].bxvelmax * -1
						end
					elseif enemybullet[a].x < player.x then
						enemybullet[a].xvel = enemybullet[a].xvel + enemybullet[a].accelation * dt
						--maximum speed limit
						if math.abs(enemybullet[a].xvel) >= stage[game.stage].bxvelmax then
							enemybullet[a].xvel = stage[game.stage].bxvelmax
						end
					end
					
					
				end
			elseif enemybullet[a].bulletpattern == 6 then --player straight
				enemybullet[a].x = enemybullet[a].x + enemybullet[a].xvel * dt
				enemybullet[a].y = enemybullet[a].y + enemybullet[a].yvel * dt
			elseif enemybullet[a].bulletpattern == 7 then --eight direction
				enemybullet[a].x = enemybullet[a].x + enemybullet[a].xvel * dt
				enemybullet[a].y = enemybullet[a].y + enemybullet[a].yvel * dt
			end
			
			--collision with player
			if collision.aabb(enemybullet[a].x, enemybullet[a].y, enemybullet.width, enemybullet.height, player.x, player.y, player.width, player.height) then
				if player.immune == false then
					if not(player.state == "dead") then
						player.state = "dead"
						explosion.new(player.x - player.graphicoffsetx, player.y - player.graphicoffsety)
						--Fade out and FAIL
						scene.game.fadeout = true
						scene.game.fadereason = "fail"
					end
				end
			end
			
			
			if game.stage == 44 then
				if collision.aabb(enemybullet[a].x, enemybullet[a].y, enemybullet.width, enemybullet.height, 0, 0, 360, (640 - 64)) == false then
					enemybullet[a].enabled = false
				end
			else
				if enemybullet[a].y >= 640 then
					enemybullet[a].enabled = false
				end
			end
			if game.diffi == 2 then
				if enemybullet[a].y < -8 then
					enemybullet[a].enabled = false
				end
			end
			
		end
	end
end

function enemybullet.draw()
	local a
	for a = 1, #enemybullet do
		if enemybullet[a].enabled == true then
			love.graphics.draw(imgenemybullet, enemybullet[a].x - enemybullet.offsetx, enemybullet[a].y - enemybullet.offsety)
			if game.debug == true then
				love.graphics.setColor(0, 162, 232)
				love.graphics.rectangle("fill", enemybullet[a].x, enemybullet[a].y, enemybullet.width, enemybullet.height)
				love.graphics.setColor(255, 255, 255)
			end
		end
	end
end