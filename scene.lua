require "stage"

scene = {}
scene.title = {}
scene.intermission = {}
scene.game = {}
scene.gameover = {}
scene.password = {}
scene.ending = {}
scene.intro = {}
scene.achievement = {}

function scene.title.load(skip)
	love.audio.stop()
	
	scene.title.carriery = 301 --carrier y
	scene.title.planex = 201
	scene.title.planey = 496
	scene.title.planeacc = 0
	if skip == true then
		scene.title.planey = 81
		scene.title.sequence = 4
		scene.title.offsetx = 0
		scene.title.offsety = 0
		bgm.play("title")
	else
		scene.title.sequence = 5
	end
	scene.title.title = false
	scene.title.menu = false 
	scene.title.done = false
	scene.title.fade = true
	scene.title.timer = 0
	scene.title.shaketimer = 0
	scene.title.scale = 3
	scene.title.delay = 0
	scene.title.offsetx = 0
	scene.title.offsety = 0
	scene.title.cursor = 0 --0:start 1:password
	scene.title.selected = false
	scene.title.alpha = 0
	scene.title.menu = 1 --1:main 2:difficiulty
	
	player.life = 3
	game.diffi = 1
	
	game.scene = 0
end

function scene.title.update(dt)
	scene.title.timer = scene.title.timer + dt
	if scene.title.sequence == 0 then
		if scene.title.timer >= 1 then
			scene.title.timer = 0
			scene.title.sequence = 1
			se.play("plane_fly")
		end
	elseif scene.title.sequence == 1 then
		if scene.title.planey <= -100 then
				scene.title.timer = scene.title.timer + dt
			if scene.title.timer >= 4.5 then
				scene.title.timer = 0
				scene.title.sequence = 2
				scene.title.planey = -230
				scene.title.timer = 0
			end
		else
			scene.title.carriery = scene.title.carriery + 150 * dt
			scene.title.planey = scene.title.planey - (10 + scene.title.planeacc) * dt
			scene.title.planeacc = scene.title.planeacc + 150 * dt
		end
	elseif scene.title.sequence == 2 then
		if scene.title.planey >= 81 then
			scene.title.timer = scene.title.timer + dt
			if scene.title.timer >= 0.3 then
				scene.title.timer = 0
				scene.title.sequence = 3
				se.play("explosion")
			end
		else
			scene.title.planey = scene.title.planey + 200 * dt
		end
	elseif scene.title.sequence == 3 then
		if (scene.title.title == true) and (scene.title.menu == false) then
			scene.title.shaketimer = scene.title.shaketimer + dt
			if scene.title.shaketimer >= 0.02 then
				scene.title.shaketimer = scene.title.shaketimer - 0.02
				scene.title.offsetx = math.random(-4, 4)
				scene.title.offsety = math.random(-4, 4)
				scene.title.scale = scene.title.scale - dt * 20
				if scene.title.scale < 1 then
					scene.title.scale = 1
				end
			end
		end
		scene.title.timer = scene.title.timer + dt
		if scene.title.timer >= 0.5 then
			scene.title.timer = scene.title.timer - 0.5
			if scene.title.title == false then
				scene.title.title = true
			elseif scene.title.menu == false then
				scene.title.delay = scene.title.delay + 1
				if scene.title.delay >= 5 then
					scene.title.offsetx = 0
					scene.title.offsety = 0
					scene.title.menu = true
				end
			elseif scene.title.done == false then
				scene.title.done = true
			elseif scene.title.done == true then
				scene.title.sequence = 4
			end
		end
	elseif scene.title.sequence == 5 then
		if scene.title.fade == true then
			scene.title.timer = scene.title.timer + dt
			if scene.title.timer >= 2.55 then
				scene.title.timer = 2.55
				scene.title.fade = false
			end
		else
			scene.title.timer = scene.title.timer - dt * 2
			if scene.title.timer <= 0 then
				scene.title.timer = 0
				scene.title.fade = true
				scene.title.sequence = 6
			end
		end
	elseif scene.title.sequence == 6 then
		if scene.title.fade == true then
			scene.title.timer = scene.title.timer + dt
			if scene.title.timer >= 2.55 then
				scene.title.timer = 2.55
				scene.title.fade = false
			end
		else
			scene.title.timer = scene.title.timer - dt * 2
			if scene.title.timer <= 0 then
				scene.title.fade = true
				scene.title.sequence = 0
				bgm.play("title")
			end
		end
	end
	
	if scene.title.selected == true then
		scene.title.timer = scene.title.timer + dt
		if scene.title.timer >= 0.4 then
			scene.title.timer = scene.title.timer - 0.4
			scene.title.alpha = scene.title.alpha + 80
			if scene.title.alpha >= 255 then
				scene.title.alpha = 255
				scene.title.delay = scene.title.delay + 1
				if scene.title.delay == 4 then
					if scene.title.menu == 1 then
						if scene.title.cursor == 0 then
						elseif scene.title.cursor == 1 then
							--password scene
							scene.password.load()
							love.audio.stop()
						elseif scene.title.cursor == 2 then
							if game.mobile == true then --staff scene
								scene.ending.load(true)
							else --achievement scene
								scene.achievement.load()
								love.audio.stop()
							end
						end
					elseif scene.title.menu == 2 then
						if scene.title.cursor == 0 then
							--easy mode
							game.diffi = 1
						elseif scene.title.cursor == 1 then
							--hard mode
							game.diffi = 2
						end
						love.audio.stop()
						scene.intro.load()
					end
				end
			end
		end
	end
