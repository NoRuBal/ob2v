function love.conf(t)
	t.identity = "ob2v"
	t.version = "0.9.0"
	
	t.window.icon = "graphics/icon.png"
    t.window.width = 360 --* 1.5
    t.window.height = 640 --* 0.8
	t.window.title = "One Bullet to Victory"
	--t.console = true
	
	t.window.fullscreen = true
    t.window.fullscreentype = "desktop"
	
	t.modules.physics = false
    t.modules.joystick = false

end