enemy = {}

function enemy.datainit()
	--init enemy data
	enemy.colordata = {"black", "red", "green", "blue", "yellow", "brown", "gray", "magenta"}
	
	enemy["black"] = {}
	enemy["black"].width = 36
	enemy["black"].height = 36
	enemy["black"].graphicwidth = 48
	enemy["black"].graphicheight = 48
	enemy["black"].offsetx = 6
	enemy["black"].offsety = 6
	
	enemy["red"] = {}
	enemy["red"].width = 44
	enemy["red"].height = 44
	enemy["red"].graphicwidth = 48
	enemy["red"].graphicheight = 48
	enemy["red"].offsetx = 2
	enemy["red"].offsety = 2
	
	enemy["green"] = {}
	enemy["green"].width = 44
	enemy["green"].height = 44
	enemy["green"].graphicwidth = 48
	enemy["green"].graphicheight = 48
	enemy["green"].offsetx = 2
	enemy["green"].offsety = 2
	
	enemy["blue"] = {}
	enemy["blue"].width = 32
	enemy["blue"].height = 44
	enemy["blue"].graphicwidth = 48
	enemy["blue"].graphicheight = 48
	enemy["blue"].offsetx = 8
	enemy["blue"].offsety = 0
	
	enemy["yellow"] = {}
	enemy["yellow"].width = 44
	enemy["yellow"].height = 42
	enemy["yellow"].graphicwidth = 48
	enemy["yellow"].graphicheight = 48
	enemy["yellow"].offsetx = 2
	enemy["yellow"].offsety = 0
	
	enemy["brown"] = {}
	enemy["brown"].width = 48
	enemy["brown"].height = 48
	enemy["brown"].graphicwidth = 48
	enemy["brown"].graphicheight = 48
	enemy["brown"].offsetx = 0
	enemy["brown"].offsety = 0
	
	enemy["gray"] = {}
	enemy["gray"].width = 44
	enemy["gray"].height = 26
	enemy["gray"].graphicwidth = 48
	enemy["gray"].graphicheight = 48
	enemy["gray"].offsetx = 2
	enemy["gray"].offsety = 6
	
	enemy["magenta"] = {}
	enemy["magenta"].width = 48
	enemy["magenta"].height = 38
	enemy["magenta"].graphicwidth = 48
	enemy["magenta"].graphicheight = 48
	enemy["magenta"].offsetx = 0
	enemy["magenta"].offsety = 0
end

function enemy.init()
	local a
	for a = 1, #enemy do
		if enemy[a].enabled == true then
			enemy[a].enabled = false
		end
	end
	enemy.tmrdesroy = 0 + math.random()  * (1 - 0)
end

function enemy.new(x, y, color, movepattern, arg, bulletpattern, shootdelay)
	--make new enemy
	--how to use: enemy.new(x, y, "green", 1/2/3/4/5/6, {table, of, arguments})
	local a
	local index
	
	index = #enemy + 1
	
	for a = 1, #enemy do
		if enemy[a].enabled == false then
			index = a
			break
		end
	end
	
	enemy[index] = {}
	enemy[index].x = x
	enemy[index].y = y
	enemy[index].color = color --"black", "red", "green", "blue", "yellow", "brown", "gray", "magenta"
	enemy[index].movepattern = movepattern
	if movepattern == 1 then --straight
		enemy[index].yvel = arg[1]
	elseif movepattern == 2 then --diagonal
		enemy[index].yvel = arg[1]
		enemy[index].xvel = arg[2]
	elseif movepattern == 3 then --square wave
		enemy[index].yvel = arg[1]
		enemy[index].xvel = arg[2]
		enemy[index].xdistance = arg[3]
		enemy[index].ydistance = arg[4]
		enemy[index].moveamount = arg[5]
		enemy[index].sequence = arg[6]
	elseif movepattern == 4 then --triangle wave
		enemy[index].xvel = arg[1]
		enemy[index].yvel = arg[2]
		enemy[index].distance = arg[3]
		enemy[index].moveamount = arg[4]
	elseif movepattern == 5 then --sine wave
		enemy[index].yvel = arg[1]
		enemy[index].axis = arg[2]
		enemy[index].factor = arg[3]
		enemy[index].speed = arg[4]
		enemy[index].distance = arg[5]
	elseif movepattern == 6 then --recognize player
		enemy[index].xvel = arg[1]
		enemy[index].yvel = arg[2]
		enemy[index].distance = arg[3]
	end
	enemy[index].bulletpattern = bulletpattern
	enemy[index].shootdelay = shootdelay
	enemy[index].tmrshoot = math.random() * (shootdelay - 0)
	enemy[index].enabled = true