end

function scene.title.draw()
	if (scene.title.sequence == 0) or (scene.title.sequence == 1) then
		love.graphics.draw(imgcarrier, 0, scene.title.carriery)
		love.graphics.draw(imgplayerwhite, scene.title.planex, scene.title.planey)
	elseif scene.title.sequence == 4 then
		love.graphics.draw(imgtitleplane, 14, scene.title.planey)
		love.graphics.draw(imgtitle, 161 + scene.title.offsetx, 260 + scene.title.offsety)
		if scene.title.menu == 1 then
			love.graphics.draw(imgmenu, 62, 403)
			--[[
			if game.mobile == true then
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("fill", 70, 499, 232, 30)
				love.graphics.setColor(255, 255, 255)
			end
			]]--
		else
			love.graphics.draw(imgdiffimenu, 62, 403)
		end
		if scene.title.menu == 1 then
			if scene.title.cursor == 0 then
				love.graphics.draw(imgcursor, 112, 409)
			elseif scene.title.cursor == 1 then
				love.graphics.draw(imgcursor, 83, 457)
			elseif scene.title.cursor == 2 then
				if game.mobile == true then
					love.graphics.draw(imgcursor, 112, 505)
				else
					love.graphics.draw(imgcursor, 40, 505)
				end
			end
		elseif scene.title.menu == 2 then
			if scene.title.cursor == 0 then
				love.graphics.draw(imgcursor, 112, 409)
			elseif scene.title.cursor == 1 then
				love.graphics.draw(imgcursor, 112, 457)
			end
		end
	elseif scene.title.sequence == 5 then
		love.graphics.setColor(255, 255, 255, scene.title.timer * 100)
		love.graphics.draw(imghondoom)
		love.graphics.setColor(255, 255, 255, 255)
	elseif scene.title.sequence == 6 then
		love.graphics.setColor(255, 255, 255, scene.title.timer * 100)
		love.graphics.draw(imglove)
		love.graphics.setColor(255, 255, 255, 255)
	else
		love.graphics.draw(imgtitleplane, 14, scene.title.planey)
		if scene.title.title == true then
			love.graphics.draw(imgtitle, 161 + scene.title.offsetx, 260 + scene.title.offsety, 0, scene.title.scale)
		end
		if scene.title.menu == true then
			if scene.title.menu == 1 then
				love.graphics.draw(imgmenu, 62, 403)
				if game.mobile == true then
					love.graphics.setColor(0, 0, 0)
					love.graphics.rectangle("fill", 70, 499, 232, 30)
					love.graphics.setColor(255, 255, 255)
				end
			else
				love.graphics.draw(imgdiffimenu, 62, 403)
			end
		end
		if scene.title.done == true then
			love.graphics.draw(imgcursor, 112, 409)
		end
	end
	
	love.graphics.setColor(0, 0, 0, scene.title.alpha)
	love.graphics.rectangle("fill", 0, 0, 360, 640)
	love.graphics.setColor(255, 255, 255, 255)
end

function scene.title.keypressed(key)
	if scene.title.sequence == 4 then
		if key == game.keydown then
			--move cursor down
			if scene.title.menu == 1 then
				if scene.title.selected == false then
					if not (scene.title.cursor >= 2) then
						scene.title.cursor = scene.title.cursor + 1
						se.play("click")
					end
				end
			elseif scene.title.menu == 2 then
				if scene.title.selected == false then
					if not (scene.title.cursor >= 1) then
						scene.title.cursor = scene.title.cursor + 1
						se.play("click")
					end
				end
			end
		elseif key == game.keyup then
			--move cursor up
			if scene.title.selected == false then
				if not (scene.title.cursor <= 0) then
					scene.title.cursor = scene.title.cursor - 1
					se.play("click")
				end
			end
		elseif (key == game.keya) or (key == game.keyb) or (key == game.keypause) then
			if scene.title.selected == false then
				if scene.title.menu == 1 then
					if scene.title.cursor == 0 then
						--difficulty
						scene.title.menu = 2
						se.play("click2")
					else
						--select
						scene.title.timer = 0
						scene.title.delay = 0
						scene.title.selected = true
						se.play("click2")
					end
				else
					--select
					scene.title.timer = 0
					scene.title.delay = 0
					scene.title.selected = true
					se.play("click2")
				end
			end
		end
	elseif (scene.title.sequence == 5) or (scene.title.sequence == 6) then
		if (key == game.keya) or (key == game.keyb) or (key == game.keypause) then
			scene.title.sequence = 1
			bgm.play("title")
			se.play("plane_fly")
		end
	elseif scene.title.sequence == 1 then
		if (key == game.keya) or (key == game.keyb) or (key == game.keypause) then
			scene.title.planey = 81
			scene.title.sequence = 4
			scene.title.offsetx = 0
			scene.title.offsety = 0
		end
	end
end

