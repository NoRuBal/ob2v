game = {}
bgm = {}
se = {}

require("achievements/achievements")

require "scene"
require "stage"
require "player"
require "enemy"
require "ui"
require "collision"
require "playershoot"
require "enemybullet"
require "explosion"
require "lifeup"
require "password"
require "boss"
require "message"
require "scale"

function love.load()
	local a
	
	local osstring = love.system.getOS()
	if osstring == "Windows" then
		game.mobile = false
	elseif osstring == "Android" then
		game.mobile = true
	end
	--debug
	game.mobile = true
	
	--Achievement system
	if game.mobile == false then
		achievementSystem = AchievementSystem.New()
	end
	
	--set line mode
	love.graphics.setLineStyle("rough")
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	--load resources
	numberfont = love.graphics.newImageFont("graphics/font.png", "abcdefghijklmnopqrstuvwxyz0123456789: ")
	love.graphics.setFont(numberfont)
	
	--init randomizer
	math.randomseed(os.time())
	
	--init enemy data
	enemy.datainit()
	
	--load images
	imghondoom = love.graphics.newImage("graphics/hondoom.png")
	imglove = love.graphics.newImage("graphics/love2d.png")
	imgcarrier = love.graphics.newImage("graphics/carrier.png")
	imgplayerwhite = love.graphics.newImage("graphics/player_white.png")
	imgtitleplane = love.graphics.newImage("graphics/title_plane.png")
	--imgtitle = love.graphics.newImage("graphics/title.png")
	imgtitle = love.graphics.newImage("graphics/title_english.png")
	if game.mobile == true then
		imgmenu = love.graphics.newImage("graphics/menu_mobile.png")
	else
		imgmenu = love.graphics.newImage("graphics/menu.png")
	end
	imgcursor = love.graphics.newImage("graphics/cursor.png")
	imgenemy = love.graphics.newImage("graphics/enemy.png")
	quadenemy = {}
	for a = 1, 8 do
		quadenemy[enemy.colordata[a]] = love.graphics.newQuad((a - 1) * 48, 0, 48, 48, 384, 48)
	end
	imgplayer = love.graphics.newImage("graphics/player.png")
	imgtrash = love.graphics.newImage("graphics/trashbin.png")
	quadplayer = {}
	quadplayer["center"] = love.graphics.newQuad(0, 0, 48, 48, 144, 48)
	quadplayer["left"] = love.graphics.newQuad(48, 0, 48, 48, 144, 48)
	quadplayer["right"] = love.graphics.newQuad(96, 0, 48, 48, 144, 48)
	imglives = love.graphics.newImage("graphics/playerlives.png")
	imgplayershoot = love.graphics.newImage("graphics/playerbullet.png")
	imgenemybullet = love.graphics.newImage("graphics/enemybullet.png")
	imgexplosion = love.graphics.newImage("graphics/explosion.png")
	quadexplosion = {}
	for a = 1, 4 do
		quadexplosion[a] = love.graphics.newQuad((a - 1) * 48, 0, 48, 48, 192, 48)
	end
	imglifeup = love.graphics.newImage("graphics/item.png")
	imgpassword = {}
	imgpassword[0] = love.graphics.newImage("graphics/password_0.png")
	imgpassword[1] = love.graphics.newImage("graphics/password_1.png")
	imgpasswordcursor = love.graphics.newImage("graphics/password_cursor.png")
	
	imgbackground = {}
	imgbackground[1] = love.graphics.newImage("graphics/background_1.png")
	imgbackground[2] = love.graphics.newImage("graphics/background_2.png")
	imgbackground[3] = love.graphics.newImage("graphics/background_3.png")
	imgbackground[4] = love.graphics.newImage("graphics/background_4.png")
	
	imgtargetframe = love.graphics.newImage("graphics/target_frame.png")
	
	imgwarning = love.graphics.newImage("graphics/boss_warning.png")
	
	imgmidboss = love.graphics.newImage("graphics/midboss.png")
	imgmidbossdead = love.graphics.newImage("graphics/midboss_scrap.png")
	imgbarrier = {}
	for a = 1, 4 do
		imgbarrier[a] = love.graphics.newImage("graphics/barrier_" .. a .. ".png")
	end
	imgfinboss = love.graphics.newImage("graphics/boss.png")
	imgfinbossdead = love.graphics.newImage("graphics/boss_scrap.png")
	imgmouth = {}
	for a = 1, 3 do
		imgmouth[a] = love.graphics.newImage("graphics/boss_mouth_" .. a .. ".png")
	end
	imgbossbullet = love.graphics.newImage("graphics/bossbullet.png")
	
	imgfunnel = love.graphics.newImage("graphics/funnel.png")
	
	imgplayerback = love.graphics.newImage("graphics/player_back.png")
	imgcarriercolor = love.graphics.newImage("graphics/carrier_color.png")
	
	imgaura = love.graphics.newImage("graphics/aura.png")
	quadaura = {}
	for a = 1, 4 do
		quadaura[a] = love.graphics.newQuad((a - 1) * 60, 0, 60, 60, 240, 60)
	end
	
	imgaup = love.graphics.newImage("graphics/achievements_up.png")
	imgadown = love.graphics.newImage("graphics/achievements_down.png")
	imgdiffimenu = love.graphics.newImage("graphics/diffimenu.png")
	
	imgslowbutton = love.graphics.newImage("graphics/button_time.png")
	imgshotbutton = love.graphics.newImage("graphics/button_shot.png")
	
	imgcontrol = love.graphics.newImage("graphics/control.png")
	
	--load bgm
	bgm["title"] = love.audio.newSource("sound/bgm/title.ogg", "stream")
	bgm["stage1"] = love.audio.newSource("sound/bgm/stage1.ogg", "stream")
	bgm["stage2"] = love.audio.newSource("sound/bgm/stage2.ogg", "stream")
	bgm["stage3"] = love.audio.newSource("sound/bgm/stage3.ogg", "stream")
	bgm["stage4"] = love.audio.newSource("sound/bgm/stage4.ogg", "stream")
	bgm["stage5"] = love.audio.newSource("sound/bgm/stage5.ogg", "stream")
	bgm["stage6"] = love.audio.newSource("sound/bgm/stage6.ogg", "stream")
	bgm["midboss"] = love.audio.newSource("sound/bgm/midboss.ogg", "stream")
	bgm["finboss"] = love.audio.newSource("sound/bgm/finboss.ogg", "stream")
	bgm["ending"] = love.audio.newSource("sound/bgm/ending.ogg", "stream")
	
	--load se
	se["1up_appear"] = love.audio.newSource("sound/se/1up_appear.ogg", "static")
	se["1up_get"] = love.audio.newSource("sound/se/1up_get.ogg", "static")
	se["click"] = love.audio.newSource("sound/se/click.ogg", "static")
	se["click2"] = love.audio.newSource("sound/se/click2.ogg", "static")
	se["explosion"] = love.audio.newSource("sound/se/explosion.ogg", "static")
	se["laser"] = love.audio.newSource("sound/se/laser.ogg", "static")
	se["plane_fly"] = love.audio.newSource("sound/se/plane_fly.ogg", "static")
	se["player_shot"] = love.audio.newSource("sound/se/player_shot.ogg", "static")
	se["gameover"] = love.audio.newSource("sound/se/gameover.ogg", "static")
	se["warning"] = love.audio.newSource("sound/se/warning.ogg", "static")
	
	--global variable init
	game.scene = 0 --game scene. 0:title scene 1:intermission 2:game 3:game over 4:password 5:ending 6:intro 7.achievements
	game.debug = false
	player.life = 3

	--settings
	game.keya = "z"
	game.keyb = "x"
	game.keyup = "up"
	game.keydown = "down"
	game.keyleft = "left"
	game.keyright = "right"
	game.keypause = " "
	
	game.trashmode = false
	game.trashcounter = 0
	
	game.diffi = 1 --1:easy 2:hard
	
	stage.datainit()
	
	scene.title.load()
