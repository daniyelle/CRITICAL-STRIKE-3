modelname="place"

function onTouched(part)
	if part.Parent ~= nil then
	local h = part.Parent:findFirstChild("Humanoid")
		if h~=nil then
			local teleportfrom=script.Parent.Enabled.Value
			if teleportfrom~=0 then
				if h==humanoid then
				return
				end
				local teleportto=script.Parent.Parent.Parent:findFirstChild(modelname)
				if teleportto~=nil then
					local torso = h.Parent.Torso
					local location = {teleportto.Position}
					local i = 1

					local x = location[i].x
					local y = location[i].y
					local z = location[i].z
				
					x = x + math.random(-1, 1)
					z = z + math.random(-1, 1)
					y = y + math.random(2, 3)

					local cf = torso.CFrame
					local lx = 0
					local ly = y
					local lz = 0
					
					script.Parent.Enabled.Value=0
					teleportto.Enabled.Value=0
					torso.CFrame = CFrame.new(Vector3.new(x,y,z), Vector3.new(lx,ly,lz))
					script.Parent.Enabled.Value=1
					teleportto.Enabled.Value=1
				else
					print("Could not find teleporter!")
				end
			end
		end
	end
end

script.Parent.Touched:connect(onTouched)

function getPlayer(humanoid) 
local players = game.Players:children() 
for i = 1, #players do 
if players[i].Character.Humanoid == humanoid then return players[i] end 
end 
return nil 
end 

function onTouch(part) 

local human = part.Parent:findFirstChild("Humanoid") 
if (human == nil) then return end 

local player = getPlayer(human) 

if (player == nil) then return end 



game.Lighting.NAME:clone().Parent = player.Backpack  --Replace NAME with the weapon you put in Lighting.
wait(0.1)

end 

script.Parent.Touched:connect(onTouch)