function scene.title.mousepressed(x, y, button)
	if scene.title.selected == false then
		if scene.title.sequence == 4 then
			if scene.title.menu == 1 then
				if collision.mousecheck(133, 399, 111, 40, x, y) then
					--start
					scene.title.cursor = 0
					scene.title.menu = 2
					se.play("click2")
				elseif collision.mousecheck(104, 445, 173, 44, x, y) then
					--password
					scene.title.cursor = 1
					--select
					scene.title.timer = 0
					scene.title.delay = 0
					scene.title.selected = true
					se.play("click2")
				elseif collision.mousecheck(134, 495, 111, 40, x, y) then
					--password
					scene.title.cursor = 2
					--select
					scene.title.timer = 0
					scene.title.delay = 0
					scene.title.selected = true
					se.play("click2")
				end
			elseif scene.title.menu == 2 then
				if collision.mousecheck(139, 394, 102, 46, x, y) then
					--easy
					scene.title.cursor = 0
					scene.title.timer = 0
					scene.title.delay = 0
					scene.title.selected = true
					se.play("click2")
				elseif collision.mousecheck(139, 441, 102, 47, x, y) then
					--hard
					scene.title.cursor = 1
					scene.title.timer = 0
					scene.title.delay = 0
					scene.title.selected = true
					se.play("click2")
				end
			end
		elseif (scene.title.sequence == 5) or (scene.title.sequence == 6) then
			scene.title.sequence = 1
			bgm.play("title")
			se.play("plane_fly")
		elseif scene.title.sequence == 1 then
			scene.title.planey = 81
			scene.title.sequence = 4
			scene.title.offsetx = 0
			scene.title.offsety = 0
		end
	end
end

---------------------------------------------------------------------------

function scene.intermission.load(stg)
	game.stage = stg
	message.init()
	if game.stage < 43 then
	scene.intermission.str = game.stage --common stage
		if scene.intermission.str < 10 then
			scene.intermission.str = "0" .. scene.intermission.str
		end
		scene.intermission.str = "stage ".. scene.intermission.str .. "\ntarget:\n      "
		
		scene.intermission.sequence = 0
		scene.intermission.timer = 0
		scene.intermission.letters = 0
		scene.intermission.showtarget = false
	else --boss stage
		scene.intermission.tmrwarning = 0
		scene.intermission.showwarning = false
		scene.intermission.countwarning = 0
	end
	
	--play bgm
	if not(bgm.playing == stage.bgmlist[game.stage]) then
		bgm.play(stage.bgmlist[game.stage])
		bgm[bgm.playing]:setPitch(1)
	end
	if game.stage > 42 then
		se.play("warning")
	end
	
	bgm[bgm.playing]:setPitch(1)
	
	stage.datainit()
	scene.game.slow = false
	game.scene = 1
end

function scene.intermission.update(dt)
	if game.stage < 43 then --general stage
		if scene.intermission.sequence == 0 then
			scene.intermission.timer = scene.intermission.timer + dt
			if scene.intermission.timer >= 0.05 then
				scene.intermission.timer = scene.intermission.timer - 0.05
				scene.intermission.letters = scene.intermission.letters + 1
				se.play("click")
				if scene.intermission.letters == #scene.intermission.str then
					scene.intermission.sequence = 1
					scene.intermission.timer = 0
					scene.intermission.showtarget = true
					se.play("click2")
				end
			end
		elseif scene.intermission.sequence == 1 then
			scene.intermission.timer = scene.intermission.timer + dt
			if scene.intermission.timer >= 1.5 then
				scene.game.load(game.stage)
			end
		end
	else --boss stage
		scene.intermission.tmrwarning = scene.intermission.tmrwarning + dt
		if scene.intermission.tmrwarning >= 0.5 then
			scene.intermission.tmrwarning = scene.intermission.tmrwarning - 0.5
			if scene.intermission.showwarning == true then
				scene.intermission.showwarning = false
			else
				scene.intermission.showwarning = true
			end
			scene.intermission.countwarning = scene.intermission.countwarning + 1
			if scene.intermission.countwarning == 9 then
				--load boss stage
				scene.game.load(game.stage)
			end
		end
	end
end

function scene.intermission.draw()
	if game.stage < 43 then
		love.graphics.printf(scene.intermission.str:sub(1, scene.intermission.letters), 0, 250, 360, "center")
		if scene.intermission.showtarget == true then
			love.graphics.draw(imgenemy, quadenemy[stage[game.stage].target], 156, 344)
		end
	else
		love.graphics.draw(imgwarning, 0, 33)
		love.graphics.draw(imgwarning, 0, 549)
		if scene.intermission.showwarning == true then
			love.graphics.setColor(255, 0, 0)
			love.graphics.printf("::warning::", 0, 303, 360, "center")
			love.graphics.setColor(255, 255, 255)
		end
	end
end

--------------------------------------------------------------------------

function scene.game.load(stg)
	math.randomseed(os.time())
	
	game.stage = stg
	player.init()
	enemy.init()
	playershoot.init()
	enemybullet.init()
	explosion.init()
	lifeup.init()
	boss.init()
	
	game.enemynum = stage[game.stage].enemynum
	game.target = stage[game.stage].target
	game.enemylist = stage[game.stage].enemylist
	game.targetnum = math.random(1, game.enemynum - 1)
	game.lifeupnum = math.random(game.targetnum, game.enemynum - 1)
	
	scene.game.alpha = 0
	scene.game.timer = 0
	scene.game.fadeout = false
	scene.game.fadesequence = 0
	scene.game.fadereason = "" --success/fail/half(loss 1 life and next stage)
	
	scene.game.pause = false
	
	--spawn timer.
	game.tmrspawn = math.random(stage[game.stage].spawnmin, stage[game.stage].spawnmax) --random spawn delay
	
	--background
	scene.game.background = {}
	scene.game.background[1] = {}
	scene.game.background[1].y = 0
	scene.game.background[1].image = math.random(1, 4)
	scene.game.background[2] = {}
	scene.game.background[2].y = -640
	scene.game.background[2].image = math.random(1, 4)
	scene.game.background.speed = 20
	
	--drag
	scene.game.dragging = {active = false, diffx = 0, diffy = 0, id = 0}
	
	scene.game.slow = false
	
	game.scene = 2
