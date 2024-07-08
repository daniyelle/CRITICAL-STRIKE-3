function OnEntered(Player)
	wait(1)
	if Player.AccountAge <= 60 then -- Age measured in days
		Player:Destroy()
		local h = Instance.new("Hint")
		h.Parent = game.Workspace
		h.Text = Player.Name.." attempted to join the game under the age limit."
		wait(5)
		h:Destroy()
	end
end

game.Players.PlayerAdded:connect(OnEntered)

for i,model in ipairs(game.Workspace:GetChildren()) do
	if model.ClassName == "Model" then
		for i,model2 in ipairs(model:GetChildren()) do
			if model2.ClassName == "Model" then
				for i,model3 in ipairs(model2:GetChildren()) do
					if model3.Name == "ZButton" then
						local clone = game.Lighting.ClassGiver:Clone()
						clone.Parent = model3
					end
				end	
			end
		end	
	end
end

for i,model in ipairs(game.Workspace:GetChildren()) do
	if model.ClassName == "Model" then
		for i,model2 in ipairs(model:GetChildren()) do
			if model2.ClassName == "Model" then
				for i,model3 in ipairs(model2:GetChildren()) do
					if model3.ClassName == "Part" and not model3:FindFirstChild("Weapon") then
						--local new = game.Lighting.Teleport:Clone()
						--new.Parent = model3
						--model3.Teleport:Destroy()
					end
				end	
			end
		end	
	end
end
--]]
