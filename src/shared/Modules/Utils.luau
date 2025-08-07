local RunService = game:GetService("RunService")

local Utils = {}
Utils.Rainbows = {}

Utils.Prefixes = {
	"K",
	"M",
	"B",
	"T",
	"Qd",
	"Qn",
	"Sx",
	"Sp",
	"Oc",
	"No",
	"De",
	"UDe",
	"DDe",
	"TDe",
	"QtDe",
	"QnDe",
	"SxDe",
	"SpDe",
	"OcDe",
	"NoDe",
	"Vg",
	"UVg",
	"DVg",
	"TVg",
	"QdVg",
	"QnVg",
	"SxVg",
	"SpVg",
	"OcVg",
	"NoVg",
	"Tg",
	"UTg",
	"DTg",
	"TTg",
	"QdTg",
	"QnTg",
	"SxTg",
	"SpTg",
	"OcTg",
	"NoTg",
	"qg",
	"Uqg",
	"Dqg",
	"Tqg",
	"Qdqg",
	"Qnqg",
	"Sxqg",
	"Spqg",
	"Ocqg",
	"Noqg",
	"Qg",
	"UQg",
	"DQg",
	"TQg",
	"QdQg",
	"QnQg",
	"SxQg",
	"SpQg",
	"OcQg",
	"NoQg",
	"sg",
	"Usg",
	"Dsg",
	"Tsg",
	"Qdsg",
	"Qnsg",
	"Sxsg",
	"Spsg",
	"Ocsg",
	"Nosg",
	"Sg",
	"USg",
	"DSg",
	"TSg",
	"QdSg",
	"QnSg",
	"SxSg",
	"SpSg",
	"OcSg",
	"NoSg",
	"Og",
	"UOg",
	"DOg",
	"TOg",
	"QdOg",
	"QnOg",
	"SxOg",
	"SpOg",
	"OcOg",
	"NoOg",
	"Ng",
	"UNg",
	"DNg",
	"TNg",
	"QdNg",
	"QnNg",
	"SxNg",
	"SpNg",
	"OcNg",
	"NoNg",
	"Ce",
	"UCe",
}

function Utils.CutDigits(x, digits)
	if x - math.floor(x) == 0 then
		return x
	end

	return string.format("%." .. digits .. "f", x)
end

function Utils.en(number, digits)
	if number == math.huge then
		return "inf"
	end

	if number == 0 then
		return number
	end
	if number < 1 then
		return Utils.CutDigits(number)
	end

	number = (number < 0 and math.abs(number)) or number
	digits = digits or 2

	local suffix = math.floor(math.log10(number) / 3)

	return Utils.CutDigits(number / 1000 ^ suffix, digits) .. (Utils.Prefixes[math.floor(suffix)] or "")
end

function Utils.TypeWrite(TextValue, Msg)
	for i = 1, #Msg do
		TextValue:set(string.sub(Msg, 1, i))
		task.wait(0.05)
	end
end

function Utils.TweenModel(EndCFrame, TI, Model)
	local NewCFrameValue = Instance.new("CFrameValue")
	NewCFrameValue.Value = Model.PrimaryPart.CFrame
	local Tween = game:GetService("TweenService"):Create(NewCFrameValue, TI, { Value = EndCFrame })
	local Connection
	Connection = NewCFrameValue.Changed:Connect(function()
		Model:PivotTo(NewCFrameValue.Value)
	end)
	Tween:Play()
	Tween.Completed:Connect(function()
		NewCFrameValue:Destroy()
		Connection:Disconnect()
	end)

	return Tween
end

function Utils.HasProperty(Instance, Property)
	local _, Succ = xpcall(function()
		Instance[Property] = Instance[Property]
		return true
	end, function()
		return false
	end)
	return Succ
end

--Rolls a random value in the table value needs to have a Weight:Number parameter
function Utils.Roll(Table, Luck)
	Luck = 1 + ((Luck or 0) / 10)

	local x = 1
	Table = table.clone(Table)

	for i, v in Table do
		if type(i) == "number" then
			continue
		end
		Table[x] = v
		Table[i] = nil
		x += 1
	end

	table.sort(Table, function(a, b)
		return a.Weight < b.Weight
	end)

	local total = 0

	for _, v in Table do
		total += v.Weight * 10
	end

	local rand = math.random(1, total) / Luck

	local cumulative = 0

	for _, v in Table do
		cumulative += v.Weight * 10
		if rand <= cumulative then
			return v
		end
	end

	return Table[1]
end

Utils.Time = function(val)
	if not tonumber(val) then
		return val
	end

	if val == 0 then
		return "00:00"
	end
	local days = math.floor(val / 86400)
	val = val - days * 86400

	local hours = math.floor(val / 3600)
	val = val - hours * 3600

	local mins = math.floor(val / 60)
	val = val - mins * 60

	val = val > 0 and math.floor(val) or ""

	return (days > 0 and days or "")
		.. (hours > 0 and ":" .. hours or "")
		.. (mins > 0 and mins or "00")
		.. ":"
		.. ((val ~= "" and val < 10) and "0" or "")
		.. (val ~= "" and val or "00")
end

Utils.Rainbow = function(TextLabel: Instance)
	if not (Utils.HasProperty(TextLabel, "TextColor3") or Utils.HasProperty(TextLabel, "Color")) then
		return
	end
	table.insert(Utils.Rainbows, TextLabel)
	TextLabel.Destroying:Connect(function()
		table.remove(Utils.Rainbows, table.find(Utils.Rainbows, TextLabel))
	end)

	return Color3.new(1, 1, 1)
end

Utils.MultiPlier = function()
	return 1
end

local ColorValue = 0

RunService.Heartbeat:Connect(function(delta)
	for _, v in Utils.Rainbows do
		v[Utils.HasProperty(v, "TextColor3") and "TextColor3" or "Color"] = Color3.fromHSV(ColorValue, 1, 0.7)
		ColorValue = (ColorValue + delta * 0.1) % 1
		if v:FindFirstChild("UIStroke") then
			v.UIStroke.Color = Color3.fromHSV(ColorValue, 1, 0.3)
		end
	end
end)

return Utils :: typeof(Utils)
