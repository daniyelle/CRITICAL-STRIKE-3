-- warrior used only as example (this is from the class statues button)

function getPlayer(humanoid) 
local players = game.Players:children() 
for i = 1, #players do 
if players[i].Character.Humanoid == humanoid then return players[i] end 
end 
end

Door = script.Parent
function onTouched(hit)
		print("Door Hit")
		local human = hit.Parent:findFirstChild("Humanoid")
		if (human ~= nil ) then
			-- a human has touched this door!
			print("Human touched door")
			--Make sure you test the human's name against the leaderboard
			local player = getPlayer(human)
		local players = game.Players:children() 
        local p = game.Players:playerFromCharacter(hit.Parent)
		local h = hit.Parent:findFirstChild("Humanoid")
        if p == nil then return end

		local T1 = game.Lighting.Classes.WARRIOR["ATTACK"]:clone()
		local T2 = game.Lighting.Classes.WARRIOR["ABILITY 1"]:clone()
		local T3 = game.Lighting.Classes.WARRIOR["ABILITY 2"]:clone()
		if h.Parent:findFirstChild(T1.Name) ~= nil then return end
		if (player == nil) then return end 
		
		 
		 
		if h then
				if p.Backpack:findFirstChild(T1.Name) ~= nil then return end
				T1.Parent = p.Backpack
				T2.Parent = p.Backpack
				T3.Parent = p.Backpack
		end
	end
end

script.Parent.Touched:connect(onTouched)
