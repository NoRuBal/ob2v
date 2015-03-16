collision = {}

function collision.aabb(pic1x, pic1y, pic1width, pic1height, pic2x, pic2y, pic2width, pic2height)
-- check if pix1 and pix2 collide
-- usage: collcheck(blabla~) => true|false
    if (pic1x + pic1width) > pic2x and pic1x < (pic2x + pic2width) then
        if (pic1y + pic1height) > pic2y and pic1y < (pic2y + pic2height) then
            return true
        end
    end

	return false
end

function collision.mousecheck(x, y, width, height, mousex, mousey)
-- check if pixmousex and pix2 collide
-- usage: collcheck(blabla~) => true|false
    if (x + width) > mousex and x < (mousex + 1) then
        if (y + height) > mousey and y < (mousey + 1) then
            return true
        end
    end

	return false
end

function collision.getXYvelocityWithPoints(px1, py1, px2, py2, speed)
	local angle = math.atan2((py2 - py1), (px2 - px1))
   
	local bulletDx = speed * math.cos(angle)
	local bulletDy = speed * math.sin(angle)
	
	return bulletDx, bulletDy
end