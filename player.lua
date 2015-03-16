player = {}

function player.init()
	player.width = 16
	player.height = 28
	player.graphicwidth = 48
	player.graphicheight = 48
	player.graphicoffsetx = 16
	player.graphicoffsety = 14
	player.speed = 325
	if game.diffi == 1 then
		player.bullettimemax = 5
	elseif game.diffi == 2 then
		player.bullettimemax = 2.5
	end
	player.bullettime = player.bullettimemax
	player.appearing = true
	player.state = "center"
	player.immune = false
	player.victory = false
	player.accel = 0
	player.aura = 0
	player.tmraura = 0
	player.shooted = false
	
	player.x = 360 / 2 - player.width / 2
	player.y = (640 - 64) - player.height - player.graphicoffsety - 10 + 100
end

function player.update(dt)
	if player.victory == false then
		if not(player.state == "dead") then
			player.state = "center"
			if player.appearing == false then
				if love.keyboard.isDown(game.keyup) then
					player.move("up", player.speed * dt)
				end
				if love.keyboard.isDown(game.keydown) then
					player.move("down", player.speed * dt)
				end
				if love.keyboard.isDown(game.keyleft) then
					player.state = "left"
					player.move("left", player.speed * dt)
				end
				if love.keyboard.isDown(game.keyright) then
					player.state = "right"
					player.move("right", player.speed * dt)
				end
				--move by dragging
				if scene.game.dragging.active == true then
					local touchx
					local touchy
					local a
					for a = 1, love.touch.getTouchCount() do
						local id, x, y, pressure = love.touch.getTouch(a)
						if id == scene.game.dragging.id then
							touchx = x * 360
							touchy = y * 640
							--touchx, touchy = scale.mousePosition(touchx, touchy)
							break
						end
					end
					local diff = touchx - scene.game.dragging.diffx - player.x
					if diff < 0 then
						player.state = "left"
					elseif diff > 0 then
						player.state = "right"
					end
					
					player.x = touchx - scene.game.dragging.diffx
					player.y = touchy - scene.game.dragging.diffy
					
					player.move("up", 0)
					player.move("down", 0)
					player.move("left", 0)
					player.move("right", 0)
				end
				if love.keyboard.isDown(game.keyb) then
					--shoot
					if player.shooted == false then
						if playershoot.enabled == false then
							if game.stage < 43 then
								--common stage
								playershoot.new()
								player.shooted = true
							else
								if boss.state == "active" then
									playershoot.new()
									player.shooted = true
								end
							end
						end
					end
				end
				--bullet time: see scene.game.update(dt)
			else
				player.y = player.y - 150 * dt
				if player.y <= (640 - 64) - player.height - player.graphicoffsety - 10 then
					player.y = (640 - 64) - player.height - player.graphicoffsety - 10
					player.appearing = false
				end
			end
		else
		
		end
	else
		player.accel = player.accel + 800 * dt
		player.y = player.y - (player.speed + player.accel) * dt
		if player.y <= -50 then
			scene.game.fadeout = true
			scene.game.fadereason = "success"
		end
	end
	
	if not(player.aura == 0) then
		player.tmraura = player.tmraura + dt
		if player.tmraura >= 0.04 then
			player.tmraura = player.tmraura - 0.04
			if player.aura == 1 then
				player.aura = 2
			elseif player.aura == 2 then
				player.aura = 3
			elseif player.aura == 3 then
				player.aura = 4
			elseif player.aura == 4 then
				player.aura = 3
			end
		end
	end
end

function player.move(direction, speed)
	local fakex
	local fakey
	
	fakex = player.x
	fakey = player.y
	
	if direction == "up" then
		if fakey <= 0  + player.graphicoffsety then
			fakey = 0 + player.graphicoffsety
		else
			fakey = fakey - speed
		end
	elseif direction == "down" then
		if fakey >= (640 - 64) - player.graphicheight + player.graphicoffsety then
			fakey = (640 - 64) - player.graphicheight + player.graphicoffsety
		else
			fakey = fakey + speed
		end
	elseif direction == "left" then
		if fakex <= 0 + player.graphicoffsetx then
			fakex = 0 + player.graphicoffsetx
		else
			fakex = fakex - speed
		end
	elseif direction == "right" then
		if fakex >= 360 - player.graphicwidth + player.graphicoffsetx then
			fakex = 360 - player.graphicwidth + player.graphicoffsetx
		else
			fakex = fakex + speed
		end
	end
	
	player.x = fakex
	player.y = fakey
end

function player.draw()
	love.graphics.setColor(255, 255, 255)
	if not(player.state == "dead") then
		--draw aura
		if not(player.aura == 0) then
			love.graphics.draw(imgaura, quadaura[player.aura], player.x - player.graphicoffsetx - 6, player.y - player.graphicoffsety - 6)
		end
		
		--draw player
		if game.trashmode == true then
			love.graphics.draw(imgtrash, quadplayer[player.state], player.x - player.graphicoffsetx, player.y - player.graphicoffsety)
		else
			love.graphics.draw(imgplayer, quadplayer[player.state], player.x - player.graphicoffsetx, player.y - player.graphicoffsety)
		end
	end
	if game.debug == true then
		love.graphics.setColor(0, 162, 232)
		love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
		love.graphics.setColor(255, 255, 255)
	end
end