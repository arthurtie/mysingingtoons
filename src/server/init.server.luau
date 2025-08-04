local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Services = {}

for _, v in script:GetChildren() do
	local _, Service = pcall(function()
		return require(v)
	end)
	table.insert(Services, Service)
end

for _, v in Services do
	if v.Start then
		v:Start()
	end
end

for _, v in ReplicatedStorage.Shared.Components:GetChildren() do
	require(v)
end
