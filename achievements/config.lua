function AchievementSystemConfig(achievementSystem)
	
	--cross counter
	achievementSystem:CreateAchievement("crosscounter", "C-Cross counter?!", "You can shoot down me but not my bullet.", "cross.jpg")
	--hit target
	achievementSystem:CreateAchievement("charge", "Chaaarge!!", "Doctor Volga, forgive me!", "charge.jpg")
	--press t key 10 times to active trashbin mode
	achievementSystem:CreateAchievement("trashbin", "Flying Trash Bin", "There is no such a thing.", "trash.jpg")
	--see game over scene
	achievementSystem:CreateAchievement("fail", "Oops, fail.", "Where did you learn to fly?", "fail.jpg")
	--beat first boss ship
	achievementSystem:CreateAchievement("cry", "Invader may cry", "This is just a beginning.", "cry.jpg")
	--beat last boss ship
	achievementSystem:CreateAchievement("last", "Last Shooting", "Fall!", "last.jpg")
	--see ending credit
	achievementSystem:CreateAchievement("end", "The end", "Everything is over now... right?", "end.jpg")
	--get 11 lives
	achievementSystem:CreateAchievement("chance", "Gotta catch'em all!", "Never miss a chance.", "chance.jpg")
	--clear the game with 11 lives
	achievementSystem:CreateAchievement("dread", "The Dreaded", "That earth fighter is a monster!", "dread.jpg")
	--clear the game with 1 life
	achievementSystem:CreateAchievement("close", "That was close", "Lucky or skillful.", "close.jpg")
	
	--achievementSystem:DisableIntro()
	--achievementSystem:SetBackgroundColor(0, 0, 0)
	--achievementSystem:SetUnlockedColor(255, 255, 0)
	--achievementSystem:SetLockedColor(0, 0, 0)
	--achievementSystem:SetTextColor(0, 0, 0)
	--achievementSystem:SetButton("0")

end