end

function enemy.update(dt)
	if not((player.victory == true) or (scene.game.fadereason == "half")) then
		--spawn enemy
		--set enemy information
		local x
		local y
		local color
		local movepattern
		local arg
		local bulletpattern = stage[game.stage].bulletpattern
		local targetfactor = 1
		if not(game.enemynum <= 0) then --spawn enemy only there is any unspawned enemy
			game.tmrspawn = game.tmrspawn - dt
			if game.tmrspawn <= 0 then
				game.tmrspawn = math.random(stage[game.stage].spawnmin, stage[game.stage].spawnmax) --random spawn delay
			 
				--set enemy target
				if game.enemynum == game.targetnum then --spawn target
					color = game.target
					targetfactor = 1.5
				else --spawn normal enemy
					color = game.enemylist[math.random(1, #game.enemylist)]
				end
				
				--set y
				y = 0 - enemy[color].graphicheight
				
				--set move pattern
				movepattern = stage[game.stage].movepattern
				
				arg = {}
				
				--set x and argv
				if movepattern == 1 then --straight
					x = math.random(0, 360 - enemy[color].graphicwidth)
					arg[1] = math.random(stage[game.stage].yvelmin, stage[game.stage].yvelmax) * targetfactor
					--target is 0.3times faster
				elseif movepattern == 2 then --diagonal
					x = math.random(0, 360 - enemy[color].graphicwidth)
					local startX = x
					local startY = y
					local endX = math.random(0, 360)
					local endY = 640
				   
					local angle = math.atan2((endY - startY), (endX - startX))
				   
					local velocity = math.random(stage[game.stage].yvelmin, stage[game.stage].yvelmax)
				   
					local Dx = velocity * math.cos(angle)
					local Dy = velocity * math.sin(angle)
					
					arg[1] = Dy * targetfactor
					arg[2] = Dx
				elseif movepattern == 3 then --square wave
					arg[1] = math.random(stage[game.stage].yvelmin, stage[game.stage].yvelmax) * targetfactor
					arg[2] = arg[1]
					arg[3] = math.random(stage[game.stage].xdistancemin, stage[game.stage].xdistancemax)
					arg[4] = math.random(stage[game.stage].ydistancemin, stage[game.stage].ydistancemax)
					arg[5] = 0
					local rnd
					local seq
					rnd = math.random(1, 2)
					if rnd == 1 then
						seq = 1
					else
						seq = 3
					end
					arg[6] = seq
					x = math.random(arg[3], 360 - arg[3] - enemy[color].graphicwidth)
				elseif movepattern == 4 then --triangle wave
					local rnd
					local xv
					rnd = math.random(1, 2)
					if rnd == 1 then
						xv = 1
					else
						xv = -1
					end
					arg[1] = math.random(stage[game.stage].xvelmin, stage[game.stage].xvelmax) * xv * targetfactor
					arg[2] = math.random(stage[game.stage].yvelmin, stage[game.stage].yvelmax) * targetfactor
					arg[3] = math.random(stage[game.stage].distancemin, stage[game.stage].distancemax)
					arg[4] = 0
					x = math.random(arg[3], 360 - arg[3] - enemy[color].graphicwidth)
				elseif movepattern == 5 then --sine wave
					arg[1] = math.random(stage[game.stage].yvelmin, stage[game.stage].yvelmax) * targetfactor
					local rnd
					rnd = math.random(0, 1)
					arg[3] = rnd * 3.14
					arg[4] = math.random(stage[game.stage].speedmin, stage[game.stage].speedmax)
					arg[5] = math.random(stage[game.stage].distancemin, stage[game.stage].distancemax)
					arg[2] = math.random(arg[5], 360 - arg[5] - enemy[color].graphicwidth)
					x = 0
				elseif movepattern == 6 then --recognize player
					arg[1] = math.random(stage[game.stage].xvelmin, stage[game.stage].xvelmax) * targetfactor
					arg[2] = math.random(stage[game.stage].yvelmin, stage[game.stage].yvelmax) * targetfactor
					arg[3] =  math.random(stage[game.stage].distancemin, stage[game.stage].distancemax)
					x = math.random(arg[3], 360 - arg[3] - enemy[color].graphicwidth)
				end
				
				local shootdelay
				shootdelay = math.random(stage[game.stage].shootdelaymin, stage[game.stage].shootdelaymax)
				enemy.new(x, y, color, movepattern, arg, bulletpattern, shootdelay)
				game.enemynum = game.enemynum - 1
				
				--spawn 1up
				local a
				local i
				for a ,i in pairs(stage.itemlist) do
					if i == game.stage then
						if game.enemynum == game.lifeupnum then
							local rand = math.random(1, 2)
							if rand == 1 then
								lifeup.new(-40, 500, "right")
							else
								lifeup.new(360, 500, "left")
							end
							se.play("1up_appear")
							table.remove (stage.itemlist, a)
						end
						break
					end
				end
				
			end
		end
	
		local a
		for a = 1, #enemy do
			if(enemy[a].enabled == true) then
				--move enemy
				if enemy[a].movepattern == 1 then --straight
					enemy[a].y = enemy[a].y + enemy[a].yvel * dt
				elseif enemy[a].movepattern == 2 then --diagonal
					enemy[a].y = enemy[a].y + enemy[a].yvel * dt
					enemy[a].x = enemy[a].x + enemy[a].xvel * dt
				elseif enemy[a].movepattern == 3 then --square wave
					if enemy[a].sequence == 1 then --go down
						enemy[a].y = enemy[a].y + enemy[a].yvel * dt
						enemy[a].moveamount = enemy[a].moveamount + math.abs(enemy[a].yvel * dt)
						if enemy[a].moveamount >= enemy[a].ydistance then
							enemy[a].moveamount = 0
							enemy[a].sequence = 2
						end
					elseif enemy[a].sequence == 2 then --go right
						enemy[a].x = enemy[a].x + enemy[a].xvel * dt
						enemy[a].moveamount = enemy[a].moveamount + math.abs(enemy[a].xvel * dt)
						if enemy[a].moveamount >= enemy[a].xdistance then
							enemy[a].moveamount = 0
							enemy[a].sequence = 3
						end
					elseif enemy[a].sequence == 3 then --go down
						enemy[a].y = enemy[a].y + enemy[a].yvel * dt
						enemy[a].moveamount = enemy[a].moveamount + math.abs(enemy[a].yvel * dt)
						if enemy[a].moveamount >= enemy[a].ydistance then
							enemy[a].moveamount = 0
							enemy[a].sequence = 4
						end
					elseif enemy[a].sequence == 4 then --go left
						enemy[a].x = enemy[a].x - enemy[a].xvel * dt
						enemy[a].moveamount = enemy[a].moveamount + math.abs(enemy[a].xvel * dt)
						if enemy[a].moveamount >= enemy[a].xdistance then
							enemy[a].moveamount = 0
							enemy[a].sequence = 1
						end
					end
				elseif enemy[a].movepattern == 4 then --triangle wave
					enemy[a].y = enemy[a].y + enemy[a].yvel * dt
					enemy[a].x = enemy[a].x + enemy[a].xvel * dt
					enemy[a].moveamount = enemy[a].moveamount + math.abs(enemy[a].xvel * dt)
					if enemy[a].moveamount >= enemy[a].distance then
						enemy[a].moveamount = 0
						enemy[a].xvel = enemy[a].xvel * -1
					end
				elseif enemy[a].movepattern == 5 then --sine wave
					enemy[a].y = enemy[a].y + enemy[a].yvel * dt
					enemy[a].factor = enemy[a].factor + dt * enemy[a].speed
					enemy[a].x = enemy[a].axis + math.sin(enemy[a].factor) * enemy[a].distance
				elseif enemy[a].movepattern == 6 then --recognize player
					enemy[a].y = enemy[a].y + enemy[a].yvel * dt
					
					if enemy[a].color == stage[game.stage].target then
						--target will avoid player
						if math.abs(enemy[a].x - player.x) < enemy[a].distance then
							if (20 < enemy[a].x + enemy[a].xvel * dt) and (enemy[a].x + enemy[a].xvel * dt < 360 - enemy[enemy[a].color].width - 20) then
								enemy[a].x = enemy[a].x + enemy[a].xvel * dt
							else
								enemy[a].xvel = -enemy[a].xvel
							end
						end
					else
						--non-target will go to player
						if enemy[a].x > player.x + player.width then
							enemy[a].xvel = math.abs(enemy[a].xvel) * -1
						elseif enemy[a].x < player.x - 20 then
							enemy[a].xvel = math.abs(enemy[a].xvel)
						end
						enemy[a].x = enemy[a].x + enemy[a].xvel * dt
					end
				end
				
				--collision with player
				if collision.aabb(enemy[a].x, enemy[a].y, enemy[enemy[a].color].width, enemy[enemy[a].color].height, player.x, player.y, player.width, player.height) then
					if player.immune == false then
						if not(player.state == "dead") then
							player.state = "dead"
							explosion.new(player.x - player.graphicoffsetx, player.y - player.graphicoffsety)
							if enemy[a].color == stage[game.stage].target then
								--achievement: Charrrge!
								if game.mobile == false then
									achievementSystem:UnlockAchievement("charge")
								end
								scene.game.fadeout = true
								scene.game.fadereason = "half"
							else
								--Fade out and FAIL
								scene.game.fadeout = true
								scene.game.fadereason = "fail"
							end
							enemy[a].enabled = false
							explosion.new(enemy[a].x, enemy[a].y)
						end
					end
				end
				
				if enemy[a].y >= (640 - 64) then
					--if target is out of screen
					enemy[a].enabled = false
					if enemy[a].color == stage[game.stage].target then
						--Fade out and FAIL
						scene.game.fadeout = true
						scene.game.fadereason = "fail"
					end
				end
			end
		end
	
		--enemy shooting
		for a = 1, #enemy do
			if enemy[a].enabled == true then
				if not(enemy[a].bulletpattern == 1) then
					enemy[a].tmrshoot = enemy[a].tmrshoot + dt
					if enemy[a].tmrshoot >= enemy[a].shootdelay then
						enemy[a].tmrshoot = enemy[a].tmrshoot - enemy[a].shootdelay
						--set bullet information
						local x
						local y
						local ydirection = 1
						if game.diffi == 2 then
							if player.y > enemy[a].y then
								ydirection = 1
							else
								ydirection = -1
							end
						end
							
						y = enemy[a].y + enemy[enemy[a].color].graphicheight - enemybullet.height
						x = enemy[a].x + enemy[enemy[a].color].width / 2 - enemybullet.width / 2
						
						local yvel
						local argv = {}
						if bulletpattern == 2 then --straight
							argv[1] = math.random(stage[game.stage].byvelmin, stage[game.stage].byvelmax) * ydirection
							enemybullet.new(x, y, bulletpattern, argv)
						elseif bulletpattern == 3 then --diagonal-two-way
							argv[1] = math.random(stage[game.stage].byvelmin, stage[game.stage].byvelmax) * ydirection
							argv[2] = math.random(stage[game.stage].bxvelmin, stage[game.stage].bxvelmax)
							enemybullet.new(x, y, bulletpattern, argv)
							argv[2] = argv[2] * -1
							enemybullet.new(x, y, bulletpattern, argv)
						elseif bulletpattern == 4 then --circle
							argv[1] = math.random(stage[game.stage].byvelmin, stage[game.stage].byvelmax) * ydirection
							argv[2] = math.random(stage[game.stage].bspeedmin, stage[game.stage].bspeedmax)
							argv[3] = math.random(stage[game.stage].bradiusmin, stage[game.stage].bradiusmax)
							argv[4] = 4.73
							argv[5] = 0
							argv[6] = x
							argv[7] = y + argv[3]
							enemybullet.new(x, y, bulletpattern, argv)
						elseif bulletpattern == 5 then --homing
							argv[1] = math.random(stage[game.stage].byvelmin, stage[game.stage].byvelmax) * ydirection
							argv[2] = 0
							argv[3] = stage[game.stage].bacclation
							enemybullet.new(x, y, bulletpattern, argv)
						elseif bulletpattern == 6 then --player straight
							local angle = math.atan2((player.x + player.width / 2 - x), (player.y + player.height / 2 - y))
							local bulletSpeed = math.random(stage[game.stage].bvelocitymin, stage[game.stage].bvelocitymax)
							local bulletDx
							local bulletDy
							bulletDx = bulletSpeed * math.cos(angle)
							bulletDy = bulletSpeed * math.sin(angle)
							
							argv[1] = bulletDx
							argv[2] = bulletDy
							
							enemybullet.new(x, y, bulletpattern, argv)
						elseif bulletpattern == 7 then --eight direction
							local bvelocity
							bvelocity = math.random(stage[game.stage].bvelocitymin, stage[game.stage].bvelocitymax)
							argv[1] = bvelocity
							argv[2] = bvelocity
							enemybullet.new(x, y, bulletpattern, argv) --downright
							
							argv[1] = bvelocity
							argv[2] = bvelocity * -1
							enemybullet.new(x, y, bulletpattern, argv) --downleft
							
							argv[1] = bvelocity * -1
							argv[2] = bvelocity * -1
							enemybullet.new(x, y, bulletpattern, argv) --upleft
							
							argv[1] = bvelocity * -1
							argv[2] = bvelocity
							enemybullet.new(x, y, bulletpattern, argv) --upright
							
							argv[1] = bvelocity * -1
							argv[2] = 0
							enemybullet.new(x, y, bulletpattern, argv) --up
							
							argv[1] = bvelocity
							argv[2] = 0
							enemybullet.new(x, y, bulletpattern, argv) --down
							
							argv[1] = 0
							argv[2] = bvelocity * -1
							enemybullet.new(x, y, bulletpattern, argv) --left
							
							argv[1] = 0
							argv[2] = bvelocity
							enemybullet.new(x, y, bulletpattern, argv) --right
						end
					end
				end
			end
		end
	else
		--target is dead, destory random enemy
		enemy.tmrdesroy = enemy.tmrdesroy - dt
		if enemy.tmrdesroy <= 0 then
			local a
			a = math.random(1, #enemy)
			if enemy[a].enabled == true then
				enemy[a].enabled = false
				explosion.new(enemy[a].x, enemy[a].y)
				enemy.tmrdesroy = 0 + math.random()  * (0.3 - 0)
			end
		end
	end
end

function enemy.draw()
	--draw enemy
	local a
	
	local r
	local g
	local b
	for a = 1, #enemy do
		if enemy[a].enabled == true then
			love.graphics.draw(imgenemy, quadenemy[enemy[a].color], enemy[a].x - enemy[enemy[a].color].offsetx, enemy[a].y - enemy[enemy[a].color].offsety)
			if game.debug == true then
				love.graphics.setColor(0, 162, 232)
				love.graphics.rectangle("fill", enemy[a].x, enemy[a].y, enemy[enemy[a].color].width, enemy[enemy[a].color].height)
				love.graphics.setColor(255, 255, 255)
			end
		end
	end
end