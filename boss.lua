boss = {}
boss = {}
boss.bullet = {}
boss.funnel = {}

function boss.init()
	if game.stage < 43 then
		return
	end
	
	if game.stage == 43 then
		boss.midbossinit()
		
	elseif game.stage == 44 then
		boss.finbossinit()
		
	end
	
	boss.bullet.init()
	
	message.new("destroy the core")
end

function boss.midbossinit()
	--mid boss
	boss.width = 144
	boss.height = 144
	boss.coreoffsetx = 57
	boss.coreoffsety = 49
	boss.corewidth = 30
	boss.coreheight = 95
	boss.barrierx = 44
	boss.barriery = 144
	boss.barrierwidth = 56
	boss.barrierheight = 14
	
	boss.barrierstate = 1 --1/2/3/4, guard only 1
	boss.tmrbarrier = 2 --barrier toggle timer
	boss.barrierturn = "none" --on/off/none
	boss.tmrbarrierturn = 0
	
	boss.tmrspawnside = 0.3 + math.random() * (2 - 0.3)
	boss.tmrspawncore = 2 + math.random()  * (4 - 2)
	
	boss.speed = 80
	boss.state = "appearing" --appearing / active / dead
	
	boss.x = 320 / 2 - boss.width / 3
	boss.y = 0 - boss.height - 100
	
	boss.explosionpoint =  {{54, 57}, 
							{15, 23}, 
							{117, 22}, 
							{90, 105}, 
							{24, -15}, 
							{-23, 91},
							"end"}
	boss.explosionindex = 0
	boss.explosiontmr = 0
	
	--boss bullet
	if game.diffi == 1 then
		boss.bullet.speed = 200
	elseif game.diffi == 1 then
		boss.bullet.speed = 300
	end
	boss.bullet.width = 8
	boss.bullet.height = 8
	boss.bullet.offsetx = 1
	boss.bullet.offsety = 1
	
	local rnd
	rnd = math.random(1, 2)
	if rnd == 1 then
		boss.direction = "left"
		boss.moveamount = 100
	else
		boss.direction = "right"
		boss.moveamount = 100
	end
end

function boss.finbossinit()
	--final boss
		boss.width = 240
		boss.height = 144
		boss.speed = 80
		
		boss.x = 360 / 2 - boss.width / 2
		boss.y = 0 - boss.height - 40
		
		boss.mouthx = 100
		boss.mouthy = 121
		boss.mouthstate = 1 --1/2/3, guard only 1
		
		boss.state = "appearing" --appearing / active / dead
		
		boss.laserstate = 1 --1/2/3/4 no/little/thick/attack
		boss.laserflash = false --toggle false/true
		boss.laserturn = "none" --on/off/none
		boss.tmrlaserturn =  2 + math.random()  * (5 - 2) --laser shooting delay
		boss.tmrlaser = 0 --toggle laserstate 1/2/3/4
		boss.tmrflash = 0
		
		boss.destroyed = false --boss core destroyed?
		
		--boss bullet
		boss.bullet.speed = 200
		boss.bullet.width = 8
		boss.bullet.height = 8
		boss.bullet.offsetx = 1
		boss.bullet.offsety = 1
		
		boss.explosionpoint = {{100, 112},
							  {137, 46},
							  {-7, 102},
						  	  {50, 18},
							  {95, 64},
							  "end"}
		boss.explosionindex = 0
		boss.explosiontmr = 0
		
		boss.tmrfunnel = 0.3 + math.random()  * (2 - 0.3)
		boss.funnel.init()
end

function boss.update(dt)
	if game.stage < 43 then
		return
	end
	
	if game.stage == 43 then
		boss.midbossupdate(dt)
		
	elseif game.stage == 44 then
		boss.finbossupdate(dt)
	end
	
	--update bullets
	boss.bullet.update(dt)
end

