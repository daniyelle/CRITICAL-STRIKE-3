local tool = script.Parent;

local Anim_1 = instance.new("Animation") Anim_1.Name = "AttackAnim1" Anim_1.Parent = tool
local Anim_2 = instance.new("Animation") Anim_1.Name = "AttackAnim2" Anim_2.Parent = tool

local player = game.Players.LocalPlayer
local char=player.Character
local attackframe=1
local combocount=0
local range=2.5
local combo=0
local basedmg=150
local cooldown=.2
local critgain=4
local counting=false
if game.Workspace.Cooldown.Value == true then
	cooldown=0
	actualcooldown=0
end
local hits={}
local hitboxes={{2, 0, 0}, {4.5, 0, 0}, {1, 0, -1}, {1, 0, 1}, {2.4, 0, 1.5}, {2.4, 0, -1.5}}
sound="rbxasset://sounds//swordslash.wav"

local CreateHitbox = game.ReplicatedStorage:WaitForChild("CreateHitbox")
local DealDamage = game.ReplicatedStorage:WaitForChild("DealDamage")
local PlaySound = game.ReplicatedStorage:WaitForChild("PlaySound")
tool.Activated:connect(function()
	local animtrack1=char.Humanoid:LoadAnimation(script.Parent.AttackAnim1)
	local animtrack2=char.Humanoid:LoadAnimation(script.Parent.AttackAnim2)
	if _G.notStunned() and attackframe~=4 and attackframe~=5 then
		hits={}
		if attackframe==1 then	
			attackframe=4
			combocounting()
			animtrack1:Play()
			PlaySound:FireServer(sound,char.Torso)
			wait(.3)
			attackframe=5
			wait(cooldown)
			attackframe=2
		else
			if attackframe==2 then
				attackframe=4
				combocounting()
				animtrack2:Play()
				PlaySound:FireServer(sound,char.Torso)
				wait(.3)
				attackframe=5
				wait(cooldown)
				attackframe=1	
			end
		end	
	end	
end)

function combocounting()
	combo=2
	coroutine.resume(coroutine.create(function()
		if combo>0 and counting==false then
			counting=true
			while combo>0 do
				wait(.1)
				combo=combo-.1
			end
			counting=false
			attackframe=1
		end
	end))
end

game:GetService("RunService").RenderStepped:connect(function()
	coroutine.resume(coroutine.create(function()
		if attackframe==4 then
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
	DealDamage:FireServer(model.Humanoid,(value+damage-armor),script.Parent.Name)
end

function damage(model)
	if alreadyHit(model)==false then
		table.insert(hits, 1, model)
		game.ReplicatedStorage:WaitForChild("AddCritical"):FireServer(game.Players.LocalPlayer.Character.Critical,critgain,script.Parent.Name)
		pain(model, basedmg)
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