end

function scene.game.update(dt)
	if scene.game.pause == false then
		if scene.game.fadeout == true then
			if scene.game.fadesequence == 0 then
				scene.game.timer = scene.game.timer + dt
				if scene.game.timer >= 0.2 then
					scene.game.timer = scene.game.timer - 0.2
					scene.game.alpha = scene.game.alpha + 80
					if scene.game.alpha >= 255 then
						scene.game.alpha = 255
						scene.game.timer = 0
						scene.game.fadesequence = 1
					end
				end
			elseif scene.game.fadesequence == 1 then
				scene.game.timer = scene.game.timer + dt
				if scene.game.timer >= 0.5 then
					if scene.game.fadereason == "success" then
						if game.stage == 21 then
							--mid-boss
							scene.intermission.load(43)
							return
						elseif game.stage == 42 then
							--final-boss
							scene.intermission.load(44)
							return
						elseif game.stage == 43 then
							scene.intermission.load(22)
							return
						elseif game.stage == 44 then
							--ending scene
							--check achievements
							if game.mobile == false then
								if player.life == 1 then
									achievementSystem:UnlockAchievement("close")
								elseif player.life == 11 then
									achievementSystem:UnlockAchievement("dread")
								end
							end
							
							scene.ending.load()
							return
						else
							scene.intermission.load(game.stage + 1)
						end
					elseif scene.game.fadereason == "fail" then
						player.life = player.life - 1
						if player.life == 0 then
							scene.gameover.load() --check player life and gameover scene
							return
						else
							scene.intermission.load(game.stage)
							return
						end
					elseif scene.game.fadereason == "half" then
						player.life = player.life - 1
						if player.life == 0 then
							scene.gameover.load() --check player life and gameover scene
							return
						else
							if game.stage == 21 then
								--mid-boss
								scene.intermission.load(43)
								return
							elseif game.stage == 42 then
								--final-boss
								scene.intermission.load(44)
								return
							elseif game.stage == 43 then
								scene.intermission.load(22)
								return
							elseif game.stage == 44 then
								--ending scene
								if game.mobile == false then
									--check achievements
									if player.life == 1 then
										achievementSystem:UnlockAchievement("close")
									elseif player.life == 11 then
										achievementSystem:UnlockAchievement("dread")
									end
								end
								
								scene.ending.load()
								return
							else
								scene.intermission.load(game.stage + 1)
								return
							end
						end
					end
				end
			end
		else
			if player.victory == false then
				if love.keyboard.isDown(game.keya) or scene.game.slow == true then
					if player.bullettime > 0 then
						player.bullettime = player.bullettime - dt
						if player.bullettime < 0 then
							player.bullettime = 0
						end
						
						dt = dt * 0.3
						bgm[bgm.playing]:setPitch(0.5)
					else
						bgm[bgm.playing]:setPitch(1)
					end
				else
					if not(bgm.playing == nil) then
						bgm[bgm.playing]:setPitch(1)
					end
				end
			end
			player.update(dt)
			
		end
		explosion.update(dt)
		if game.stage < 43 then
			enemy.update(dt)
			enemybullet.update(dt)
		end
		boss.update(dt)
		lifeup.update(dt)
		playershoot.update(dt)
		message.update(dt)
		
		--scroll background
		local a
		for a = 1, 2 do
			scene.game.background[a].y = scene.game.background[a].y + scene.game.background.speed * dt
			if scene.game.background[a].y >= 640 then
				scene.game.background[a].y = -640
				local rnd
				rnd = math.random(1, 4)
				scene.game.background[a].image = rnd
			end
		end
	end
end

function scene.game.draw()
	--background
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, 360 * 2, 640 * 2)
	love.graphics.setColor(255, 255, 255)
	local a
	for a = 1, 2 do
		love.graphics.draw(imgbackground[scene.game.background[a].image], 0, scene.game.background[a].y)
	end
	
	--draw enemybullet
	enemybullet.draw()
	
	--draw boss
	boss.draw()
	
	--draw playershoot
	playershoot.draw()
	
	--draw enemy
	enemy.draw()
	
	--draw 1up
	lifeup.draw()
	
	--draw player
	player.draw()
	
	--draw explosion
	explosion.draw()
	
	--draw message
	message.draw()
	
	--draw UI
	ui.draw()
	
	--fade out
	love.graphics.setColor(0, 0, 0, scene.game.alpha)
	love.graphics.rectangle("fill", 0 ,0, 360, 640)
	love.graphics.setColor(255, 255, 255, 255)
	
	
end

function scene.game.keypressed(key)
	if key == game.keypause or key == "menu" then
		if scene.game.pause == true then
			scene.game.pause = false
			--love.audio.play(bgm[bgm.playing])
		else
			scene.game.pause = true
			--love.audio.pause()
		end
		se.play("click")
	end
end

function scene.game.keyreleased(key)
	if key == game.keya then
		bgm[bgm.playing]:setPitch(1)
	end
end

