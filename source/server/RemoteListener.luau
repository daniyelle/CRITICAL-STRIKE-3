--a quick attempt by andre to fix cs3 (as seen in critical strike legacy)
-- roblox used to be way more reliant on the client than it is today, making everythign seen here possible without remotes in the past

function dealDamage(plr,humanoiddmg,amount,sourceName)
	if (sourceName == nil) or (not string.find(sourceName,"CLONE")) and humanoiddmg.Health ~= 0 then
		humanoiddmg:TakeDamage(amount)
		if humanoiddmg.Health > humanoiddmg.MaxHealth then humanoiddmg.Health = humanoiddmg.MaxHealth end
		if humanoiddmg.Health <= 0 and (humanoiddmg.Parent:FindFirstChild("Killed") == nil) and ( sourceName ~= "VOID") and game.Players:FindFirstChild(humanoiddmg.Parent.Name) ~= nil then
			print(plr.Name," killed ",humanoiddmg.Parent.Name)
			local tags = game.Lighting.Tags.Killed:Clone()
			tags.Parent = humanoiddmg.Parent
			plr.Character.Kill.Value = plr.Character.Kill.Value +1
			print(plr.Name,plr.Character.Kill.Value)
		end
	end
end

function AddEffect(plr,headreceive,effect,duration,sourceName)
	if sourceName == nil or string.find(sourceName,"CLONE") then return end
	local eff = effect:Clone()
	eff.Parent = headreceive
	if duration then
		game.Debris:AddItem(eff,duration)
	end
	if eff.ClassName == "Part" then
		eff.CFrame = headreceive.CFrame
	end
	if eff:FindFirstChild("NameTag") then
		eff.NameTag = plr.Name
	end
end

function CreateObject(player,modifiers)
	print(player.Name)
	if not modifiers["NoReplicate"] then
		modifiers["Clone"] = true
		for i,v in pairs(game.Players:GetChildren()) do
			if v ~= player then
				game.ReplicatedStorage.CreateClient:FireClient(v,modifiers)
			end
		end	
	else
		Create(modifiers,player)
	end
end

function Create(modifiers,player)
	local Hitbox = modifiers["Object"]:Clone()
	if modifiers["Name"] then
		Hitbox.Name = modifiers["Name"]
	end
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
	Hitbox.Parent = workspace
end

function AddStat(player,Type,amount)
	if Type == "Armor" then
		player.Character.Chest.Middle.Armor.Value = player.Character.Chest.Middle.Armor.Value + amount
	end
end

function PlaySound(player,soundId,parent,speed)
	if not soundId then return end
	local sound = Instance.new("Sound")
	sound.SoundId = soundId
	sound.Parent = parent
	sound.Volume = 0.5
	if speed then
		sound.PlaybackSpeed = speed
	end
	sound:Play()
	sound.Ended:Connect(function()
		sound:Destroy()
	end)
end

function NumberofTools(player)
	local amnt = 0
	if not player then return 0 end
	for i,v in pairs(player.Character:GetChildren()) do
		if v.ClassName == "Tool" then
			amnt = amnt + 1
		end
	end
	return amnt + #player.Backpack:GetChildren()
end

function PushPlayer(source,player,direction,duration)
	if game.Players:FindFirstChild(player.Name) then
		game.ReplicatedStorage.PushPlayer:FireClient(game.Players:FindFirstChild(player.Name),direction,duration)
	else
		local bv=Instance.new("BodyVelocity")
		bv.MaxForce=Vector3.new(99999, 999999, 999999)
		bv.Velocity=direction
		bv.Parent=player.HumanoidRootPart
		game.Debris:AddItem(bv,duration)
	end
end

function altAddCritical(player,critObj,amount,sourceName)
	if string.find(sourceName,"CLONE") or critObj.Parent.CritEnable.Value == false then return end
	critObj.Value = critObj.Value + amount
end

function AddCritical(player,critObj,amount,sourceName)
	if NumberofTools(game.Players:FindFirstChild(critObj.Parent.Name)) > 4 or string.find(sourceName,"CLONE") or critObj.Parent.CritEnable.Value == false then return end
	critObj.Value = critObj.Value + amount
end

function ChangeVal(player,Object,Value)
	Object.Value = Value
	game.ReplicatedStorage.LocalChangeValue:FireAllClients(Object,Value)
end

function GlobalDelete(player,Object)
	if Object then Object:Destroy() end
end

function ChangeTransparency(player,Object,value)
	Object.Transparency = value
end

game.ReplicatedStorage:WaitForChild("DealDamage").OnServerEvent:Connect(dealDamage)
game.ReplicatedStorage:WaitForChild("AddEffect").OnServerEvent:Connect(AddEffect)
game.ReplicatedStorage:WaitForChild("CreateServer").OnServerEvent:Connect(CreateObject)
game.ReplicatedStorage:WaitForChild("AddStat").OnServerEvent:Connect(AddStat)
game.ReplicatedStorage:WaitForChild("PlaySound").OnServerEvent:Connect(PlaySound)
game.ReplicatedStorage:WaitForChild("AddCritical").OnServerEvent:Connect(AddCritical)
game.ReplicatedStorage:WaitForChild("PushPlayer").OnServerEvent:Connect(PushPlayer)
game.ReplicatedStorage:WaitForChild("ChangeObjVal").OnServerEvent:Connect(ChangeVal)
game.ReplicatedStorage:WaitForChild("CreateHitbox").Event:Connect(CreateObject)
game.ReplicatedStorage:WaitForChild("GlobalAddCritical").Event:Connect(AddCritical)
game.ReplicatedStorage:WaitForChild("GlobalAddEffect").Event:Connect(AddEffect)
game.ReplicatedStorage:WaitForChild("GlobalDealDamage").Event:Connect(dealDamage)
game.ReplicatedStorage:WaitForChild("Delete").OnServerEvent:Connect(GlobalDelete)
game.ReplicatedStorage:WaitForChild("ChangeTransparency").OnServerEvent:Connect(ChangeTransparency)
game.ReplicatedStorage:WaitForChild("AltAddCritcal").OnServerEvent:Connect(altAddCritical)
