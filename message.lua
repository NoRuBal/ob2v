message = {}

function message.init()
	message.length = 0
	message.offset = 0
	message.speed = 200
	message.str = ""
	message.show = false
end

function message.new(msgstr)
	message.init()
	
	message.str = msgstr
	message.length = string.len(msgstr) * 20 --string length by pixel
	message.offset = message.length
	message.show = true
end

function message.update(dt)
	if message.show == true then
		message.offset = message.offset - message.speed * dt
		if message.offset < 0 - message.length - 10 then
			message.show = false
		end
	end
end

function message.draw()
	if message.show == true then
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, 0, 360, 34)
		love.graphics.setColor(255, 255, 255)
		
		love.graphics.print(message.str, message.offset, 0)
	end
end