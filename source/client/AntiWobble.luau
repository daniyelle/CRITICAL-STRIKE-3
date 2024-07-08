char = script.Parent
char.Humanoid:SetStateEnabled(0,false)
char.Humanoid:SetStateEnabled(1,false)
char.Humanoid:SetStateEnabled(4,false)
function ontouch(hit)
	if hit:FindFirstChild("FFRemover") and hit.CanCollide == true then
		if char.Torso:FindFirstChild("BodyVelocity") and char.Torso.BodyVelocity.Velocity ~= Vector3.new(0, 0, 0) then
			char.Torso.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
		end
	end
end
script.Parent.Head.Touched:connect(ontouch)
script.Parent.Torso.Touched:connect(ontouch)
script.Parent["Left Arm"].Touched:connect(ontouch)
script.Parent["Right Arm"].Touched:connect(ontouch)
