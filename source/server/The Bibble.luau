--used to cast Output Studio scripts
for _,p in ipairs(workspace["CROOM-SpecialClasses"]["Class-Shadow"]:GetChildren()) do
	if p.ClassName=="Model" then
		for _,a in ipairs(p:GetChildren()) do
			if a.ClassName=="Model" then
				for _,b in ipairs(a:GetChildren()) do
					if b:FindFirstChild("Invisible") then
						b.Invisible:Destroy()
						local clone=game.Lighting.Invisible:Clone()
						clone.Parent=b
					end
				end
			end
			if a:FindFirstChild("Invisible") then
				a.Invisible:Destroy()
				local clone=game.Lighting.Invisible:Clone()
				clone.Parent=a
			end
		end
	end
end
