print("Loading Globals")
wait(1)
local player=game.Players.LocalPlayer
while player.Character==nil do
	wait()
end
local char=player.Character
local debugmode=false

_G.setLifeTime=function(object, lifetime)
	game:GetService("Debris"):AddItem(object, lifetime)
end

_G.sameTeam=function(model)
	if (model:FindFirstChild("Red") and char.Team.Value == 1) or (model:FindFirstChild("Blue") and char.Team.Value == 2) or (model:FindFirstChild("Friendly")) or (model:findFirstChild("ForceField")) then 
		return true
	else
		return false
	end
end

_G.hitBox=function(model, position, range)	
	if debugmode then
		local box=Instance.new("Part")
		box.Size=Vector3.new(range*2, range*2, range*2)
		box.Position=position
		box.BrickColor=BrickColor.new(21)
		box.Transparency=.8
		box.TopSurface="Smooth"
		box.BottomSurface="Smooth"
		box.CanCollide=false
		box.Shape="Ball"
		box.Anchored=true
		_G.setLifeTime(box, .5)
		box.Parent=game.Workspace
	end	
	if (model:FindFirstChild("Red") and char.Team.Value == 1) or (model:FindFirstChild("Blue") and char.Team.Value == 2) or (model:FindFirstChild("Friendly")) or (model:findFirstChild("ForceField")) then 
		return false
	end
	for _, parts in pairs(model:GetChildren()) do
		if parts.ClassName=="Part" then
			local pos=parts.Position
			if (parts.Position-position).magnitude<=range then
				return parts.Name				
			elseif (parts.Position-position).magnitude>=(range+parts.Size.magnitude)*11 then
				return false
			end
		end
	end
	return false
end

_G.hitBoxAll=function(model, position, range)	
	if debugmode then
		local box=Instance.new("Part")
		box.Size=Vector3.new(range*2, range*2, range*2)
		box.Position=position
		box.BrickColor=BrickColor.new(21)
		box.Transparency=.8
		box.TopSurface="Smooth"
		box.BottomSurface="Smooth"
		box.CanCollide=false
		box.Shape="Ball"
		box.Anchored=true
		_G.setLifeTime(box, .5)
		box.Parent=game.Workspace
	end	
	if ((model:FindFirstChild("Red") and char.Team.Value == 1) or (model:FindFirstChild("Blue") and char.Team.Value == 2) or (model:findFirstChild("ForceField"))) and model~=char then 
		print('returning false from 1')
		return false
	end
	for _, parts in pairs(model:GetChildren()) do
		if parts.ClassName=="Part" and (parts.Name == "HumanoidRootPart") then
			if (parts.Position-position).magnitude<=range then
				print('returning true')
				return parts
			elseif (parts.Position-position).magnitude>=range*11 then
				print('returning false from 2')
				return false
			end
		end
	end
	return false
end

_G.notStunned=function()
	if char.Head:FindFirstChild("Disable")==nil and char.Humanoid.Health>0 then
		return true
	else
		return false
	end
end
_G.findInTable=function(tabl, name)
	for _, tablman in pairs(tabl) do
		if tablman==name then
			return true
		end
	end
	return false
end

_G.addCritical=function(value)
	if char.CritEnable.Value == true then
		game.ReplicatedStorage:WaitForChild("AddCritical"):FireServer(char.Critical,value)
	end
end

_G.characterofplayer = function(playerName)
	return workspace:FindFirstChild(playerName)
end

_G.weldTogether=function(a, b)
	local weld = Instance.new("ManualWeld")
	weld.Name="Weld"
    weld.Part0 = a
    weld.Part1 = b
    weld.C0 = a.CFrame:inverse() * b.CFrame
    weld.Parent=a
end
