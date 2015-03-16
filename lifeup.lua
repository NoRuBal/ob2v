lifeup = {}

function lifeup.init()
	local a
	for a = 1, #lifeup do
		lifeup[a].enabled = false
	end
	lifeup.speed = 100
	lifeup.width = 40
	lifeup.height = 40
end

function lifeup.new(x, y, direction)
	local a
	local index
	
	index = #lifeup + 1
	
	for a = 1, #lifeup do
		if lifeup[a].enabled == false then
			index = a
			break
		end
	end
	
	lifeup[index] = {}
	lifeup[index].x = x
	lifeup[index].y = y
	lifeup[index].direction = direction
	lifeup[index].enabled = true
end

function lifeup.update(dt)
	local a
	for a = 1, #lifeup do
		if lifeup[a].enabled == true then
			--move
			if lifeup[a].direction == "left" then
				lifeup[a].x = lifeup[a].x - 100 * dt
			end
			if lifeup[a].direction == "right" then
				lifeup[a].x = lifeup[a].x + 100 * dt
			end
			
			--vanish
			if lifeup[a].direction == "left" then
				if lifeup[a].x <= 0 - lifeup.width then
					lifeup[a].enabled = false
				end
			elseif lifeup[a].direction == "right" then
				if lifeup[a].x >= 360 + lifeup.width then
					lifeup[a].enabled = false
				end
			end
			
			--check collision with player
			if collision.aabb(player.x - player.graphicoffsetx, player.y - player.graphicoffsety, player.graphicwidth, player.graphicheight, lifeup[a].x, lifeup[a].y, lifeup.width, lifeup.height) then
				lifeup[a].enabled = false
				player.life = player.life + 1
				se.play("1up_get")
				if player.life == 11 then
					--Achievement: chance
					if game.mobile == false then
						achievementSystem:UnlockAchievement("chance")
					end
				end
			end
		end
	end
end

function lifeup.draw()
	local a
	for a = 1, #lifeup do
		if lifeup[a].enabled == true then
			love.graphics.draw(imglifeup, lifeup[a].x, lifeup[a].y)
		end
	end
end