end

function love.update(dt)
	dt = math.min(dt, 1/30)
	
	if game.scene == 0 then
		scene.title.update(dt)
	elseif game.scene == 1 then
		scene.intermission.update(dt)
	elseif game.scene == 2 then
		scene.game.update(dt)
	elseif game.scene == 3 then
		scene.gameover.update(dt)
	elseif game.scene == 4 then
		scene.password.update(dt)
	elseif game.scene == 5 then
		scene.ending.update(dt)
	elseif game.scene == 6 then
		scene.intro.update(dt)
	elseif game.scene == 7 then
		scene.achievement.update(dt)
	end
	
	if game.mobile == false then
		achievementSystem:Update()
	end
end

function love.draw()
	scale.first()
	if game.scene == 0 then
		scene.title.draw()
	elseif game.scene == 1 then
		scene.intermission.draw()
	elseif game.scene == 2 then
		scene.game.draw()
	elseif game.scene == 3 then
		scene.gameover.draw()
	elseif game.scene == 4 then
		scene.password.draw()
	elseif game.scene == 5 then
		scene.ending.draw()
	elseif game.scene == 6 then
		scene.intro.draw()
	elseif game.scene == 7 then
		scene.achievement.draw()
	end
	
	if game.debug == true then
		love.graphics.print("fps:"..love.timer.getFPS(), 0, 0)
	end
	
	if game.mobile == false then
		achievementSystem:DrawInGame()
	end
	scale.last()