function boss.midbossupdate(dt)
	--mid boss
	--appear
	if boss.state ==  "appearing" then
		boss.y = boss.y + boss.speed * dt
		if boss.y >= 30 then
			boss.y = 30
			boss.state = "active"
		end
	end
	
	--move left/right
	if boss.state == "active" then
		if boss.direction == "left" then
			boss.x = boss.x - boss.speed * dt
		elseif boss.direction == "right" then
			boss.x = boss.x + boss.speed * dt
		end
		boss.moveamount = boss.moveamount - boss.speed * dt
		if boss.moveamount <= 0 then
			if boss.direction == "left" then
				boss.direction = "right"
				boss.moveamount = 200
			elseif boss.direction == "right" then
				boss.direction = "left"
				boss.moveamount = 200
			end
		end
	end
	
	--spawn bullet from core
	if boss.state == "active" then
		boss.tmrspawncore = boss.tmrspawncore - dt
		if boss.tmrspawncore <= 0 then
			boss.tmrspawncore = 2 + math.random()  * (4 - 2)
			--spawn bullet
			--shoot to player
			local x, y = boss.x + 67, boss.y + 88
			local xvel, yvel = collision.getXYvelocityWithPoints(x, y, player.x + player.width / 2, player.y + player.height / 2, 300)
			boss.bullet.new(x, y, xvel, yvel, false)
		end
	end
	
	--spawn bullet from left/right
	if boss.state == "active" then
		boss.tmrspawnside = boss.tmrspawnside - dt
		if boss.tmrspawnside <= 0 then
			boss.tmrspawnside = 0.1 + math.random() * (1 - 0.1)
			--spawn bullet
			local x = boss.x + 15
			local y = boss.y + 126
			local xvel = 0
			local yvel = boss.bullet.speed
			boss.bullet.new(x, y, xvel, yvel, false)
			
			local x = boss.x + 119
			local y = boss.y + 126
			local xvel = 0
			local yvel = boss.bullet.speed
			boss.bullet.new(x, y, xvel, yvel, false)
		end
	end
	
	--toggle barrier
	if boss.state == "active" then
		boss.tmrbarrier = boss.tmrbarrier - dt
		if boss.tmrbarrier <= 0 then
			boss.tmrbarrier = 1 + math.random()  * (3 - 1);
			if boss.barrierstate == 1 then
				boss.barrierturn = "off"
			elseif boss.barrierstate == 4 then
				boss.barrierturn = "on"
			end
		end
	end
	
	--trun on/off barrier
	if boss.state == "active" then
		if not(boss.barrierturn == "none") then
			boss.tmrbarrierturn = boss.tmrbarrierturn + dt
			if boss.tmrbarrierturn >= 0.1 then
				boss.tmrbarrierturn = boss.tmrbarrierturn - 0.1
				if boss.barrierturn == "on" then
					--turn on the barrier
					if boss.barrierstate == 1 then
						boss.tmrbarrierturn = 0
						boss.barrierturn = "none"
					else
						boss.barrierstate = boss.barrierstate - 1
					end
				else
					--turn off the barrier
					if boss.barrierstate == 4 then
						boss.tmrbarrierturn = 0
						boss.barrierturn = "none"
					else
						boss.barrierstate = boss.barrierstate + 1
					end
				end
			end
		end
	end
	
	--collision detection
	--boss-player
	if not(boss.state == "dead") then
		if collision.aabb(player.x, player.y, player.width, player.height, boss.x, boss.y, boss.width, boss.height) then
			--fail
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
	end
	
	--barrier-player bullet
	if boss.state == "active" then
		if playershoot.enabled == true then
			if boss.barrierstate == 1 then
				if collision.aabb(playershoot.x, playershoot.y, playershoot.width, playershoot.height, boss.x + boss.barrierx, boss.y + boss.barriery, boss.barrierwidth, boss.barrierheight) then
					--fail
					playershoot.enabled = false
					explosion.new(playershoot.x - 20, playershoot.y - 20)
					--Fade out and FAIL
					scene.game.fadeout = true
					scene.game.fadereason = "fail"
				end
			end
		end
	end
	
	--core-player bullet
	if boss.state == "active" then
		if playershoot.enabled == true then
			if collision.aabb(playershoot.x, playershoot.y, playershoot.width, playershoot.height, boss.x + boss.coreoffsetx, boss.y + boss.coreoffsety, boss.corewidth, boss.coreheight) then
				--success
				explosion.new(playershoot.x - 20, playershoot.y - 20)
				
				boss.state = "dead"
				playershoot.enabled = false
				player.immune = true
				if scene.game.fadereason == "fail" then
					--achievement: C-Cross counter?!
					if game.mobile == false then
						achievementSystem:UnlockAchievement("crosscounter")
					end
					scene.game.fadereason = "half"
				else
					player.state = "center"
				end
				
				if game.mobile == false then
					achievementSystem:UnlockAchievement("cry")
				end
			end
		end
	end
	
	--boss-player bullet
	if boss.state == "active" then
		if playershoot.enabled == true then
			if collision.aabb(playershoot.x, playershoot.y, playershoot.width, playershoot.height, boss.x, boss.y, boss.width, boss.height) then
				--fail
				playershoot.enabled = false
				explosion.new(playershoot.x - 20, playershoot.y - 20)
				--Fade out and FAIL
				scene.game.fadeout = true
				scene.game.fadereason = "fail"
			end
		end
	end
	
	--explosion
	if boss.state == "dead" then
		boss.explosiontmr = boss.explosiontmr + dt
		if boss.explosiontmr >= 0.2 then
			boss.explosiontmr = boss.explosiontmr - 0.2
			if not(boss.explosionpoint[boss.explosionindex + 1] == "end") then
				boss.explosionindex = boss.explosionindex + 1
				explosion.new(boss.x + boss.explosionpoint[boss.explosionindex][1], boss.y + boss.explosionpoint[boss.explosionindex][2])
			else
				if not(player.victory == true) then
					player.victory = true
					se.play("plane_fly")
				end
			end
		end
		
		boss.y = boss.y + boss.speed * dt
	end
