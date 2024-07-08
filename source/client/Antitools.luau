wait()
local player=game.Players.LocalPlayer
repeat wait() until player.Character ~= nil
local char=player.Character
local admins=game.Workspace.BanScript.Admins:GetChildren()

function sendmessage(player, text)
	local msg=game.Workspace.BanScript.ServerMessage:Clone()
	msg.Text.Value=text
	msg.Color.Value=Color3.new(1, 1, 1)
	msg.Parent=player.PlayerGui
end

player.Backpack.ChildAdded:connect(function(object)
	if (object.Name=="Delete" or object.Name=="Drag" or object.Name=="Clone" or object.Name=="Move") and _G.findInTable(admins, player.Name)==false then
		player:Kick("You had something you weren't supposed to")
	end			
	local totalobj=0
	for i, objects in pairs(player.Backpack:GetChildren()) do
		totalobj=i
	end
	if totalobj>6 and _G.findInTable(admins, player.Name)==false then
		player.Character.Humanoid.Health=0
		sendmessage(player, "You were killed due to having too many items")
	end
end)

char.Humanoid.HealthChanged:connect(function()
	print("changed")
	if char.Humanoid.MaxHealth>2000 then
		char.Humanoid.Health=0
		sendmessage(player, "Don't be changing your health boi")
	end
end)
