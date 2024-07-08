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
		
		local class = script.Parent.Parent.Chest.Middle.Class.Value
		local T1 = game.Lighting.Classes["".. class ..""].ClassGui:Clone()
		if h.Parent:findFirstChild(T1.Name) ~= nil then return end
		if (player == nil) then return end 
		
		 
		 
		
		if h then
				if p.PlayerGui:findFirstChild(T1.Name) ~= nil then return end
				T1.Parent = p.PlayerGui
		end
	end
end

script.Parent.Touched:connect(onTouched)
