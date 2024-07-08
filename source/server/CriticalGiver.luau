local char = script.Parent
char.Humanoid.MaxHealth = 1
char.Humanoid.Health = 1
char.Humanoid.WalkSpeed = 50
char.Humanoid.JumpPower = 50
char.Health:Destroy()
while true do
	wait()
	local crit = script.Parent.Critical
	if not script.Parent:FindFirstChild("Spectating") then
		if not script.Parent:FindFirstChild("Chest") then
			if script.Parent:FindFirstChild("Humanoid") then
		   		local player=game.Players:GetPlayerFromCharacter(script.Parent)
				if player==nil then
					script.Parent.Humanoid.Health=0
				elseif player~=nil then
					player:LoadCharacter()
				end
			end
		end
	end
	--[==[if script.Parent.Name == "EpicCritical" then
		if script.Parent:FindFirstChild("Chest") then
			script.Parent.Chest.Middle.Damage.Value = 50
			script.Parent.Chest.Middle.Armor.Value = 50
		end
	end]==]
	if script.Parent.CritEnable.Value == true then
		if crit.Value == 100 then
			local class = script.Parent.Chest.Middle.Class.Value
			if class == "MONK" then return end
			local T1 = game.Lighting.Classes["".. class ..""].CRITICAL:clone()
			local p = game.Players:playerFromCharacter(script.Parent)
			T1.Parent = p.Backpack
			local effect = game.Lighting.Effects.Critical:Clone()
			effect.Parent = script.Parent.Chest.Middle
			script.Parent.Chest.Middle.Sound:Play()
			crit.Value = 0
		end
	end
end