function scene.game.touchpressed(id, x, y, pressure)
	if scene.game.dragging.active == false then
		scene.game.dragging.active = true
		scene.game.dragging.diffx = x - player.x
		scene.game.dragging.diffy = y - player.y
		scene.game.dragging.id = id
	end

	ui.touchpressed(id, x, y, pressure)
end

function scene.game.touchreleased(id, x, y, pressure)
	if id == scene.game.dragging.id then
		scene.game.dragging.active = false
	end
end

-------------------------------------------------------------
function scene.gameover.load()
	stage.itemlist = {5, 10, 15, 20, 25, 30, 35, 40}
	
	--achievement:fail
	if game.mobile == false then
		achievementSystem:UnlockAchievement("fail")
	end
	scene.gameover.alpha = 255
	scene.gameover.timer = 0
	scene.gameover.sequence = 1
	scene.gameover.cursor = 0
	scene.gameover.tblpassword = password.numtocode(game.stage, true, game.diffi)
	
	game.scene = 3
	
	love.audio.stop()
	bgm.playing = ""
	se.play("gameover")
end

function scene.gameover.update(dt)
	if scene.gameover.sequence == 1 then --fade in
		scene.gameover.timer = scene.gameover.timer + dt
		if scene.gameover.timer >= 0.2 then
			scene.gameover.timer = scene.gameover.timer - 0.2
			scene.gameover.alpha = scene.gameover.alpha - 80
			if scene.gameover.alpha <= 0 then
				scene.gameover.alpha = 0
				scene.gameover.timer = 0
				scene.gameover.sequence = 2
			end
		end
	--sequence 2:static
	elseif scene.gameover.sequence == 3 then --fade out
		scene.gameover.timer = scene.gameover.timer + dt
		if scene.gameover.timer >= 0.2 then
			scene.gameover.timer = scene.gameover.timer - 0.2
			scene.gameover.alpha = scene.gameover.alpha + 80
			if scene.gameover.alpha >= 255 then
				scene.gameover.alpha = 255
				scene.gameover.timer = 0
				--do things
				if scene.gameover.cursor == 0 then
					--retry
					player.life = 3
					scene.intermission.load(game.stage)
				elseif scene.gameover.cursor == 1 then
					--show password
					scene.gameover.sequence = 4
					scene.gameover.timer = 0
				elseif scene.gameover.cursor == 2 then
					--go to title
					scene.title.load()
				end
			end
		end
	elseif scene.gameover.sequence == 4 then --show password
		if not(scene.gameover.timer >= 1) then
			scene.gameover.timer = scene.gameover.timer + dt
		end
	end
end

function scene.gameover.draw()
	if scene.gameover.sequence == 4 then --password
		if scene.gameover.timer >= 1 then
			if game.stage == 43 then
				love.graphics.printf("boss stage\npassword:", 0, 120, 360, "center")
			elseif game.stage == 44 then
				love.graphics.printf("boss stage\npassword:", 0, 120, 360, "center")
			else
				love.graphics.printf("stage " .. game.stage .. "\npassword:", 0, 120, 360, "center")
			end
			--draw password
			local a
			local b
			for a = 1, 3 do
				for b = 1, 3 do
					love.graphics.draw(imgpassword[scene.gameover.tblpassword[(b - 1) * 3 + a]], 92 + (a - 1) * 64, 223 + (b - 1) * 64)
				end
			end
			love.graphics.printf("thank you for playing", 0, 440, 380, "center")
		end
		
	else
		local cursorx
		local cursory
		love.graphics.setColor(255, 0, 0)
		love.graphics.printf("game\nover", 0, 180, 360, "center")
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf("continue\npassword\ntitle", 0, 370, 360, "center")
		if scene.gameover.cursor == 0 then
			cursorx = 75
			cursory = 377
		elseif scene.gameover.cursor == 1 then
			cursorx = 75
			cursory = 412
		elseif scene.gameover.cursor == 2 then
			cursorx = 108
			cursory = 447
		end
		if scene.gameover.sequence > 1 then
			love.graphics.draw(imgcursor, cursorx, cursory)
		end
		love.graphics.setColor(0, 0, 0, scene.gameover.alpha)
		love.graphics.rectangle("fill", 0, 0, 360 * 2, 640 * 2)
		love.graphics.setColor(255, 255, 255)
	end
end


function scene.gameover.keypressed(key)
	if scene.gameover.sequence == 2 then
		if key == game.keyup then
			if scene.gameover.cursor > 0 then
				scene.gameover.cursor = scene.gameover.cursor - 1
				se.play("click")
			end
		elseif key == game.keydown then
			if scene.gameover.cursor < 2 then
				scene.gameover.cursor = scene.gameover.cursor + 1
				se.play("click")
			end
		elseif (key == game.keya) or (key == game.keyb) then
			--select
			scene.gameover.sequence = 3
			se.play("click2")
		end
	elseif scene.gameover.sequence == 4 then
		if (key == game.keypause) or (key == game.keya) or (key == game.keyb) then
			se.play("click2")
			scene.title.load()
		end
	end
end

function scene.gameover.mousepressed(x, y, button)
	if scene.gameover.sequence == 2 then
		if collision.mousecheck(101, 369, 157, 35, x, y) then --continue
			scene.gameover.cursor = 0
			scene.gameover.sequence = 3
			se.play("click2")
		elseif collision.mousecheck(101, 404, 157, 34, x, y) then --password
			scene.gameover.cursor = 1
			scene.gameover.sequence = 3
			se.play("click2")
		elseif collision.mousecheck(101, 438, 157, 34, x, y) then --title
			scene.gameover.cursor = 2
			scene.gameover.sequence = 3
			se.play("click2")
		end
	elseif scene.gameover.sequence == 4 then
		se.play("click2")
		scene.title.load()
	end