end

function bgm.play(index)
	love.audio.stop()
	love.audio.rewind(bgm[index])
	love.audio.play(bgm[index])
	bgm[index]:setLooping(true)
	bgm.playing = index
end

function se.play(index)
	love.audio.rewind(se[index])
	love.audio.play(se[index])
end

function love.keypressed(key)
	if key == "escape" or key == "back" or key == "home" then
		os.exit()
		return
	end
	--[[
	if key == "d" then
		if game.debug == false then
			game.debug = true
		else
			game.debug = false
		end
	end
	]]--
	
	--easter egg
	if key == "t" then
		game.trashcounter = game.trashcounter + 1
		if game.trashcounter == 10 then
			game.trashcounter = 0
			if game.trashmode == true then
				game.trashmode = false
			else
				--achievement: trash mode
				if game.mobile == false then
					achievementSystem:UnlockAchievement("trashbin")
				end
				game.trashmode = true
			end
		end
	end
	
	if game.scene == 0 then
		scene.title.keypressed(key)
	elseif game.scene == 2 then
		scene.game.keypressed(key)
	elseif game.scene == 3 then
		scene.gameover.keypressed(key)
	elseif game.scene == 4 then
		scene.password.keypressed(key)
	elseif game.scene == 6 then
		scene.intro.keypressed(key)
	elseif game.scene == 7 then
		scene.achievement.keypressed(key)
	end
end

function love.mousepressed(x, y, button)
	x, y = scale.mousePosition(x, y)
	if game.scene == 0 then
		scene.title.mousepressed(x, y, button)
	elseif game.scene == 2 then
		if game.mobile == false then
			--scene.game.mousepressed(x, y, button)
		end
	elseif game.scene == 3 then
		scene.gameover.mousepressed(x, y, button)
	elseif game.scene == 4 then
		scene.password.mousepressed(x, y, button)
	elseif game.scene == 5 then
		scene.ending.mousepressed(x, y, button)
	elseif game.scene == 6 then
		scene.intro.mousepressed(x, y, button)
	end
end

function love.touchpressed(id, x, y, pressure)
	if game.scene == 2 then
		if game.mobile == true then
			x = x * 360
			y = y * 640
			--x, y = scale.mousePosition(x, y)
			scene.game.touchpressed(id, x, y, pressure)
		end
	end
end

function love.touchreleased(id, x, y, pressure)
	if game.scene == 2 then
		scene.game.touchreleased(id, x, y, pressure)
	end
end

function love.keyreleased(key)
	if game.scene == 2 then
		scene.game.keyreleased(key)
	end
end