end

function boss.finbossupdate(dt)
	--final boss
	--appear
	if boss.state == "appearing" then
		boss.y = boss.y + boss.speed * dt
		if boss.y >= 0 then
			boss.y = 0
			boss.state = "active"
		end
	end
	
	--toggle laser
	if boss.destroyed == false then
		if boss.state == "active" then
			boss.tmrlaserturn = boss.tmrlaserturn - dt
			if boss.tmrlaserturn <= 0 then
				boss.tmrlaserturn = 2 + math.random()  * (5 - 2)
				if boss.laserstate == 4 then
					boss.laserturn = "off"
				else
					boss.laserturn = "on"
				end
			end
		end
	end
	
	--turn on/off laser
	if boss.state == "active" then
		boss.tmrlaser = boss.tmrlaser + dt
		if boss.tmrlaser >= 0.15 then
			boss.tmrlaser = boss.tmrlaser - 0.15
			if boss.laserturn == "on" then
				if boss.mouthstate == 1 then
					boss.mouthstate = 2
				elseif boss.mouthstate == 2 then
					boss.mouthstate = 3
				elseif boss.mouthstate == 3 then
					if boss.laserstate == 1 then
						boss.laserstate = 2
					elseif boss.laserstate == 2 then
						boss.laserstate = 3
					elseif boss.laserstate == 3 then
						boss.laserstate = 4
					elseif boss.laserstate == 4 then
						boss.laserturn = "none"
						se.play("laser")
					end
				end
			elseif boss.laserturn == "off" then
				if boss.laserstate == 4 then
					boss.laserstate = 3
				elseif boss.laserstate == 3 then
					boss.laserstate = 2
				elseif boss.laserstate == 2 then
					boss.laserstate = 1
				elseif boss.laserstate == 1 then
					if boss.mouthstate == 3 then
						boss.mouthstate = 2
					elseif boss.mouthstate == 2 then
						boss.mouthstate = 1
					elseif boss.mouthstate == 1 then
						boss.laserturn = "none"
					end
				end
			end
		end
	end
	
	--flash laser
	if boss.state == "active" then
		if boss.laserstate == 4 then
			boss.tmrflash = boss.tmrflash + dt
			if boss.tmrflash >= 0.1 then
				boss.tmrflash = boss.tmrflash - 0.1
				if boss.laserflash == true then
					boss.laserflash = false
				else
					boss.laserflash = true
				end
			end
		end
	end
	
	--make funnel
	if boss.state == "active" then
		boss.tmrfunnel = boss.tmrfunnel - dt
		if boss.tmrfunnel <= 0 then
			boss.tmrfunnel = 0.3 + math.random()  * (2 - 0.3)
			local sector = math.random(1, 6)
			local x
			local y
			if sector == 1 then
				x = math.random(0, 97)
				y = math.random(149, 333)
			elseif sector == 2 then
				x = math.random(0, 97)
				y = math.random(334, 504)
			elseif sector == 3 then
				x = math.random(0, 179)
				y = math.random(505, 574 - 30)
			elseif sector == 4 then
				x = math.random(180, 359 - 30)
				y = math.random(505, 574 - 30)
			elseif sector == 5 then
				x = math.random(262, 359 - 30)
				y = math.random(334, 504 - 30)
			elseif sector == 6 then
				x = math.random(262, 359 - 30)
				y = math.random(149, 333 - 30)
			end
			boss.funnel.new(165, 90, {{165, 140}, { math.random(0, 330), math.random(190, 546) }, { x, y }, "shoot", {"wait", 0.5}, { 165, 90 }, "end" })
		end
	end
	
	--update funnel
	if boss.state == "active" then
		boss.funnel.update(dt)
	end
	
	--collision detection
	--core-player (core destroyed)
	if boss.state == "active" then
		if boss.destroyed == true then
			if collision.aabb(boss.x + boss.mouthx, boss.y + boss.mouthy, 40, 23, player.x, player.y, player.width, player.height) then
				explosion.new(player.x - player.graphicoffsetx, player.y - player.graphicoffsety)
				--success
				player.aura = 0
				boss.state = "dead"
				player.immune = true
				if scene.game.fadereason == "fail" then
					--achievement: C-Cross counter?!
					if game.mobile == false then
						achievementSystem:UnlockAchievement("crosscounter")
					end
					scene.game.fadereason = "half"
				else
					player.state = "center"
				end
				
				if game.mobile == false then
					achievementSystem:UnlockAchievement("last")
				end
			end
		end
	end
	
	--boss-player
	if not(boss.state == "dead") then
		if collision.aabb(player.x, player.y, player.width, player.height, boss.x, boss.y, boss.width, boss.height) then
			--fail
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
	end
	
	--laser-player
	if boss.state == "active" then
		if boss.laserstate == 4 then
			if collision.aabb(player.x, player.y, player.width, player.height, boss.x + 119 - 6, boss.y + 132, 2 + 12, 443) then
				--fail
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
		end
	end
	
	--core-player bullet
	if boss.state == "active" then
		if playershoot.enabled == true then
			if not(boss.mouthstate == 1) then
				if collision.aabb(boss.x + boss.mouthx, boss.y + boss.mouthy, 40, 23, playershoot.x, playershoot.y, playershoot.width, playershoot.height) then
					--success
					explosion.new(playershoot.x - 20, playershoot.y - 20)
					boss.destroyed = true
					boss.laserstate = 1
					boss.laserturn = "none"
					boss.mouthstate = 3
					player.aura = 1
					playershoot.enabled = false
					message.new("charge into the enemy core")
					boss.funnel.destroy()
				end
			end
		end
	end
	
	--boss-player bullet
	if boss.state == "active" then
		if playershoot.enabled == true then
			if collision.aabb(boss.x, boss.y, boss.width, boss.height, playershoot.x, playershoot.y, playershoot.width, playershoot.height) then
				--fail
				playershoot.enabled = false
				explosion.new(playershoot.x - 20, playershoot.y - 20)
				--Fade out and FAIL
				scene.game.fadeout = true
				scene.game.fadereason = "fail"
			end
		end
	end
	
	if boss.state == "dead" then
		boss.explosiontmr = boss.explosiontmr + dt
		if boss.explosiontmr >= 0.2 then
			boss.explosiontmr = boss.explosiontmr - 0.2
			if not(boss.explosionpoint[boss.explosionindex + 1] == "end") then
				boss.explosionindex = boss.explosionindex + 1
				explosion.new(boss.x + boss.explosionpoint[boss.explosionindex][1], boss.y + boss.explosionpoint[boss.explosionindex][2])
			else
				if not(player.victory == true) then
					player.victory = true
					se.play("plane_fly")
				end
			end
		end
		
		boss.y = boss.y - boss.speed * dt
	end
	
