wait()
script.Name="Antilag"
local player=game.Players.LocalPlayer
repeat wait() until player.Character ~= nil
local character=player.Character
--setting states
character.Humanoid:SetStateEnabled(0, false)
character.Humanoid:SetStateEnabled(1, false)
character.Humanoid:SetStateEnabled(4, false)

print("antilagging")
game:GetService("RunService").RenderStepped:connect(function()
    character.HumanoidRootPart.CFrame=character.HumanoidRootPart.CFrame+Vector3.new(math.random(-100, 100)/1000000, 0, 0)
end)