end

----------------------------------------------------------------------

function scene.password.load()
	scene.password.password = {}
	local a
	for a = 1, 9 do
		scene.password.password[a] = 0
	end
	scene.password.cursor = 1
	scene.password.alpha = 0
	scene.password.cursorpos = {{1, 1}, {2, 1}, {3, 1},
						 	    {1, 2}, {2, 2}, {3, 2},
							    {1, 3}, {2, 3}, {3, 3}}
	scene.password.poscursor = {{1, 4, 7},
								{2, 5, 8},
								{3, 6, 9}}
	scene.password.fadeout = false
	scene.password.timer = 0
	scene.password.delay = 0
	game.scene = 4
end

function scene.password.update(dt) 
	if scene.password.fadeout == true then
		scene.password.timer = scene.password.timer + dt
		if scene.password.timer >= 0.2 then
			scene.password.timer = scene.password.timer - 0.2
			scene.password.alpha = scene.password.alpha + 80
			if scene.password.alpha >= 255 then
				scene.password.alpha = 255
				scene.password.delay = scene.password.delay + 1
				if scene.password.delay >= 3 then
					--do things
					if scene.password.cursor == 10 then
						--ok
						local a
						local passwordtostring = ""
						for a = 1, 9 do
							passwordtostring = passwordtostring .. scene.password.password[a]
						end
						player.life = 3
						scene.intermission.load(password.codetonum(passwordtostring, false))
					elseif scene.password.cursor == 11 then
						--back
						scene.title.load(true)
					end
				end
			end
		end
	end
end

function scene.password.draw()
	love.graphics.printf("password:", 12, 120, 360, "center")
	--draw password
	local a
	local b
	for a = 1, 3 do
		for b = 1, 3 do
			love.graphics.draw(imgpassword[scene.password.password[(b - 1) * 3 + a]], 92 + (a - 1) * 64, 200 + (b - 1) * 64)
		end
	end
	love.graphics.printf("ok\nback", 0, 440, 380, "center")
	--draw cursor
	if scene.password.cursor < 10 then
		love.graphics.draw(imgpasswordcursor, 92 + (scene.password.cursorpos[scene.password.cursor][1] - 1) * 64, 200 + (scene.password.cursorpos[scene.password.cursor][2] - 1) * 64)
	elseif scene.password.cursor == 10 then
		--ok
		love.graphics.draw(imgcursor, 137, 447)
	elseif scene.password.cursor == 11 then
		--back
		love.graphics.draw(imgcursor, 120, 484)
	end
	--alpha
	love.graphics.setColor(0, 0, 0, scene.password.alpha)
	love.graphics.rectangle("fill", 0, 0, 360 * 2, 640 * 2)
	love.graphics.setColor(255, 255, 255)
end


function scene.password.keypressed(key)
	if scene.password.fadeout == false then
		if key == game.keyleft then
			if scene.password.cursor > 1 then
				scene.password.cursor = scene.password.cursor - 1
				se.play("click")
			end
		elseif key == game.keyright then
			if scene.password.cursor < 11 then
				scene.password.cursor = scene.password.cursor + 1
				se.play("click")
			end
		elseif key == game.keyup then
			if scene.password.cursor < 10 then
				if scene.password.cursor > 3 then
					scene.password.cursor = scene.password.cursor - 3
					se.play("click")
				end
			else
				scene.password.cursor = scene.password.cursor - 1
				se.play("click")
			end
		elseif key == game.keydown then
			if scene.password.cursor < 10 then
				if scene.password.cursor < 7 then
					scene.password.cursor = scene.password.cursor + 3
					se.play("click")
				else
					scene.password.cursor = 10
					se.play("click")
				end
			else
				if scene.password.cursor < 11 then
				 scene.password.cursor = scene.password.cursor + 1
				 se.play("click")
				end
			end
		elseif (key == game.keya) or (key == game.keyb) then
			if scene.password.cursor < 10 then
				if scene.password.password[scene.password.cursor] == 0 then
					scene.password.password[scene.password.cursor] = 1
					se.play("click2")
				else
					scene.password.password[scene.password.cursor] = 0
					se.play("click2")
				end
			elseif scene.password.cursor == 10 then
				--ok
				local a
				local passwordtostring = ""
				for a = 1, 9 do
					passwordtostring = passwordtostring .. scene.password.password[a]
				end
				
				if password.codetonum(passwordtostring, false) == nil then
					--wrong, beep
					scene.password.cursor = 1
					se.play("explosion")
				else
					scene.password.fadeout = true
					se.play("click2")
				end
			elseif scene.password.cursor == 11 then
				--back
				scene.password.fadeout = true
				se.play("click2")
			end
		end
	end
end

function scene.password.mousepressed(x, y, button)
	if scene.password.fadeout == false then
		if collision.mousecheck(92, 200, 193, 193, x, y) then --password
			local tilex = math.floor((x - 92) / (65)) + 1
			local tiley = math.floor((y - 200) / (65)) + 1

			if scene.password.password[scene.password.poscursor[tilex][tiley]] == 0 then
				scene.password.password[scene.password.poscursor[tilex][tiley]] = 1
			else
				scene.password.password[scene.password.poscursor[tilex][tiley]] = 0
			end
			scene.password.cursor = scene.password.poscursor[tilex][tiley]
			
			se.play("click")
		elseif collision.mousecheck(164, 439, 48, 34, x, y) then --ok
			scene.password.cursor = 10
			scene.password.keypressed(game.keya)
		elseif collision.mousecheck(148, 473, 82, 38, x, y) then --back
			scene.password.cursor = 11
			scene.password.fadeout = true
			se.play("click2")
		end
	end
