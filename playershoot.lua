playershoot = {}

function playershoot.init()
	playershoot.speed = 400
	playershoot.width = 6
	playershoot.height = 16
	playershoot.offsetx = 1
	playershoot.offsety = 0
	playershoot.x = 0
	playershoot.y = 0
	playershoot.enabled = false
end

function playershoot.new()
	playershoot.x = player.x + player.width / 2 - playershoot.width / 2
	playershoot.y = player.y
	playershoot.enabled = true
	se.play("player_shot")
end

function playershoot.update(dt)
	if playershoot.enabled == true then
		playershoot.y = playershoot.y - playershoot.speed * dt
		--collision with enemy
		local a
		for a = 1, #enemy do
			if enemy[a].enabled == true then
				if collision.aabb(playershoot.x, playershoot.y, playershoot.width, playershoot.height, enemy[a].x, enemy[a].y, enemy[enemy[a].color].width, enemy[enemy[a].color].height) then
					if enemy[a].color == stage[game.stage].target then
						enemy[a].enabled = false
						explosion.new(enemy[a].x, enemy[a].y)
						playershoot.enabled = false
						--go to the top of screen, fade out, and next stage
						player.immune = true
						player.victory = true
						se.play("plane_fly")
						
						if scene.game.fadereason == "fail" then
							--achievement: C-Cross counter?!
							if game.mobile == false then
								achievementSystem:UnlockAchievement("crosscounter")
							end
							scene.game.fadereason = "half"
						else
							player.state = "center"
						end
						
						break
					else
						enemy[a].enabled = false
						explosion.new(enemy[a].x, enemy[a].y)
						playershoot.enabled = false
						--Fade out and FAIL
						scene.game.fadeout = true
						scene.game.fadereason = "fail"
						player.immune = true
						break
					end
				end
			end
		end
		
		if playershoot.y <= 0 - playershoot.height then
			--Fade out and FAIL
			if not(scene.game.fadereason == "half") then
				scene.game.fadeout = true
				scene.game.fadereason = "fail"
			end
		end
	end
end

function playershoot.draw()
	if playershoot.enabled == true then
		love.graphics.draw(imgplayershoot, playershoot.x - playershoot.offsetx, playershoot.y - playershoot.offsety)
		if game.debug == true then
			love.graphics.setColor(0, 162, 232)
			love.graphics.rectangle("fill", playershoot.x, playershoot.y, playershoot.width, playershoot.height)
			love.graphics.setColor(255, 255, 255)
		end
	end
end