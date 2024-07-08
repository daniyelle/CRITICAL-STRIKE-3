local char = script.Parent
while true do
	wait()
	if char:FindFirstChild("Playing") then
		for _, people in pairs(game.Workspace:GetChildren()) do
			if people:FindFirstChild("Humanoid")~=nil and people:FindFirstChild("Torso") and people~=char then
				if (people.Torso.Position-char.Torso.Position).magnitude<=30 and char.Torso.Transparency ~= 1 then
					if not char.Head:FindFirstChild("Warning") then
						if people:FindFirstChild("Ult") and people.Ult.Middle:FindFirstChild("Stealth") and people.Ult.Middle.Stealth.Value == true and people.Torso.Transparency == 1 then
							print('adding effect')
							local eff = game.Lighting.Effects.StealthWarning.Warning:Clone()
							eff.Parent = char.Head
							local sound=Instance.new("Sound")
							sound.PlaybackSpeed=0.5
							sound.SoundId="rbxassetid://584533998"
							sound.Volume=5
							sound.Parent=people.Torso
							game.Debris:AddItem(sound,2)
							sound:Play()
						end
					end
				end
			end
		end
	end
end
