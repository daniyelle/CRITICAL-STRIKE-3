wait()
local player=game.Players.LocalPlayer
repeat wait() until player.Character ~= nil
local char=player.Character
local uis=game:GetService("UserInputService")
local camera=game.Workspace.CurrentCamera
local Mouse=player:GetMouse()
local mode=player.Mouselock

repeat wait() until char:FindFirstChild("HumanoidRootPart")
if uis.KeyboardEnabled==true then
	BodyGyro = Instance.new("BodyGyro");
	BodyGyro.D = 0
	BodyGyro.P = 100000
	BodyGyro.maxTorque = Vector3.new(0, 99999999999 , 0)
	BodyGyro.CFrame = CFrame.new(char.HumanoidRootPart.Position, Mouse.Hit.p)
	BodyGyro.Parent=char.HumanoidRootPart
	
	Mouse.KeyDown:connect(function(key)
		if key=="z" then
			if mode.Value==false then
				mode.Value=true
				local msg=game.Lighting.ServerMessage:Clone()
				msg.Color.Value=Color3.new(1, 1, 1)
				msg.Text.Value="You have enabled mouselock, press z to toggle"
				msg.Parent=player.PlayerGui
			elseif mode.Value==true then
				mode.Value=false
				local msg=game.Lighting.ServerMessage:Clone()
				msg.Color.Value=Color3.new(1, 1, 1)
				msg.Text.Value="You have disabled mouselock, press z to toggle"
				msg.Parent=player.PlayerGui
			end
		end
	end)
	
	game:GetService("RunService").RenderStepped:connect(function()
		if mode.Value==true then		
			local ray=Ray.new(camera.CFrame.p, Mouse.UnitRay.Direction*1000)
			local hits=false
			local post
			local ignorelist={char}
			while hits==false do
				local hit, pos=game.Workspace:FindPartOnRayWithIgnoreList(ray, ignorelist)
				if hit.CanCollide==false or hit.Transparency>=1 then
					table.insert(ignorelist, 1, hit)
				else
					post=pos
					hits=true
				end
			end
			char.Humanoid.AutoRotate=false
			BodyGyro.maxTorque = Vector3.new(0, 99999999999, 0)
			BodyGyro.CFrame = CFrame.new(char.HumanoidRootPart.Position, post)
		elseif mode.Value==false then
			char.Humanoid.AutoRotate=true
			BodyGyro.maxTorque = Vector3.new(0, 0, 0)
		end
	end)
end
