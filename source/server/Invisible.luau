while true do
	wait()
	local s = script.Parent.Parent.Parent.Ult.Middle.Stealth
	if s.Value == true then
		script.Parent.Transparency = 1
	else
		script.Parent.Transparency = 0
	end
end