end

function boss.draw()
	if game.stage < 43 then
		return
	end
	
	if game.stage == 43 then
		--mid boss
		if boss.state == "dead" then
			love.graphics.draw(imgmidbossdead, boss.x, boss.y)
		else
			love.graphics.draw(imgmidboss, boss.x, boss.y)
		end
		--draw barrier
		love.graphics.draw(imgbarrier[boss.barrierstate], boss.x + boss.barrierx, boss.y + boss.barriery)
		
		if game.debug == true then
			love.graphics.setColor(0, 255, 255)
			love.graphics.rectangle("fill", boss.x, boss.y, boss.width, boss.height)--boss
			love.graphics.setColor(0, 255, 0)
			love.graphics.rectangle("fill", boss.x + boss.coreoffsetx, boss.y + boss.coreoffsety, boss.corewidth, boss.coreheight)--core
			if boss.barrierstate == 1 then
				love.graphics.setColor(0, 255, 255)
				love.graphics.rectangle("fill", boss.x + boss.barrierx, boss.y + boss.barriery, boss.barrierwidth, boss.barrierheight)--barrier
			end
			love.graphics.setColor(255, 255, 255)
		end
		
	elseif game.stage == 44 then
		--final boss
		if boss.state == "dead" then
			love.graphics.draw(imgfinbossdead, boss.x, boss.y)
		else
			--draw laser
			love.graphics.setColor(255, 0, 0)
			--boss x, y: 60, 0
			if boss.laserstate == 2 then
				love.graphics.setColor(255, 0, 0)
				love.graphics.rectangle("fill", boss.x + 119, boss.y + 132, 2, 443)
			elseif boss.laserstate == 3 then
				love.graphics.setColor(255, 0, 0)
				love.graphics.rectangle("fill", boss.x + 119 - 3, boss.y + 132, 2 + 6, 443)
			elseif boss.laserstate == 4 then
				if boss.laserflash == true then
					love.graphics.setColor(255, 107, 80)
				else
					love.graphics.setColor(255, 0, 0)
				end
				love.graphics.rectangle("fill", boss.x + 119 - 6, boss.y + 132, 2 + 12, 443)
			end
			love.graphics.setColor(255, 255, 255)

			--draw funnels
			boss.funnel.draw()
			
			--draw boss
			love.graphics.draw(imgfinboss, boss.x, boss.y)
			--draw mouth
			if boss.destroyed == false then
				love.graphics.draw(imgmouth[boss.mouthstate], boss.x + boss.mouthx, boss.y + boss.mouthy)
			else
				love.graphics.draw(imgmouth[3], boss.x + boss.mouthx, boss.y + boss.mouthy)
			end
		end
	end
	
	--draw bullets
	boss.bullet.draw()
