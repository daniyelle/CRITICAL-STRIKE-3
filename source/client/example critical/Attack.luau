local tool = script.Parent;

local newanim = Instance.new("Animation") newanim.Name = "AttackAnim" newanim.Parent = tool

local player = game.Players.LocalPlayer
local char=player.Character
local attackframe=1
local combocount=0
local range=2.5
local combo=0
local basedmg=150
local cooldown=0
local actualcooldown=4
local critgain=5
local counting=false
if game.Workspace.Cooldown.Value == true then
	cooldown=0
	actualcooldown=0
end
local damaging=false
local hits={}
local hitboxes={{2, 0, 0}, {3, 0 ,0}, {4, 0, 0}, {5, 0, 0}, {6, 0, 0}}
local sound=Instance.new("Sound")
sound.PlaybackSpeed=1.5
sound.SoundId="rbxasset://sounds/swordlunge.wav"
sound.Volume=1
sound.Parent=char.Torso

local CreateHitbox = game.ReplicatedStorage:WaitForChild("CreateHitbox")
local DamageEvent = game.ReplicatedStorage:WaitForChild("DealDamage")
local PlaySound = game.ReplicatedStorage:WaitForChild("PlaySound")

function TableContains(Table,element)
	for i,v in pairs(Table) do
		if v == element then return true end
	end
	return false
end

function MainEffect()
	local blast = Instance.new("Part")
	blast.Shape = Enum.PartType.Cylinder
	blast.Size = Vector3.new(0.5,40,40)
	blast.CFrame = char.Ult.S1.CFrame
	blast.Parent = workspace
	blast.CanCollide = false
	blast.Anchored = true
	local alreadydmg = {player.Name}
	blast.Touched:Connect(function() end)
	CreateHitbox:Fire({Object = game.Lighting.Objects.warriorslash,Parent = "LocalPlayer",cFrame = CFrame.new(char.Ult.S1.Position),Owner = player.Name})
	for i,v in pairs (blast:GetTouchingParts()) do
		print(v.Parent.Parent.Name)
		if v.Parent.Parent:FindFirstChild("Humanoid") and TableContains(alreadydmg,v.Parent.Parent.Name) == false and v.Parent.Parent.Humanoid ~= char.Humanoid then
			local armor = v.Parent.Parent.Chest.Middle.Armor.Value
			local damage = char.Chest.Middle.Damage.Value
			alreadydmg[i] = v.Parent.Parent.Name
			DamageEvent:FireServer(v.Parent.Parent.Humanoid,(basedmg+damage-armor),script.Parent.Name)
		end
	end
	blast:Destroy()
end
tool.Activated:connect(function()
	local animtrack1=char.Humanoid:LoadAnimation(script.Parent.AttackAnim)
	if _G.notStunned() and cooldown==0 then
		hits={}
		cooldown=actualcooldown
		coolingdown()
		animtrack1:Play()
		wait(1)
		PlaySound:FireServer(sound,true)
		MainEffect()
		wait(0.2)
		MainEffect()
		wait(0.2)
		MainEffect()
		wait(0.2)
		char.CritEnable.Value=true
		char.Critical.Value=0
		char.Chest.Middle.Critical:Destroy()
		script.Parent:Destroy()
	end	
end)

function coolingdown()
	coroutine.resume(coroutine.create(function()
		if counting==false then
			counting=true
			while cooldown>0 do				
				cooldown=cooldown-.1				
				if cooldown>1 then
					script.Parent.Name="("..math.ceil(cooldown)..")"
				else
					script.Parent.Name="("..math.abs(math.ceil(cooldown*10)/10)..")"
				end
				wait(.1)
			end
			cooldown=0
			script.Parent.Name="READY"
			counting=false
		end
	end))
	
end

--[[
game:GetService("RunService").RenderStepped:connect(function()
	coroutine.resume(coroutine.create(function()
		if damaging==true then
			for index, child in pairs(game.Workspace:GetChildren()) do
				if child:FindFirstChild("Humanoid")~=nil then
					if allhitboxes(child) and child.Name~=player.Name then						
						damage(child)
					end
				end
			end
		end
	end))
end)

function pain(model, value)
	local armor = model.Chest.Middle.Armor.Value
	local damage = char.Chest.Middle.Damage.Value
	DamageEvent:FireServer(char.Humanoid,basedmg-armor+damage)
end

function damage(model)
	if alreadyHit(model)==false then
		table.insert(hits, 1, model)
		local beforehit=model.Humanoid.Health
		pain(model, basedmg)
		_G.addCritical(critgain)
		if model.Head:FindFirstChild("AttackUp")~=nil then
			model.Head.AttackUp.Parent=char.Head
			model.Chest.Middle.Damage.Value=0
		elseif model.Head:FindFirstChild("Armored")~=nil then
			model.Head.Armored.Parent=char.Head
			model.Chest.Middle.Armor.Value=0
		end
	end	
end

function allhitboxes(model)
	local hit=false
	for _, hitboxchek in pairs(hitboxes) do		
		if _G.hitBox(model, char.HumanoidRootPart.Position+(char.HumanoidRootPart.CFrame.lookVector*hitboxchek[1]+char.HumanoidRootPart.CFrame.upVector*hitboxchek[2]+char.HumanoidRootPart.CFrame.rightVector*hitboxchek[3]), range) then
			hit=true
		end
	end
	return hit
end


function alreadyHit(target)
	if _G.findInTable(hits, target)==true then
		return true
	else
		return false
	end
end
]]
