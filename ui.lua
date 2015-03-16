ui = {}

function ui.draw()
	if scene.game.pause == true then
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, (640 - 64), 360, 64)
		
		love.graphics.setColor(255, 255, 255)
		love.graphics.setLineWidth(1)
		love.graphics.rectangle("line", 1, (640 - 64), 361, 67)
		
		love.graphics.printf(":: paused ::", 0, 640 - 50, 360, "center")
	else
		
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, (640 - 64), 360, 64)
		
		love.graphics.setColor(255, 255, 255)
		love.graphics.setLineWidth(1)
		love.graphics.rectangle("line", 1, (640 - 64), 359, 64)
		love.graphics.setColor(127, 127, 127)
		love.graphics.rectangle("fill", 83, 620, 240, 8)
		love.graphics.setColor(50, 0, 254)
		love.graphics.rectangle("fill", 85, 622, player.bullettime / player.bullettimemax * 100 * 2.36, 4)
		love.graphics.setColor(255, 255, 255)
		if not(game.stage > 42) then
			love.graphics.print("stage: " .. game.stage, 84, 580)
			love.graphics.draw(imgenemy, quadenemy[stage[game.stage].target], 26, 583)
		else
			love.graphics.print(":unknown:", 84, 580)
		end
		love.graphics.draw(imgtargetframe, 26, 583)
		
		love.graphics.draw(imglives, 259, 580)
		love.graphics.print(":" .. player.life, 289, 580)
	end
	
	if game.mobile == true then
		love.graphics.setColor(255, 255, 255, 127)
		love.graphics.draw(imgslowbutton, 5, 509)
		love.graphics.draw(imgshotbutton, 67, 509)
		love.graphics.setColor(255, 255, 255)
	end
end

function ui.touchpressed(id, x, y, pressure)
	x = x / 360
	y = y / 640
	x = x * love.graphics.getWidth()
	y = y * love.graphics.getHeight()
	x, y = scale.mousePosition(x, y)
	if game.mobile == true then
		if player.victory == false then
			if not(player.state == "dead") then
				if player.appearing == false then
					if collision.mousecheck(5, 509, 58, 58, x, y) then
						if scene.game.slow == true then
							scene.game.slow = false
						else
							scene.game.slow = true
						end
					elseif collision.mousecheck(67, 509, 58, 58, x, y) then
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
				end
			end
		end
	end
end