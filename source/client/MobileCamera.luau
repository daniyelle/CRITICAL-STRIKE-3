local uis=game:GetService("UserInputService")
wait(.5)
if uis.KeyboardEnabled==false and uis.TouchEnabled==true then
	if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"):FindFirstChild("BodyGyro") then
		game.Players.LocalPlayer.Character.HumanoidRootPart.BodyGyro:Destroy()
	end
	local gyro=Instance.new("BodyGyro",game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"))
	gyro.MaxTorque=Vector3.new(0,math.huge,0)
	gyro.D=50
	gyro.P=5000
	game:GetService("RunService").RenderStepped:connect(function()
		game.Players.LocalPlayer.Character.Humanoid.AutoRotate=false
		gyro.CFrame=CFrame.new(Vector3.new(0,0,0),game.Workspace.CurrentCamera.CFrame.lookVector*Vector3.new(1,0,1))
	end)
end
