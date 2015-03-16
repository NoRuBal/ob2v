stage = {}

function stage.datainit()
	stage.targetlist = {"red", "green", "blue", "yellow", "brown", "gray", "magenta"}
	stage.enemylist = {
			 		  {"black"}, 
			 		  {"black", "red"}, 
			 		  {"black", "red", "green"}, 
			 		  {"black", "red", "green", "blue"},
			 		  {"black", "red", "green", "blue", "yellow"},
			 		  {"black", "red", "green", "blue", "yellow", "brown"},
			 		  {"black", "red", "green", "blue", "yellow", "brown", "gray"}
				   	  }
	if not((game.scene == 1) or (game.scene == 2)) then
		stage.itemlist = {5, 10, 15, 20, 25, 30, 35, 40}
	end
	stage.bgmlist = {
					"stage1",
					"stage1",
					"stage1",
					"stage1",
					"stage1",
					"stage1",
					"stage1",
					"stage2",
					"stage2",
					"stage2",
					"stage2",
					"stage2",
					"stage2",
					"stage2",
					"stage3",
					"stage3",
					"stage3",
					"stage3",
					"stage3",
					"stage3",
					"stage3",
					"stage4",
					"stage4",
					"stage4",
					"stage4",
					"stage4",
					"stage4",
					"stage4",
					"stage5",
					"stage5",
					"stage5",
					"stage5",
					"stage5",
					"stage5",
					"stage5",
					"stage6",
					"stage6",
					"stage6",
					"stage6",
					"stage6",
					"stage6",
					"stage6",
					"midboss",
					"finboss"
					}
	
	local diffifactor = 1
	if game.diffi == 2 then
		diffifactor = 1.5
	end
	local a
	local b
	local count = 1
	for a = 1, 6  do --moving pattern
		for b = 1, 7 do --bullet pattern
			stage[count] = {}
			if game.diffi == 1 then
				stage[count].enemynum = 10 --number of enemy in stage
			elseif game.diffi == 2 then
				stage[count].enemynum = 20 --number of enemy in stage
			end
			stage[count].enemylist = stage.enemylist[b] --list of enemy in stage
			stage[count].target = stage.targetlist[b] --target number
			stage[count].movepattern = a --enemy moving pattern
			stage[count].bulletpattern = b --bullet moving pattern
			
			if game.diffi == 1 then
				stage[count].spawnmin = 0.5 --minimum enemy spawning time
				stage[count].spawnmax = 3 --maximum enemy spawning time
			elseif game.diffi == 2 then
				stage[count].spawnmin = 0.25 --minimum enemy spawning time
				stage[count].spawnmax = 1.5 --maximum enemy spawning time
			end
			
			--set move pattern values
			if a == 1 then --straight
				stage[count].yvelmin = 70 * diffifactor --y velocity
				stage[count].yvelmax = 150 * diffifactor
			elseif a == 2 then --diagonal
				stage[count].yvelmin = 70 * diffifactor
				stage[count].yvelmax = 150 * diffifactor
				--xvel is decided by line p1-p2
			elseif a == 3 then --square wave
				stage[count].yvelmin = 70 * diffifactor
				stage[count].yvelmax = 150 * diffifactor
				stage[count].xvelmin = 50 * diffifactor --x velocity
				stage[count].xvelmax = 100 * diffifactor
				stage[count].ydistancemin = 70 * diffifactor --y distance
				stage[count].ydistancemax = 80 * diffifactor
				stage[count].xdistancemin = 70 * diffifactor --x distance
				stage[count].xdistancemax = 130 * diffifactor
			elseif a == 4 then --triangle wave
				stage[count].yvelmin = 70 * diffifactor
				stage[count].yvelmax = 150 * diffifactor
				stage[count].xvelmin = 50 * diffifactor
				stage[count].xvelmax = 100 * diffifactor
				stage[count].distancemin = 70 * diffifactor --wave height
				stage[count].distancemax = 110 * diffifactor
			elseif a == 5 then --sine wave
				stage[count].yvelmin = 70 * diffifactor
				stage[count].yvelmax = 150 * diffifactor
				stage[count].distancemin = 70 * diffifactor --wave height
				stage[count].distancemax = 110 * diffifactor
				stage[count].speedmin = 0.8 * diffifactor --speed
				stage[count].speedmax = 1.2 * diffifactor
			elseif a == 6 then --recognize player
				stage[count].yvelmin = 70 * diffifactor
				stage[count].yvelmax = 150 * diffifactor
				stage[count].xvelmin = 50 * diffifactor
				stage[count].xvelmax = 100 * diffifactor
				stage[count].distancemin = 50 * diffifactor --distance with player
				stage[count].distancemax = 100 * diffifactor
			end
			
			--set shoot pattern values
			if b == 1 then --no shoot
				stage[count].shootdelaymin = 2 / diffifactor
				stage[count].shootdelaymax = 3 / diffifactor
			elseif b == 2 then --straight
				stage[count].shootdelaymin = 2 / diffifactor
				stage[count].shootdelaymax = 3 / diffifactor
				stage[count].byvelmin = 200 * diffifactor
				stage[count].byvelmax = 300 * diffifactor
			elseif b == 3 then --diagonal double
				stage[count].shootdelaymin = 3 / diffifactor
				stage[count].shootdelaymax = 5 / diffifactor
				stage[count].byvelmin = 200 * diffifactor
				stage[count].byvelmax = 300 * diffifactor
				stage[count].bxvelmin = 100 * diffifactor
				stage[count].bxvelmax = 150 * diffifactor
			elseif b == 4 then --circle
				stage[count].shootdelaymin = 4 / diffifactor
				stage[count].shootdelaymax = 5 / diffifactor
				stage[count].byvelmin = 400 * diffifactor
				stage[count].byvelmax = 500 * diffifactor
				stage[count].bradiusmin = 50 / diffifactor
				stage[count].bradiusmax = 100 * diffifactor
				stage[count].bspeedmin = 2 * diffifactor
				stage[count].bspeedmax = 5 * diffifactor
			elseif b == 5 then --homing
				stage[count].shootdelaymin = 2 / diffifactor
				stage[count].shootdelaymax = 3 / diffifactor
				stage[count].bacclation = 200 * diffifactor
				stage[count].byvelmin = 200 * diffifactor
				stage[count].byvelmax = 300 * diffifactor
				stage[count].bxvelmax = 325 * diffifactor
			elseif b == 6 then --player straight
				stage[count].shootdelaymin = 2 / diffifactor
				stage[count].shootdelaymax = 3 / diffifactor
				stage[count].bvelocitymin = 200 * diffifactor
				stage[count].bvelocitymax = 300 * diffifactor
			elseif b == 7 then --eight direction
				stage[count].shootdelaymin = 4 / diffifactor
				stage[count].shootdelaymax = 5 / diffifactor
				stage[count].bvelocitymin = 100 * diffifactor
				stage[count].bvelocitymax = 200 * diffifactor
			end
			
			count = count + 1
		end
	end
	
	--boss stage data
	stage[43] = {}
	stage[43].enemynum = 0 --do not spawn enemy
	stage[43].spawnmin = 0 --minimum enemy spawning time
	stage[43].spawnmax = 0 --maximum enemy spawning time
	
	stage[44] = {}
	stage[44].enemynum = 0 --do not spawn enemy
	stage[44].spawnmin = 0 --minimum enemy spawning time
	stage[44].spawnmax = 0 --maximum enemy spawning time

end