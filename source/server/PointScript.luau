while true do
	wait()
	if script.Parent.Humanoid.Health == 0 and script.Parent:FindFirstChild("ForceField") then
		script:Destroy()
	end
	if script.Parent.Humanoid.Health == 0 then
		local part = game.Lighting.Objects.PointBlock:Clone()
		part.CFrame = script.Parent.HumanoidRootPart.CFrame
		part.Parent = game.Workspace
		script:Destroy()
	end
end