end

function boss.bullet.init()
	local a
	for a = 1, #boss.bullet do
		if boss.bullet[a].enabled == true then
			boss.bullet[a].enabled = false
		end
	end
end

function boss.bullet.new(x, y, xvel, yvel, homing)
	local a
	local index
	
	index = #boss.bullet + 1
	
	for a = 1, #boss.bullet do
		if boss.bullet[a].enabled == false then
			index = a
			break
		end
	end
	
	boss.bullet[index] = {}
	boss.bullet[index].x = x
	boss.bullet[index].y = y
	boss.bullet[index].xvel = xvel
	boss.bullet[index].yvel = yvel
	boss.bullet[index].homing = hominh
	boss.bullet[index].enabled = true
end

function boss.bullet.update(dt)
	local a
	for a = 1, #boss.bullet do
		if boss.bullet[a].enabled == true then
			boss.bullet[a].x = boss.bullet[a].x + boss.bullet[a].xvel * dt
			boss.bullet[a].y = boss.bullet[a].y + boss.bullet[a].yvel * dt
			
			--collision with player
			if collision.aabb(player.x, player.y, player.width, player.height, boss.bullet[a].x, boss.bullet[a].y, boss.bullet.width, boss.bullet.height) then
				boss.bullet[a].enabled = false
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
			
			if collision.aabb(-10, -10, 380, 640, boss.bullet[a].x, boss.bullet[a].y, 10, 10) == false then
				boss.bullet[a].enabled = false
			end
		end
	end
end

function boss.bullet.draw()
	local a
	if game.stage == 43 then
		--blue
		love.graphics.setColor(0, 0, 255)
	elseif game.stage == 44 then
		--red
		love.graphics.setColor(255, 0, 0)
	end
	for a = 1, #boss.bullet do
		if boss.bullet[a].enabled == true then
			love.graphics.draw(imgbossbullet, boss.bullet[a].x - boss.bullet.offsetx, boss.bullet[a].y - boss.bullet.offsety)
			if game.debug == true then
				love.graphics.setColor(0, 162, 232)
				love.graphics.rectangle("fill", boss.bullet[a].x, boss.bullet[a].y, boss.bullet.width, boss.bullet.height)
				love.graphics.setColor(255, 255, 255)
			end
		end
	end
	love.graphics.setColor(255, 255, 255)
end

function boss.funnel.init()
	local a
	for a = 1, #boss.funnel do
		boss.funnel[a].tblroute = {"end"}
		boss.funnel[a].target = nil
		boss.funnel[a].x = -30
		boss.funnel[a].y = -30
		boss.funnel[a].enabled = false
	end
end

