--put in streak num value 
while true do
	local main = script.Parent.Parent
	wait()
	if script.Parent.Value == 2 then
		wait(0.5)
		if script.Parent.Value == 2 then
			main.DoubleKill:Play()
			wait(2)
		end
	end
	if script.Parent.Value == 3 then
		wait(0.5)
		if script.Parent.Value == 3 then
			main.TripleKill:Play()
			wait(2)
		end
	end
	if script.Parent.Value == 4 then
		wait(0.5)
		if script.Parent.Value == 4 then
			main.MegaKill:Play()
			wait(2)
		end
	end
	if script.Parent.Value == 5 then
		wait(0.5)
		if script.Parent.Value == 5 then
			main.MonsterKill:Play()
			wait(2)
		end
	end
end
