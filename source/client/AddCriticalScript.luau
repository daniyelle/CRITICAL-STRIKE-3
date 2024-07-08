local AddCrit = game.ReplicatedStorage:WaitForChild("AddCritical")
while true do
	wait(2)
	local crit = script.Parent.Critical
		if script.Parent.CritEnable.Value == true then
		if crit.Value >= 100 then crit.Value = 100 end
		AddCrit:FireServer(script.Parent.Critical,1,script.Name)
	end
end