function boss.funnel.new(x, y, tblroute)
	local a
	local index
	
	index = #boss.funnel + 1
	
	for a = 1, #boss.funnel do
		if boss.funnel[a].enabled == false then
			index = a
			break
		end
	end
	
	boss.funnel[index] = {}
	boss.funnel[index].tblroute = tblroute
	boss.funnel[index].target = nil
	boss.funnel[index].x = x
	boss.funnel[index].y = y
	boss.funnel[index].tmr = 0
	boss.funnel[index].speed = 250
	boss.funnel[index].direction = "down"
	boss.funnel[index].enabled = true
end

function boss.funnel.update(dt)
	if boss.state == "active" then
		for a = 1, #boss.funnel do
			if boss.funnel[a].enabled == true then
				if not(boss.funnel[a].target == "end") then
					if boss.funnel[a].target == nil then
						boss.funnel[a].target = table.remove(boss.funnel[a].tblroute, 1)
						if boss.funnel[a].target == "end" then
							boss.funnel[a].enabled = false
							break
						end
						if boss.funnel[a].target[1] == "wait" then
							boss.funnel[a].tmr = boss.funnel[a].target[2]
						end
						if boss.funnel[a].target == "shoot" then
							--shoot to player
							local x, y = boss.funnel[a].x + 15, boss.funnel[a].y + 15
							local xvel, yvel
							if game.diffi == 1 then
								xvel, yvel = collision.getXYvelocityWithPoints(x, y, player.x + player.width / 2, player.y + player.height / 2, 200)
							elseif game.diffi == 2 then
								xvel, yvel = collision.getXYvelocityWithPoints(x, y, player.x + player.width / 2, player.y + player.height / 2, 300)
							end
							boss.bullet.new(x, y, xvel, yvel, false)
							boss.funnel[a].target = nil
							
							--set direction
							local angle = math.atan2(boss.funnel[a].y - player.y + player.height / 2, boss.funnel[a].x - player.x + player.width / 2)
							boss.funnel[a].angle = angle
						
							break
						end
					end
					
					if boss.funnel[a].target[1] == "wait" then
						boss.funnel[a].tmr = boss.funnel[a].tmr - dt
						if boss.funnel[a].tmr <= 0 then
							boss.funnel[a].tmr = 0
							boss.funnel[a].target = nil
							break
						end
					else
						local dx, dy = boss.funnel[a].target[1] - boss.funnel[a].x, boss.funnel[a].target[2] - boss.funnel[a].y
						local distance = math.sqrt(dx*dx + dy*dy)
						
						if distance <= 2 then
							boss.funnel[a].target = nil
							break
						end
						
						local nx, ny = dx/distance, dy/distance
						local step = boss.funnel[a].speed * dt
						
						--set direction
						local angle = math.atan2(boss.funnel[a].y - boss.funnel[a].target[2], boss.funnel[a].x - boss.funnel[a].target[1])
						boss.funnel[a].angle = angle
						
						boss.funnel[a].x = boss.funnel[a].x + nx * step
						boss.funnel[a].y = boss.funnel[a].y + ny * step
					end
				end
			
				--collision with player-funnel
				if collision.aabb(boss.funnel[a].x, boss.funnel[a].y, 30, 30, player.x, player.y, player.width, player.height) then
					if not(player.state == "dead") then
						player.state = "dead"
						explosion.new(player.x - player.graphicoffsetx, player.y - player.graphicoffsety)
						--Fade out and FAIL
						scene.game.fadeout = true
						scene.game.fadereason = "fail"
					end
				end
			end
		end
	end
end

function boss.funnel.draw()
	if boss.state == "active" then
		local a
		for a = 1, #boss.funnel do
			if boss.funnel[a].enabled == true then
				love.graphics.draw(imgfunnel, math.floor(boss.funnel[a].x) + 15, math.floor(boss.funnel[a].y) + 15, boss.funnel[a].angle, 1, 1, 15, 15)
				if game.debug == true then
					love.graphics.setColor(255, 0, 0)
					love.graphics.rectangle("fill", boss.funnel[a].x, boss.funnel[a].y, 30, 30)
					love.graphics.setColor(255, 255, 255)
				end
			end
		end
	end
end

function boss.funnel.destroy()
	local a
	for a = 1, #boss.funnel do
		if boss.funnel[a].enabled == true then
			explosion.new(boss.funnel[a].x - 9, boss.funnel[a].y - 9)
			boss.funnel[a].tblroute = {"end"}
			boss.funnel[a].target = nil
			boss.funnel[a].x = -30
			boss.funnel[a].y = -30
			boss.funnel[a].enabled = false
		end
	end
	
	boss.bullet.init()
end