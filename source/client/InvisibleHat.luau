local player=game.Players.LocalPlayer
local char=player.Character
local s=nil
for _, objects in pairs(char:GetChildren()) do
	if objects.ClassName=="Accessory" then
		objects.Handle.CustomPhysicalProperties = PhysicalProperties.new(0,1,0,1,1)
	end
end
while wait() do
    for _, objects in pairs(char:GetChildren()) do
        if  char:FindFirstChild("Ult")~=nil then
            s=char.Ult.Middle:FindFirstChild("Stealth")
        end
        if objects.ClassName=="Accessory" and s~=nil then
            if s.Value==true then
                objects.Handle.Transparency=1
            else
                objects.Handle.Transparency=0
            end
        end
    end
end