end

-----------------------------------------------------------------------------------------

function scene.ending.load(staffrole)
	scene.ending.staffrole = false
	if not(staffrole == nil) then
		scene.ending.staffrole = true
	end
	
	scene.ending.credity = 700
	
	scene.ending.credit = "one bullet to victory\n"
						.."\n"
						.."\n"
						.."original idea and\n"
						.."supervision by:\n"
						.."ddb\n"
						.."\n"
						.."\n"
						.."programming and\narts by:\n"
						.."norubal\n"
						.."\n"
						.."music:\n"
						.."byunja\n"
						.."\n"
						.."thanks for:\n"
						.."\n"
						.."phul\n"
						.."davidobot\n"
						.."elsathequeen\n"
						.."liquidhelium\n"
						.."\n"
						.."\n"
						.."powered by:\n"
						.."love2d\n"
						.."\n"
						.."\n"
						.."thanks for\n"
						.."playing\n"
	
	if scene.ending.staffrole == false then
		scene.ending.planey = -4100
	else
		scene.ending.planey = -3000
	end
	scene.ending.carriery = 2400
	
	scene.ending.fadeout = false
	scene.ending.alpha = 0
	scene.ending.timer = 0
	scene.ending.delay = 0
	
	--play bgm
	bgm.play("ending")
	
	game.scene = 5
end

function scene.ending.update(dt)
	scene.ending.credity = scene.ending.credity - dt * 50
	
	--move plane
	if scene.ending.planey >= 496 then
		scene.ending.planey = 496
		scene.ending.fadeout = true
	else
		scene.ending.planey = scene.ending.planey + dt * 100
	end
	
	--move carrier
	if scene.ending.carriery <= 301 then
		scene.ending.carriery = 301
	else
		scene.ending.carriery = scene.ending.carriery - dt * 50
	end
	
	--fade out
	if scene.ending.fadeout == true then
		scene.ending.timer = scene.ending.timer + dt
		if scene.ending.timer >= 0.2 then
			scene.ending.timer = scene.ending.timer - 0.2
			scene.ending.alpha = scene.ending.alpha + 80
			if scene.ending.alpha >= 255 then
				scene.ending.alpha = 255
				scene.ending.delay = scene.ending.delay + 1
				if scene.ending.delay >= 3 then
					--do things
					if game.mobile == false then
						achievementSystem:UnlockAchievement("end")
					end
					if scene.ending.staffrole == true then
						scene.title.load(true)
					else
						scene.title.load()
					end
				end
			end
		end
	end
	
end

function scene.ending.draw()
	love.graphics.draw(imgbackground[2], 0, 0)
	
	if scene.ending.staffrole == false then
		love.graphics.draw(imgcarriercolor, 0, scene.ending.carriery)
		love.graphics.draw(imgplayerback, 201, scene.ending.planey)	
	end
	
	love.graphics.printf(scene.ending.credit, 0, scene.ending.credity, 360, "center")
	
	--alpha
	love.graphics.setColor(0, 0, 0, scene.ending.alpha)
	love.graphics.rectangle("fill", 0, 0, 360 * 2, 640 * 2)
	love.graphics.setColor(255, 255, 255)
end

function scene.ending.mousepressed(x, y, button)
	if scene.ending.staffrole == true then
		scene.ending.fadeout = true
	end
end

-------------------------------------------------------------------------------------

function scene.intro.load()
	scene.intro.script = {}
	scene.intro.script[1] = "you have one bullet\n" ..
							"in order to\n" ..
							"destroy enemy"
	scene.intro.script[2] = "neutralize enemy by\n" ..
							"destroying the\n" ..
							"mother ship"
	scene.intro.script[3] = "arrow keys:move\n" ..
							"z:time dilation\n" ..
							"x:shoot\n" ..
							"space:pause"
	if game.mobile == true then
		scene.intro.script[3] = scene.intro.script[3] .. scene.intro.script[3]
	end
	scene.intro.script[4] = "charging into\n" ..
							"the enemy\n" ..
							"with your plane\n" ..
							"is allowed\n" ..
							"but you will\n"..
							"lose one life"
	scene.intro.script[5] = "good luck"
	scene.intro.y = 	{320 - 34 * 3 / 2,
					 	 320 - 34 * 3 / 2,
						 320 - 34 * 4 / 2,
						 320 - 34 * 6 / 2,
						 320 - 34 * 1 / 2}

	scene.intro.letters = 0
	scene.intro.timer = 0.05
	scene.intro.sentence = 1
	
	scene.intro.alpha = 0
	scene.intro.tmralpha = 0
	scene.intro.fadeout = false
	scene.intro.delay = 0
	
	game.scene = 6
end

