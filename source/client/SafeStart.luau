while wait() do
	if script.Parent:FindFirstChild("Playing") then
		script.Parent.ForceField:Destroy()
		local eff1 = game.Lighting.Effects.Forcefield.Friendly:Clone()
		eff1.Parent = script.Parent
		local eff2 = game.Lighting.Effects.Forcefield.Mark:Clone()
		eff2.Parent = script.Parent.Head
		for _,p in ipairs(game.Players.LocalPlayer.Character.Torso:GetChildren()) do
			if p.ClassName=="Part" or p.ClassName=="BodyPosition" then
				p:Destroy()
			end
		end
		local voidPos = game.Lighting.SelfVoid.Position
		local void = game.Lighting.SelfVoid:Clone()
		void.Parent = script.Parent.Torso
		void.Position = voidPos
		wait(4)
		script:Destroy()
	end
end
