function CreateObject(modifiers)
	local Hitbox = modifiers["Object"]:Clone()
	if modifiers["Owner"] then
		local Owner = Instance.new("StringValue") 
		Owner.Name = "Owner"
		Owner.Parent = Hitbox
		Owner.Value = modifiers["Owner"]
	end
	if modifiers["cFrame"] then
		Hitbox.CFrame = modifiers["cFrame"]
	end
	if modifiers["bVel"] then
		local bVel = Instance.new("BodyVelocity")
		bVel.MaxForce = Vector3.new(1,1,1) * math.huge
		bVel.Velocity = modifiers["bVel"]
		bVel.Parent = Hitbox
	end
	if modifiers["pVel"] then
		Hitbox.Velocity = modifiers["pVel"]
	end
	if modifiers["Antigrav"] then
		local bForce = Instance.new("BodyForce")
		bForce.Force = Vector3.FromAxis(Enum.Axis.Y)*workspace.Gravity*Hitbox:GetMass()
		bForce.Name = "Antigrav"
		bForce.Parent = Hitbox
	end
	if modifiers["CanCollide"] then
		Hitbox.CanCollide = modifiers["CanCollide"]
	end
	if modifiers["Lifetime"] then
		game.Debris:AddItem(Hitbox,modifiers["Lifetime"])
	end
	if modifiers["Clone"] then
		Hitbox.Name = Hitbox.Name .. "CLONE"
	else
		game.ReplicatedStorage.CreateServer:FireServer(modifiers)
	end
	if modifiers["Parent"] ~= "LocalPlayer" then
		Hitbox.Parent = modifiers["Parent"]
	else
		Hitbox.Parent = game.Players.LocalPlayer.Character
	end
end

function localprint(values)
	print(values)
end

function push(direction,duration)
	print('pushing')
	local bv=Instance.new("BodyVelocity")
	bv.MaxForce=Vector3.new(99999, 999999, 999999)
	bv.Velocity=direction
	bv.Parent=game.Players.LocalPlayer.Character.HumanoidRootPart
	game.Debris:AddItem(bv,duration)
end

function ChangeValLocal(Object,Value)
	Object.Value = Value
end

game.ReplicatedStorage:WaitForChild("LocalChangeValue").OnClientEvent:Connect(ChangeValLocal)

game.ReplicatedStorage:WaitForChild("CreateClient").OnClientEvent:Connect(CreateObject)
game.ReplicatedStorage:WaitForChild("CreateHitbox").Event:Connect(CreateObject)
game.ReplicatedStorage:WaitForChild("LocalPrint").OnClientEvent:Connect(localprint)
game.ReplicatedStorage:WaitForChild("PushPlayer").OnClientEvent:Connect(push)