function scene.intro.update(dt)
	scene.intro.timer = scene.intro.timer - dt
	if scene.intro.timer <= 0 then
		if scene.intro.letters == string.len(scene.intro.script[scene.intro.sentence]) then
			if scene.intro.sentence == #scene.intro.script then
				if scene.intro.fadeout == false then
					scene.intro.fadeout = true
				end
			else
				scene.intro.letters = 0
				scene.intro.timer = 0.05
				scene.intro.sentence = scene.intro.sentence + 1
			end
			
		else
			scene.intro.timer = 0.05
			scene.intro.letters = scene.intro.letters + 1
			if game.mobile == false then
				se.play("click")
			else
				if scene.intro.sentence == 3 then
				else
					se.play("click")
				end
			end
			if scene.intro.letters == string.len(scene.intro.script[scene.intro.sentence]) then
				scene.intro.timer = 2.5
			end
		end
	end
	
	--fade out
	if scene.intro.fadeout == true then
		scene.intro.tmralpha = scene.intro.tmralpha + dt
		if scene.intro.tmralpha >= 0.2 then
			scene.intro.tmralpha = scene.intro.tmralpha - 0.2
			scene.intro.alpha = scene.intro.alpha + 80
			if scene.intro.alpha >= 255 then
				scene.intro.alpha = 255
				scene.intro.delay = scene.intro.delay + 1
				if scene.intro.delay >= 3 then
					--do things
					scene.intermission.load(1)
				end
			end
		end
	end
end

function scene.intro.draw()
	love.graphics.printf(scene.intro.script[scene.intro.sentence]:sub(1, scene.intro.letters), 0, scene.intro.y[scene.intro.sentence], 360, "center")
	
	if scene.intro.sentence == 3 then
		if game.mobile == true then
			love.graphics.draw(imgcontrol)
		end
	end
	
	--alpha
	love.graphics.setColor(0, 0, 0, scene.intro.alpha)
	love.graphics.rectangle("fill", 0, 0, 360 * 2, 640 * 2)
	love.graphics.setColor(255, 255, 255)
end

function scene.intro.keypressed(key)
	if (key == game.keyb) or (key == game.keya) or (key == game.keypause) then
		if scene.intro.sentence == #scene.intro.script then
			if scene.intro.fadeout == false then
				scene.intro.fadeout = true
			end
		else
			if scene.intro.letters == string.len(scene.intro.script[scene.intro.sentence]) then
				scene.intro.letters = 0
				scene.intro.timer = 0
				scene.intro.sentence = scene.intro.sentence + 1
			else
				scene.intro.letters = string.len(scene.intro.script[scene.intro.sentence])
				scene.intro.timer = 2.5
			end
		end
	end
end

function scene.intro.mousepressed(x, y, button)
	if scene.intro.sentence == #scene.intro.script then
		if scene.intro.fadeout == false then
			scene.intro.fadeout = true
		end
	else
		if scene.intro.letters == string.len(scene.intro.script[scene.intro.sentence]) then
			scene.intro.letters = 0
			scene.intro.timer = 0
			scene.intro.sentence = scene.intro.sentence + 1
		else
			scene.intro.letters = string.len(scene.intro.script[scene.intro.sentence])
			scene.intro.timer = 2.5
		end
	end
end

-----------------------------------------------------------------------------

function scene.achievement.load()
	scene.achievement.alpha = 0
	scene.achievement.tmralpha = 0
	scene.achievement.fadeout = false
	scene.achievement.delay = 0
	
	scene.achievement.tmrarrow = 0
	scene.achievement.showarrow = false
	
	achievementSystem.scrollOffset = 0
	
	game.scene = 7
end

function scene.achievement.update(dt)
	--flash arrow
	scene.achievement.tmrarrow = scene.achievement.tmrarrow + dt
	if scene.achievement.tmrarrow >= 0.5 then
		scene.achievement.tmrarrow = scene.achievement.tmrarrow - 0.5
		if scene.achievement.showarrow == true then
			scene.achievement.showarrow = false
		else
			scene.achievement.showarrow = true
		end
	end
	
	--fade out
	if scene.achievement.fadeout == true then
		scene.achievement.tmralpha = scene.achievement.tmralpha + dt
		if scene.achievement.tmralpha >= 0.2 then
			scene.achievement.tmralpha = scene.achievement.tmralpha - 0.2
			scene.achievement.alpha = scene.achievement.alpha + 80
			if scene.achievement.alpha >= 255 then
				scene.achievement.alpha = 255
				scene.achievement.delay = scene.achievement.delay + 1
				if scene.achievement.delay >= 3 then
					--do things
					scene.title.load(true)
				end
			end
		end
	end
	
	achievementSystem:Update()
end

function scene.achievement.draw()
	achievementSystem:Draw()
	love.graphics.setFont(numberfont)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, 360, 114)
	love.graphics.rectangle("fill", 0, 600, 360, 40)
	love.graphics.setColor(255, 255, 255)
	if scene.achievement.showarrow == true then
		if not(achievementSystem.scrollOffset == 0) then
			love.graphics.draw(imgaup, 170, 85)
		end
		if not(achievementSystem.scrollOffset == achievementSystem.maxScrollOffset) then
			love.graphics.draw(imgadown, 170, 615)
		end
	end
	love.graphics.printf("achievements", 0, 30, 360, "center")
	
	--alpha
	love.graphics.setColor(0, 0, 0, scene.achievement.alpha)
	love.graphics.rectangle("fill", 0, 0, 360 * 2, 640 * 2)
	love.graphics.setColor(255, 255, 255)
end

function scene.achievement.keypressed(key)
	if (key == game.keya) or (key == game.keyb) or (key == game.keypause) then
		se.play("click2")
		scene.achievement.fadeout = true
	end
end