local Menu = {}

Menu.Colors = {
	["blue"] = {
		["Name"] = "blue",
		["Color"] = 'rgb(29, 165, 255)'
	},
	["red"] = {
		["Name"] = "red",
		["Color"] = 'rgb(204, 0, 0)'
	},
	["green"] = {
		["Name"] = "green",
		["Color"] = 'rgb(27, 199, 105)'
	},
	["yellow"] = {
		["Name"] = "yellow",
		["Color"] = 'rgb(255, 221, 28)'
	},
	["orange"] = {
		["Name"] = "orange",
		["Color"] = 'rgb(255, 140, 39)'
	},
	["gray"] = {
		["Name"] = "gray",
		["Color"] = 'rgb(126, 126, 126)'
	},
	["black"] = {
		["Name"] = "black",
		["Color"] = 'rgb(50, 50, 50)'
	},
	["white"] = {
		["Name"] = "white",
		["Color"] = 'rgb(255, 255, 255)'
	}
}

Menu.Positions = {
	["topleft"] = {
		["Name"] = "topleft",
		["Position"] = {
			["xScale"] = 0.006,
			["xOffset"] = 0,
			["yScale"] = 0.014,
			["yOffset"] = 0
		},
		["TextXAlignment"] = Enum.TextXAlignment.Left
	},
	["bottommiddle"] = {
		["Name"] = "bottommiddle",
		["Position"] = {
			["xScale"] = 0.396,
			["xOffset"] = 0,
			["yScale"] = 0.81,
			["yOffset"] = 0
		},
		["TextXAlignment"] = Enum.TextXAlignment.Center
	},
}

local Selected = nil
local selected = nil
local selected_ = nil
local keybindtoggle = false

local UIS = game:GetService("UserInputService")

function Tween(instance, goal)
	local TweenService = game:GetService("TweenService")

	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)

	local tween = TweenService:Create(instance, tweenInfo, goal)
	tween:Play()

	return tween
end

function PlaySound(parent)
	local Sound = Instance.new("Sound")
	Sound.Name = "UILibrarySound"
	Sound.Parent = parent or game.Players.LocalPlayer.Character
	Sound.SoundId = "rbxassetid://226892749"
	Sound.Volume = 0.25
	Sound:Play()

	task.delay(Sound.TimeLength + 0.5, function()
		Sound:Destroy()
	end)
end

local Queue = {}
local Queue2 = {}
local Cooldown = false
local Cooldown2 = false

function count(base, pattern)
	return select(2, string.gsub(base, pattern, ""))
end

function CheckSameString(Table, String)
	local Found = false

	for i,v in pairs(Table) do
		if v[1] == String then
			Found = true
		end
	end

	return Found
end

function notification(Notification)
	if Queue[1] and not Cooldown and Notification then
		Cooldown = true

		if Queue[1][3] then
			Notification.BackgroundTransparency = 0.4
		end

		local RemoveLength = 0
		local Found = 0

		for i,v in pairs(Menu.Colors) do
			if Found > 0 then
				if string.find(Notification.TextLabel.Text, '<colorstart:'..v["Name"]..'>') and string.find(Notification.TextLabel.Text, '<colorend:'..v["Name"]..'>') then
					local NewString = ""
					local Count = count(Notification.TextLabel.Text, '<colorstart:'..v["Name"]..'>')

					local Length = (23 + (string.len(v["Name"]) * 2))

					NewString = Notification.TextLabel.Text:gsub('<colorstart:'..v["Name"]..'>', '<mark><font color="'..v["Color"]..'">')
					NewString = NewString:gsub('<colorend:'..v["Name"]..'>', '</font></mark>')

					Notification.TextLabel.Text = NewString

					RemoveLength += (Count * Length)
					Found += (Count * 1)
				end
			elseif Found == 0 then
				if string.find(Queue[1][1], '<colorstart:'..v["Name"]..'>') and string.find(Queue[1][1], '<colorend:'..v["Name"]..'>') then
					local NewString = ""
					local Count = count(Queue[1][1], '<colorstart:'..v["Name"]..'>')

					local Length = (23 + (string.len(v["Name"]) * 2))

					NewString = Queue[1][1]:gsub('<colorstart:'..v["Name"]..'>', '<mark><font color="'..v["Color"]..'">')
					NewString = NewString:gsub('<colorend:'..v["Name"]..'>', '</font></mark>')

					Notification.TextLabel.Text = NewString

					RemoveLength += (Count * Length)
					Found += (Count * 1)
				end
			end
		end

		local Size = tonumber(math.floor((string.len(Queue[1][1]) - RemoveLength) / 41))

		Notification.Size += UDim2.new(0, 0, 0, Size * 26)
		Notification.TextLabel.Size += UDim2.new(0, 0, 0, Size * 14)
		if Found == 0 then
			Notification.TextLabel.Text = Queue[1][1]
		end

		for i,v in pairs(Menu.Positions) do
			if Queue[1][4]:lower() == v["Name"] then
				Notification.Position = UDim2.new(v["Position"]["xScale"], v["Position"]["xOffset"], v["Position"]["yScale"], v["Position"]["yOffset"])
				Notification.TextLabel.TextXAlignment = v["TextXAlignment"]
			end
		end

		for i = Queue[1][2], 0, -1 do
			if i == 0 then
				Notification.TextLabel.Text = ""
				Notification.Size -= UDim2.new(0, 0, 0, Size * 26)
				Notification.TextLabel.Size -= UDim2.new(0, 0, 0, Size * 14)

				if Queue[1][3] then
					Tween(Notification, {BackgroundTransparency = 1})
				end

				task.delay(0.75, function()
					table.remove(Queue, 1)
					Notification.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
					Notification.Position = UDim2.new(0.006, 0, 0.014, 0)
					Cooldown = false
				end)
			end
			wait(1)
		end
	end
end

function alert(Alert)
	if Queue2[1] and not Cooldown2 and Alert then
		Cooldown2 = true

		if selected_ == nil then
			selected_ = 1
			Alert.Continue.ImageColor3 = Color3.fromRGB(255, 255, 255)
			Alert.Continue.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			Alert.Cancel.ImageColor3 = Color3.fromRGB(120, 120, 120)
			Alert.Cancel.TextLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
		end

		PlaySound()

		Alert.Visible = true

		local Size = tonumber(math.floor((string.len(Queue2[1][1])) / 67))

		Alert.Label.Size += UDim2.new(0, 0, 0, Size * 18)
		Alert.Label.Text = Queue2[1][1]

		Alert.BarD.Position += UDim2.new(0, 0, Size * 0.018, 0)

		Alert.Continue.MouseButton1Down:Connect(function()
			PlaySound()
			if selected_ ~= 1 then
				Alert.Continue.ImageColor3 = Color3.fromRGB(255, 255, 255)
				Alert.Continue.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				Alert.Cancel.ImageColor3 = Color3.fromRGB(120, 120, 120)
				Alert.Cancel.TextLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
				selected_ = 1
			else
				pcall(Queue2[1][2], selected_)
				Alert.Label.Text = ""
				Alert.Label.Size -= UDim2.new(0, 0, 0, Size * 18)
				Alert.BarD.Position -= UDim2.new(0, 0, Size * 0.018, 0)

				Alert.Visible = false

				task.delay(0.75, function()
					table.remove(Queue2, 1)
					Cooldown2 = false
					selected_ = nil
				end)
			end
		end)

		Alert.Cancel.MouseButton1Down:Connect(function()
			PlaySound()
			if selected_ ~= 2 then
				Alert.Cancel.ImageColor3 = Color3.fromRGB(255, 255, 255)
				Alert.Cancel.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				Alert.Continue.ImageColor3 = Color3.fromRGB(120, 120, 120)
				Alert.Continue.TextLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
				selected_ = 2
			else
				pcall(Queue2[1][2], selected_)
				Alert.Label.Text = ""
				Alert.Label.Size -= UDim2.new(0, 0, 0, Size * 18)
				Alert.BarD.Position -= UDim2.new(0, 0, Size * 0.018, 0)

				Alert.Visible = false

				task.delay(0.75, function()
					table.remove(Queue2, 1)
					Cooldown2 = false
					selected_ = nil
				end)
			end
		end)
	end
end

function Menu:Notify(String, Time, Background, Position)
	if CheckSameString(Queue, String) ~= true then
		table.insert(Queue, {String, Time, Background, Position})
	end
end
function Menu:Alert(String, callback)
	if CheckSameString(Queue2, String) ~= true then
		table.insert(Queue2, {String, callback})
	end
end

function Menu:Create(title, banner, description)
	if game.CoreGui:FindFirstChild(title) then
		game.CoreGui:FindFirstChild(title):Destroy()
	end

	if game.CoreGui:FindFirstChild(title.."_Notifications") then
		game.CoreGui:FindFirstChild(title.."_Notifications"):Destroy()
	end

	local UIMenu = Instance.new("ScreenGui")
	local NotificationMenu = Instance.new("ScreenGui")
	local Banner = Instance.new("ImageLabel")
	local Title = Instance.new("TextLabel")
	local Description = Instance.new("Frame")
	local Label = Instance.new("TextLabel")
	local Left = Instance.new("ImageButton")
	local Tabs = Instance.new("Folder")
	local MenuTab = Instance.new("Folder")
	local MenuItems = Instance.new("Folder")
	local MenuFrame = Instance.new("Frame")
	local MenuGrid = Instance.new("UIGridLayout")
	local Notification = Instance.new("Frame")
	local TextLabel = Instance.new("TextLabel")
	local Alert = Instance.new("Frame")
	local Alert_2 = Instance.new("ImageLabel")
	local BarU = Instance.new("Frame")
	local Label2 = Instance.new("TextLabel")
	local BarD = Instance.new("Frame")
	local Continue = Instance.new("ImageButton")
	local TextLabel_2 = Instance.new("TextLabel")
	local Cancel = Instance.new("ImageButton")
	local TextLabel_3 = Instance.new("TextLabel")

	UIMenu.Name = title
	UIMenu.IgnoreGuiInset = false
	UIMenu.Parent = game.CoreGui
	UIMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	NotificationMenu.Name = title.."_Notifications"
	NotificationMenu.IgnoreGuiInset = true
	NotificationMenu.Parent = game.CoreGui
	NotificationMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Alert.Name = "Alert"
	Alert.Parent = NotificationMenu
	Alert.Visible = false
	Alert.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Alert.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Alert.BorderSizePixel = 0
	Alert.Size = UDim2.new(1, 0, 1, 0)

	Alert_2.Name = "Alert"
	Alert_2.Parent = Alert
	Alert_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Alert_2.BackgroundTransparency = 1.000
	Alert_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Alert_2.BorderSizePixel = 0
	Alert_2.Position = UDim2.new(0.406382978, 0, 0.385551959, 0)
	Alert_2.Size = UDim2.new(0, 175, 0, 41)
	Alert_2.Image = "http://www.roblox.com/asset/?id=14326136571"
	Alert_2.ImageColor3 = Color3.fromRGB(255, 203, 15)

	BarU.Name = "BarU"
	BarU.Parent = Alert
	BarU.BackgroundColor3 = Color3.fromRGB(159, 159, 159)
	BarU.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BarU.BorderSizePixel = 0
	BarU.Position = UDim2.new(0.207446814, 0, 0.497159094, 0)
	BarU.Size = UDim2.new(0, 550, 0, 2)

	Label2.Name = "Label"
	Label2.Parent = Alert
	Label2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label2.BackgroundTransparency = 1.000
	Label2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Label2.BorderSizePixel = 0
	Label2.Position = UDim2.new(0.244680852, 0, 0.513392866, 0)
	Label2.Size = UDim2.new(0, 480, 0, 36)
	Label2.Font = Enum.Font.Nunito
	Label2.Text = ""
	Label2.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label2.TextSize = 18.000
	Label2.TextWrapped = true
	Label2.TextYAlignment = Enum.TextYAlignment.Top

	BarD.Name = "BarD"
	BarD.Parent = Alert
	BarD.BackgroundColor3 = Color3.fromRGB(159, 159, 159)
	BarD.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BarD.BorderSizePixel = 0
	BarD.Position = UDim2.new(0.206382975, 0, 0.562, 0)
	BarD.Size = UDim2.new(0, 550, 0, 2)

	Continue.Name = "Continue"
	Continue.Parent = Alert
	Continue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Continue.BackgroundTransparency = 1.000
	Continue.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Continue.BorderSizePixel = 0
	Continue.Position = UDim2.new(0.887234032, 0, 0.935470819, 0)
	Continue.Size = UDim2.new(0, 25, 0, 25)
	Continue.Image = "http://www.roblox.com/asset/?id=14334835725"

	TextLabel_2.Parent = Continue
	TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.BackgroundTransparency = 1.000
	TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_2.BorderSizePixel = 0
	TextLabel_2.Position = UDim2.new(-2, 0, 0.200000003, 0)
	TextLabel_2.Size = UDim2.new(0, 50, 0, 15)
	TextLabel_2.Font = Enum.Font.SourceSans
	TextLabel_2.Text = "Continue"
	TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.TextSize = 14.000

	Cancel.Name = "Cancel"
	Cancel.Parent = Alert
	Cancel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Cancel.BackgroundTransparency = 1.000
	Cancel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Cancel.BorderSizePixel = 0
	Cancel.Position = UDim2.new(0.967021286, 0, 0.935470819, 0)
	Cancel.Size = UDim2.new(0, 25, 0, 25)
	Cancel.Image = "http://www.roblox.com/asset/?id=5612339837"
	Cancel.ImageColor3 = Color3.fromRGB(120, 120, 120)

	TextLabel_3.Parent = Cancel
	TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_3.BackgroundTransparency = 1.000
	TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_3.BorderSizePixel = 0
	TextLabel_3.Position = UDim2.new(-2, 0, 0.200000003, 0)
	TextLabel_3.Size = UDim2.new(0, 50, 0, 15)
	TextLabel_3.Font = Enum.Font.SourceSans
	TextLabel_3.Text = "Cancel"
	TextLabel_3.TextColor3 = Color3.fromRGB(120, 120, 120)
	TextLabel_3.TextSize = 14.000

	Notification.Name = "Notification"
	Notification.Parent = NotificationMenu
	Notification.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	Notification.BackgroundTransparency = 1.000
	Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Notification.BorderSizePixel = 0
	Notification.Position = UDim2.new(0.781, 0, 0.012, 0)
	Notification.Size = UDim2.new(0, 200, 0, 26)
	Notification.ZIndex = 2

	TextLabel.Parent = Notification
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.0299999993, 0, 0.223077044, 0)
	TextLabel.Size = UDim2.new(0, 194, 0, 14)
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.Text = ""
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 14.000
	TextLabel.TextStrokeTransparency = 0.500
	TextLabel.TextWrapped = true
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.TextYAlignment = Enum.TextYAlignment.Top

	Banner.Name = "Banner"
	Banner.Parent = UIMenu
	Banner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Banner.BackgroundTransparency = 1.000
	Banner.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Banner.BorderSizePixel = 0
	Banner.Position = UDim2.new(0.00624479586, 0, 0.0121753253, 0)
	Banner.Size = UDim2.new(0, 200, 0, 50)
	Banner.Image = banner or "http://www.roblox.com/asset/?id=14299630623"

	if string.lower(banner) == "default" or string.lower(banner) == "normal" then
		Banner.Image = "http://www.roblox.com/asset/?id=14299630623"
	end

	Title.Name = "Title"
	Title.Parent = Banner
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title.BorderSizePixel = 0
	Title.Size = UDim2.new(0, 200, 0, 50)
	Title.Font = Enum.Font.PatrickHand
	Title.Text = title or ""
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 32.000
	Title.TextWrapped = true

	Description.Name = "Description"
	Description.Parent = Banner
	Description.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	Description.BackgroundTransparency = 0.050
	Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Description.BorderSizePixel = 0
	Description.Position = UDim2.new(0, 0, 1, 0)
	Description.Size = UDim2.new(0, 200, 0, 25)

	Label.Name = "Label"
	Label.Parent = Description
	Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label.BackgroundTransparency = 1.000
	Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Label.BorderSizePixel = 0
	Label.Position = UDim2.new(0.0299999993, 0, 0, 0)
	Label.Size = UDim2.new(0, 165, 0, 25)
	Label.Font = Enum.Font.Roboto
	Label.Text = description
	Label.TextColor3 = Color3.fromRGB(118, 196, 255)
	Label.TextSize = 14.000
	Label.TextWrapped = true
	Label.TextXAlignment = Enum.TextXAlignment.Left

	Left.Name = "Left"
	Left.Parent = Description
	Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Left.BackgroundTransparency = 1.000
	Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Left.BorderSizePixel = 0
	Left.Position = UDim2.new(0.894999981, 0, 0.180000007, 0)
	Left.Size = UDim2.new(0, 15, 0, 15)
	Left.ZIndex = 2
	Left.Image = "rbxassetid://2418687610"
	Left.Visible = false

	Tabs.Name = "Tabs"
	Tabs.Parent = Banner

	MenuTab.Name = title
	MenuTab.Parent = Tabs

	MenuItems.Name = "Items"
	MenuItems.Parent = MenuTab

	MenuFrame.Parent = MenuItems
	MenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuFrame.BackgroundTransparency = 1.000
	MenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuFrame.BorderSizePixel = 0
	MenuFrame.Position = UDim2.new(0, 0, 1.5, 0)
	MenuFrame.Size = UDim2.new(0, 200, 0, 25)

	MenuGrid.Parent = MenuFrame
	MenuGrid.SortOrder = Enum.SortOrder.LayoutOrder
	MenuGrid.CellPadding = UDim2.new(0, 0, 0, 0)
	MenuGrid.CellSize = UDim2.new(0, 200, 0, 25)

	game:GetService("RunService").Heartbeat:Connect(function()
		if Queue[1] and not Cooldown then
			notification(Notification)
		elseif Queue2[1] and not Cooldown2 then
			Banner.Visible = false
			alert(Alert)
		end
		if not Queue2[1] and not Cooldown2 then
			Banner.Visible = true
		end
	end)

	local tabs = {}

	UIS.InputBegan:Connect(function(input, gpe)
		if gpe then
			return
		end

		if UIMenu == nil then
			return
		end
			
		if not UIMenu.Enabled and not Queue2[1] then
			return	
		end	

		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.Up then
				if Selected ~= nil then
					PlaySound()
					if Selected > 1 and tabs[Selected] then
						for _,instance in pairs(tabs[Selected][1]) do
							if tabs[Selected][2][instance.Name] then
								Tween(instance, tabs[Selected][2][instance.Name]["Original"])
							end
						end
						Selected -= 1
						for _,instance in pairs(tabs[Selected][1]) do
							if tabs[Selected][2][instance.Name] then
								Tween(instance, tabs[Selected][2][instance.Name]["TweenGoal"])
							end
						end
					elseif Selected >= 1 and tabs[Selected] then
						for _,instance in pairs(tabs[Selected][1]) do
							if tabs[Selected][2][instance.Name] then
								Tween(instance, tabs[Selected][2][instance.Name]["Original"])
							end
						end
						Selected = #tabs
						for _,instance in pairs(tabs[Selected][1]) do
							if tabs[Selected][2][instance.Name] then
								Tween(instance, tabs[Selected][2][instance.Name]["TweenGoal"])
							end
						end
					end
				end
			elseif input.KeyCode == Enum.KeyCode.Down then
				if Selected ~= nil then
					PlaySound()
					if Selected < #tabs and tabs[Selected] then
						for _,instance in pairs(tabs[Selected][1]) do
							if tabs[Selected][2][instance.Name] then
								Tween(instance, tabs[Selected][2][instance.Name]["Original"])
							end
						end
						Selected += 1
						for _,instance in pairs(tabs[Selected][1]) do
							if tabs[Selected][2][instance.Name] then
								Tween(instance, tabs[Selected][2][instance.Name]["TweenGoal"])
							end
						end
					elseif Selected <= #tabs and tabs[Selected] then
						for _,instance in pairs(tabs[Selected][1]) do
							if tabs[Selected][2][instance.Name] then
								Tween(instance, tabs[Selected][2][instance.Name]["Original"])
							end
						end
						Selected = 1
						for _,instance in pairs(tabs[Selected][1]) do
							if tabs[Selected][2][instance.Name] then
								Tween(instance, tabs[Selected][2][instance.Name]["TweenGoal"])
							end
						end
					end
				end
			elseif input.KeyCode == Enum.KeyCode.Return then
				if Queue2[1] and Cooldown2 then
					PlaySound()

					local Size = tonumber(math.floor((string.len(Queue2[1][1])) / 67))

					if selected_ ~= 1 then
						Alert.Continue.ImageColor3 = Color3.fromRGB(255, 255, 255)
						Alert.Continue.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						Alert.Cancel.ImageColor3 = Color3.fromRGB(120, 120, 120)
						Alert.Cancel.TextLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
						selected_ = 1
					else
						pcall(Queue2[1][2], selected_)
						Alert.Label.Text = ""
						Alert.Label.Size -= UDim2.new(0, 0, 0, Size * 18)

						Alert.BarD.Position -= UDim2.new(0, 0, Size * 0.018, 0)

						Alert.Cancel.ImageColor3 = Color3.fromRGB(255, 255, 255)
						Alert.Cancel.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

						Alert.Continue.ImageColor3 = Color3.fromRGB(255, 255, 255)
						Alert.Continue.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

						Alert.Visible = false

						task.delay(0.75, function()
							table.remove(Queue2, 1)
							Cooldown2 = false
							selected_ = nil
						end)
					end
				else
					if Selected ~= nil then
						PlaySound()
						if tabs[Selected] then
							if tabs[Selected]["Menu"] then
								for _,Tab in pairs(Tabs:GetChildren()) do
									if Tab.Name == tabs[Selected]["Title"] then
										Tab:FindFirstChild("Items"):FindFirstChild("Frame").Visible = true
										Left.Visible = true
									else
										Tab:FindFirstChild("Items"):FindFirstChild("Frame").Visible = false
									end
								end
							end
						end
					end
				end
			elseif input.KeyCode == Enum.KeyCode.Backspace then
				if Queue2[1] and Cooldown2 then
					PlaySound()

					local Size = tonumber(math.floor((string.len(Queue2[1][1])) / 67))

					if selected_ ~= 2 then
						Alert.Cancel.ImageColor3 = Color3.fromRGB(255, 255, 255)
						Alert.Cancel.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						Alert.Continue.ImageColor3 = Color3.fromRGB(120, 120, 120)
						Alert.Continue.TextLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
						selected_ = 2
					else
						pcall(Queue2[1][2], selected_)
						Alert.Label.Text = ""
						Alert.Label.Size -= UDim2.new(0, 0, 0, Size * 18)

						Alert.Cancel.ImageColor3 = Color3.fromRGB(255, 255, 255)
						Alert.Cancel.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

						Alert.Continue.ImageColor3 = Color3.fromRGB(255, 255, 255)
						Alert.Continue.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

						Alert.BarD.Position -= UDim2.new(0, 0, Size * 0.018, 0)

						Alert.Visible = false

						task.delay(0.75, function()
							table.remove(Queue2, 1)
							Cooldown2 = false
							selected_ = nil
						end)
					end
				else
					for _,Tab in pairs(Tabs:GetChildren()) do
						if Tab.Name == title then
							Tab:FindFirstChild("Items"):FindFirstChild("Frame").Visible = true
							Left.Visible = false
						else
							Tab:FindFirstChild("Items"):FindFirstChild("Frame").Visible = false
						end
					end
				end
			end
		end
	end)

	function tabs:CreateTab(title_, banner_, description_)
		local MenuItem = Instance.new("TextButton")
		local Label_7 = Instance.new("TextLabel")
		local Right_3 = Instance.new("ImageLabel")
		local Tab = Instance.new("Folder")
		local Items = Instance.new("Folder")
		local TabFrame = Instance.new("Frame")
		local UIGridLayout = Instance.new("UIGridLayout")

		Tabs.Name = "Tabs"
		Tabs.Parent = Banner

		Tab.Name = title_
		Tab.Parent = Tabs

		Items.Name = "Items"
		Items.Parent = Tab

		TabFrame.Parent = Items
		TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabFrame.BackgroundTransparency = 1.000
		TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabFrame.BorderSizePixel = 0
		TabFrame.Position = UDim2.new(0, 0, 1.5, 0)
		TabFrame.Size = UDim2.new(0, 200, 0, 25)
		TabFrame.Visible = false

		UIGridLayout.Parent = TabFrame
		UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIGridLayout.CellPadding = UDim2.new(0, 0, 0, 0)
		UIGridLayout.CellSize = UDim2.new(0, 200, 0, 25)

		MenuItem.Name = "MenuItem"
		MenuItem.Parent = MenuFrame
		MenuItem.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
		MenuItem.BackgroundTransparency = 0.200
		MenuItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuItem.BorderSizePixel = 0
		MenuItem.Position = UDim2.new(0, 0, 1.48199999, 0)
		MenuItem.Size = UDim2.new(0, 200, 0, 25)
		MenuItem.AutoButtonColor = false
		MenuItem.Font = Enum.Font.Unknown
		MenuItem.Text = ""
		MenuItem.TextColor3 = Color3.fromRGB(255, 255, 255)
		MenuItem.TextSize = 16.000
		MenuItem.TextXAlignment = Enum.TextXAlignment.Left

		Label_7.Name = "Label_7"
		Label_7.Parent = MenuItem
		Label_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Label_7.BackgroundTransparency = 1.000
		Label_7.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Label_7.BorderSizePixel = 0
		Label_7.Position = UDim2.new(0.0299999993, 0, 0, 0)
		Label_7.Size = UDim2.new(0, 173, 0, 25)
		Label_7.Font = Enum.Font.Roboto
		Label_7.Text = title_
		Label_7.TextColor3 = Color3.fromRGB(255, 255, 255)
		Label_7.TextSize = 14.000
		Label_7.TextWrapped = true
		Label_7.TextXAlignment = Enum.TextXAlignment.Left

		Right_3.Name = "Right_3"
		Right_3.Parent = MenuItem
		Right_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Right_3.BackgroundTransparency = 1.000
		Right_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Right_3.BorderSizePixel = 0
		Right_3.Position = UDim2.new(0.894999981, 0, 0.200000003, 0)
		Right_3.Size = UDim2.new(0, 15, 0, 15)
		Right_3.Image = "rbxassetid://2418686949"

		local items = {}

		table.insert(tabs, {
			{
				MenuItem, Label_7, Right_3
			},
			{
				["MenuItem"] = {
					["Original"] = {
						BackgroundTransparency = 0.2,
						BackgroundColor3 = Color3.fromRGB(29, 29, 29)
					},
					["TweenGoal"] = {
						BackgroundTransparency = 0,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					}
				},
				["Label_7"] = {
					["Original"] = {
						TextColor3 = Color3.fromRGB(255, 255, 255)
					},
					["TweenGoal"] = {
						TextColor3 = Color3.fromRGB(0, 0, 0)
					}
				},
				["Right_3"] = {
					["Original"] = {
						ImageColor3 = Color3.fromRGB(255, 255, 255)
					},
					["TweenGoal"] = {
						ImageColor3 = Color3.fromRGB(0, 0, 0)
					}
				}
			},
			["Menu"] = "Menu",
			["Title"] = title_,
			["Banner"] = banner_,
			["Description"] = description_
		})
		local index = #tabs

		if Selected == nil and tabs[2] == nil then
			Selected = 1
			for _,instance in pairs(tabs[Selected][1]) do
				if tabs[Selected][2][instance.Name] then
					Tween(instance, tabs[Selected][2][instance.Name]["TweenGoal"])
				end
			end
		end

		MenuItem.MouseButton1Down:Connect(function()
			if Selected ~= nil then
				PlaySound(game.Players.LocalPlayer.Character)
				if Selected ~= index then
					for _,instance in pairs(tabs[Selected][1]) do
						if tabs[Selected][2][instance.Name] then
							Tween(instance, tabs[Selected][2][instance.Name]["Original"])
						end
					end
					Selected = index
					for _,instance in pairs(tabs[Selected][1]) do
						if tabs[Selected][2][instance.Name] then
							Tween(instance, tabs[Selected][2][instance.Name]["TweenGoal"])
						end
					end
				elseif Selected == index then
					for _,Tab in pairs(Tabs:GetChildren()) do
						if Tab.Name == tabs[index]["Title"] then
							Tab:FindFirstChild("Items"):FindFirstChild("Frame").Visible = true
							Label.Text = tabs[index]["Description"]
							Left.Visible = true
							Title.Text = tabs[index]["Title"]
						else
							Tab:FindFirstChild("Items"):FindFirstChild("Frame").Visible = false
						end
					end
				end
			end
		end)

		Left.MouseButton1Down:Connect(function()
			if Selected == index then
				for _,Tab in pairs(Tabs:GetChildren()) do
					if Tab.Name == title then
						Tab:FindFirstChild("Items"):FindFirstChild("Frame").Visible = true
						Left.Visible = false
						PlaySound(game.Players.LocalPlayer.Character)
					else
						Tab:FindFirstChild("Items"):FindFirstChild("Frame").Visible = false
					end
				end
			end
		end)

		UIS.InputBegan:Connect(function(input, gpe)
			if gpe then
				return
			end

			if UIMenu == nil then
				return
			end

			if not UIMenu.Enabled and not Queue2[1] then
				return	
			end	

			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Up then
					if selected ~= nil then
						if selected > 1 and items[selected] then
							for _,instance in pairs(items[selected][1]) do
								if items[selected][2][instance.Name] then
									Tween(instance, items[selected][2][instance.Name]["Original"])
								end
							end
							selected -= 1
							for _,instance in pairs(items[selected][1]) do
								if items[selected][2][instance.Name] then
									Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
								end
							end
						elseif selected >= 1 and items[selected] then
							for _,instance in pairs(items[selected][1]) do
								if items[selected][2][instance.Name] then
									Tween(instance, items[selected][2][instance.Name]["Original"])
								end
							end
							selected = #items
							for _,instance in pairs(items[selected][1]) do
								if items[selected][2][instance.Name] then
									Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
								end
							end
						end
					end
				elseif input.KeyCode == Enum.KeyCode.Down then
					if selected ~= nil then
						if selected < #items and items[selected] then
							for _,instance in pairs(items[selected][1]) do
								if items[selected][2][instance.Name] then
									Tween(instance, items[selected][2][instance.Name]["Original"])
								end
							end
							selected += 1
							for _,instance in pairs(items[selected][1]) do
								if items[selected][2][instance.Name] then
									Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
								end
							end
						elseif selected <= #items and items[selected] then
							for _,instance in pairs(items[selected][1]) do
								if items[selected][2][instance.Name] then
									Tween(instance, items[selected][2][instance.Name]["Original"])
								end
							end
							selected = 1
							for _,instance in pairs(items[selected][1]) do
								if items[selected][2][instance.Name] then
									Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
								end
							end
						end
					end
				elseif input.KeyCode == Enum.KeyCode.Return then
					if selected ~= nil then
						if items[selected] then
							if items[selected]["Button"] then
								pcall(items[selected]["Callback"])
							elseif items[selected]["Toggle"] then
								pcall(items[selected]["Callback"], items[selected]["State"])
							elseif items[selected]["ListItem"] then
								pcall(items[selected]["Callback"], items[selected]["List"][items[selected]["selectedItem"]])
							elseif items[selected]["Slider"] then
								pcall(items[selected]["Callback"], items[selected]["Value"])
							elseif items[selected]["Textbox"] then
								pcall(items[selected]["Callback"], items[selected]["Text"])
							elseif items[selected]["Bind"] then
								if not keybindtoggle then
									keybindtoggle = true
									for i,v in pairs(items[selected][1]) do
										if v.Name == "Button" then
											v.Text = ". . ."
										end
									end
									local CheckKeyPress
									CheckKeyPress = UIS.InputBegan:Connect(function(input, gpe)
										if gpe then return end

										if input.UserInputType == Enum.UserInputType.Keyboard then
											if input.KeyCode == Enum.KeyCode.Up or input.KeyCode == Enum.KeyCode.KeypadFive or input.KeyCode == Enum.KeyCode.Down or input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.Right then
												for i,v in pairs(items[selected][1]) do
													if v.Name == "Button" then
														v.Text = items[selected]["Keybind"]
													end
												end

												CheckKeyPress:Disconnect()
												task.wait(1)
												keybindtoggle = false
												return
											end

											for i,v in pairs(items[selected][1]) do
												if v.Name == "Button" then
													v.Text = input.KeyCode.Name
												end
											end
											items[selected]["Keybind"] = input.KeyCode.Name
											CheckKeyPress:Disconnect()
											task.wait(1)
											keybindtoggle = false
										else
											for i,v in pairs(items[selected][1]) do
												if v.Name == "Button" then
													v.Text = "Unknown"
												end
											end
											CheckKeyPress:Disconnect()
											task.wait(1)
											keybindtoggle = false
										end
									end)
								end
							end
						end
					end
				end
			end
		end)

		game:GetService("ContextActionService"):BindActionAtPriority("UILeft", function(_, inputState, _)
			if inputState ~= Enum.UserInputState.Begin then
				return Enum.ContextActionResult.Pass
			end

			if UIMenu == nil then
				return
			end

			if not UIMenu.Enabled and not Queue2[1] then
				return	
			end

			if selected ~= nil then
				if items[selected] then
					if items[selected]["Toggle"] then
						PlaySound()
						items[selected]["State"] = not items[selected]["State"]

						if items[selected]["State"] then
							for i,v in pairs(items[selected][1]) do
								if v.Name == "Checkbox" then
									v.Image = "rbxassetid://4822126140"
								end
							end
						else
							for i,v in pairs(items[selected][1]) do
								if v.Name == "Checkbox" then
									v.Image = "rbxassetid://5228818459"
								end
							end
						end

						for i,v in pairs(items[selected][1]) do
							if v.Name == "Checkmark" then
								v.Visible = items[selected]["State"]
								v.ImageColor3 = Color3.fromRGB(255, 255, 255)
							end
						end
					elseif items[selected]["ListItem"] then
						PlaySound()
						if items[selected]["selectedItem"] > 1 then
							items[selected]["selectedItem"] -= 1

							for i,v in pairs(items[selected][1]) do
								if v.Name == "List" then
									v.Text = items[selected]["List"][items[selected]["selectedItem"]]
								end
							end
						else
							items[selected]["selectedItem"] = #items[selected]["List"]

							for i,v in pairs(items[selected][1]) do
								if v.Name == "List" then
									v.Text = items[selected]["List"][items[selected]["selectedItem"]]
								end
							end
						end
					elseif items[selected]["Slider"] then
						PlaySound()
						if items[selected]["Value"] ~= items[selected]["MinValue"] then
							items[selected]["Value"] -= 1

							for i,v in pairs(items[selected][1]) do
								if v.Name == "SliderValue" then
									v.Text = items[selected]["Value"]
								end
							end

							for i,v in pairs(items[selected][1]) do
								if v.Name == "Outer" then
									v.Size = UDim2.new(0, (items[selected]["Value"] / items[selected]["MaxValue"] * 85), 0, 5)
								end
							end
						end
					end
				end
			end

			return Enum.ContextActionResult.Sink
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Left)

		game:GetService("ContextActionService"):BindActionAtPriority("UIRight", function(_, inputState, _)
			if inputState ~= Enum.UserInputState.Begin then
				return Enum.ContextActionResult.Pass
			end

			if UIMenu == nil then
				return
			end

			if not UIMenu.Enabled and not Queue2[1] then
				return	
			end

			if selected ~= nil then
				if items[selected] then
					if items[selected]["Toggle"] then
						PlaySound()
						items[selected]["State"] = not items[selected]["State"]

						if items[selected]["State"] then
							for i,v in pairs(items[selected][1]) do
								if v.Name == "Checkbox" then
									v.Image = "rbxassetid://4822126140"
								end
							end
						else
							for i,v in pairs(items[selected][1]) do
								if v.Name == "Checkbox" then
									v.Image = "rbxassetid://5228818459"
								end
							end
						end

						for i,v in pairs(items[selected][1]) do
							if v.Name == "Checkmark" then
								v.Visible = items[selected]["State"]
								v.ImageColor3 = Color3.fromRGB(255, 255, 255)
							end
						end
					elseif items[selected]["ListItem"] then
						PlaySound()
						if items[selected]["selectedItem"] ~= #items[selected]["List"] then
							items[selected]["selectedItem"] += 1

							for i,v in pairs(items[selected][1]) do
								if v.Name == "List" then
									v.Text = items[selected]["List"][items[selected]["selectedItem"]]
								end
							end
						else
							items[selected]["selectedItem"] = 1

							for i,v in pairs(items[selected][1]) do
								if v.Name == "List" then
									v.Text = items[selected]["List"][items[selected]["selectedItem"]]
								end
							end
						end
					elseif items[selected]["Slider"] then
						PlaySound()
						if items[selected]["Value"] ~= items[selected]["MaxValue"] then
							items[selected]["Value"] += 1

							for i,v in pairs(items[selected][1]) do
								if v.Name == "SliderValue" then
									v.Text = items[selected]["Value"]
								end
							end

							for i,v in pairs(items[selected][1]) do
								if v.Name == "Outer" then
									v.Size = UDim2.new(0, (items[selected]["Value"] / items[selected]["MaxValue"] * 85), 0, 5)
								end
							end
						end
					end
				end
			end

			return Enum.ContextActionResult.Sink
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Right)

		function items:CreateButton(name, callback)
			local ButtonItem = Instance.new("TextButton")
			local Label_6 = Instance.new("TextLabel")

			ButtonItem.Name = "ButtonItem"
			ButtonItem.Parent = TabFrame
			ButtonItem.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
			ButtonItem.BackgroundTransparency = 0.200
			ButtonItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ButtonItem.BorderSizePixel = 0
			ButtonItem.Position = UDim2.new(0, 0, 1.48199999, 0)
			ButtonItem.Size = UDim2.new(0, 200, 0, 25)
			ButtonItem.AutoButtonColor = false
			ButtonItem.Font = Enum.Font.Roboto
			ButtonItem.Text = ""
			ButtonItem.TextColor3 = Color3.fromRGB(255, 255, 255)
			ButtonItem.TextSize = 16.000
			ButtonItem.TextXAlignment = Enum.TextXAlignment.Left

			Label_6.Name = "Label_6"
			Label_6.Parent = ButtonItem
			Label_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label_6.BackgroundTransparency = 1.000
			Label_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label_6.BorderSizePixel = 0
			Label_6.Position = UDim2.new(0.0299999993, 0, 0, 0)
			Label_6.Size = UDim2.new(0, 194, 0, 25)
			Label_6.Font = Enum.Font.Roboto
			Label_6.Text = name
			Label_6.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label_6.TextSize = 14.000
			Label_6.TextWrapped = true
			Label_6.TextXAlignment = Enum.TextXAlignment.Left

			table.insert(items, {
				{
					ButtonItem, Label_6
				},
				{
					["ButtonItem"] = {
						["Original"] = {
							BackgroundTransparency = 0.2,
							BackgroundColor3 = Color3.fromRGB(29, 29, 29)
						},
						["TweenGoal"] = {
							BackgroundTransparency = 0,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						}
					},
					["Label_6"] = {
						["Original"] = {
							TextColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							TextColor3 = Color3.fromRGB(0, 0, 0)
						}
					}
				},
				["Callback"] = callback,
				["Button"] = "Button"
			})
			local index = #items

			if selected == nil and items[2] == nil then
				selected = 1
				for _,instance in pairs(items[selected][1]) do
					if items[selected][2][instance.Name] then
						Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
					end
				end
			end

			ButtonItem.MouseButton1Down:Connect(function()
				if selected ~= nil then
					PlaySound()
					if selected ~= index then
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["Original"])
							end
						end
						selected = index
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
							end
						end
					else
						pcall(callback)
					end
				end
			end)
		end

		function items:CreateToggle(name, state, callback)
			local Toggle = Instance.new("TextButton")
			local Label_2 = Instance.new("TextLabel")
			local Checkbox = Instance.new("ImageLabel")
			local Checkmark = Instance.new("ImageLabel")
			local Button = Instance.new("TextButton")

			Toggle.Name = "Toggle"
			Toggle.Parent = TabFrame
			Toggle.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
			Toggle.BackgroundTransparency = 0.200
			Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Toggle.BorderSizePixel = 0
			Toggle.Position = UDim2.new(0, 0, 1.48199999, 0)
			Toggle.Size = UDim2.new(0, 200, 0, 25)
			Toggle.AutoButtonColor = false
			Toggle.Font = Enum.Font.Unknown
			Toggle.Text = ""
			Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
			Toggle.TextSize = 16.000
			Toggle.TextXAlignment = Enum.TextXAlignment.Left

			Label_2.Name = "Label_2"
			Label_2.Parent = Toggle
			Label_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label_2.BackgroundTransparency = 1.000
			Label_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label_2.BorderSizePixel = 0
			Label_2.Position = UDim2.new(0.0299999993, 0, 0, 0)
			Label_2.Size = UDim2.new(0, 167, 0, 25)
			Label_2.Font = Enum.Font.Roboto
			Label_2.Text = name
			Label_2.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label_2.TextSize = 14.000
			Label_2.TextWrapped = true
			Label_2.TextXAlignment = Enum.TextXAlignment.Left

			Checkbox.Name = "Checkbox"
			Checkbox.Parent = Toggle
			Checkbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Checkbox.BackgroundTransparency = 1.000
			Checkbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Checkbox.BorderSizePixel = 0
			Checkbox.Position = UDim2.new(0.894999981, 0, 0.200000301, 0)
			Checkbox.Size = UDim2.new(0, 15, 0, 15)
			if state then
				Checkbox.Image = "rbxassetid://4822126140"
			else
				Checkbox.Image = "rbxassetid://5228818459"
			end

			Checkmark.Name = "Checkmark"
			Checkmark.Parent = Toggle
			Checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Checkmark.BackgroundTransparency = 1.000
			Checkmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Checkmark.BorderSizePixel = 0
			Checkmark.Position = UDim2.new(0.894999981, 0, 0.200000301, 0)
			Checkmark.Size = UDim2.new(0, 15, 0, 15)
			Checkmark.ZIndex = 2
			Checkmark.Image = "rbxassetid://9754130783"
			Checkmark.ImageColor3 = Color3.fromRGB(0, 0, 0)
			Checkmark.Visible = state

			Button.Name = "Button"
			Button.Parent = Toggle
			Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Button.BackgroundTransparency = 1.000
			Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Button.BorderSizePixel = 0
			Button.Position = UDim2.new(0.894999981, 0, 0.200000003, 0)
			Button.Size = UDim2.new(0, 15, 0, 15)
			Button.Font = Enum.Font.SourceSans
			Button.Text = ""
			Button.TextColor3 = Color3.fromRGB(0, 0, 0)
			Button.TextSize = 14.000

			table.insert(items, {
				{
					Toggle, Label_2, Checkbox, Checkmark
				},
				{
					["Toggle"] = {
						["Original"] = {
							BackgroundTransparency = 0.2,
							BackgroundColor3 = Color3.fromRGB(29, 29, 29)
						},
						["TweenGoal"] = {
							BackgroundTransparency = 0,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						}
					},
					["Label_2"] = {
						["Original"] = {
							TextColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							TextColor3 = Color3.fromRGB(0, 0, 0)
						}
					},
					["Checkbox"] = {
						["Original"] = {
							ImageColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							ImageColor3 = Color3.fromRGB(0, 0, 0)
						}
					},
					["Checkmark"] = {
						["Original"] = {
							ImageColor3 = Color3.fromRGB(0, 0, 0)
						},
						["TweenGoal"] = {
							ImageColor3 = Color3.fromRGB(255, 255, 255)
						}
					}
				},
				["Callback"] = callback,
				["Toggle"] = "Toggle",
				["State"] = state
			})
			local index = #items

			if selected == nil and items[2] == nil then
				selected = 1
				for _,instance in pairs(items[selected][1]) do
					if items[selected][2][instance.Name] then
						Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
					end
				end
			end

			Toggle.MouseButton1Down:Connect(function()
				if selected ~= nil then
					PlaySound()
					if selected ~= index then
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["Original"])
							end
						end
						selected = index
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
							end
						end
					else
						pcall(callback, items[index]["State"])
					end
				end
			end)

			Button.MouseButton1Down:Connect(function()
				if selected ~= nil then
					if selected == index then
						PlaySound()
						if items[index]["State"] == true then
							items[index]["State"] = false
							Checkbox.Image = "rbxassetid://5228818459"
						elseif items[index]["State"] == false then
							items[index]["State"] = true
							Checkbox.Image = "rbxassetid://4822126140"
						end

						Checkmark.Visible = items[index]["State"]
					end
				end
			end)
		end

		function items:CreateList(name, list, callback)
			local ListItem = Instance.new("TextButton")
			local Label_4 = Instance.new("TextLabel")
			local List = Instance.new("TextLabel")
			local Left = Instance.new("ImageButton")
			local Right = Instance.new("ImageButton")

			ListItem.Name = "ListItem"
			ListItem.Parent = TabFrame
			ListItem.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
			ListItem.BackgroundTransparency = 0.200
			ListItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ListItem.BorderSizePixel = 0
			ListItem.Position = UDim2.new(0, 0, 1.48199999, 0)
			ListItem.Size = UDim2.new(0, 200, 0, 25)
			ListItem.AutoButtonColor = false
			ListItem.Font = Enum.Font.Unknown
			ListItem.Text = ""
			ListItem.TextColor3 = Color3.fromRGB(255, 255, 255)
			ListItem.TextSize = 16.000
			ListItem.TextXAlignment = Enum.TextXAlignment.Left

			Label_4.Name = "Label_4"
			Label_4.Parent = ListItem
			Label_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label_4.BackgroundTransparency = 1.000
			Label_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label_4.BorderSizePixel = 0
			Label_4.Position = UDim2.new(0.0300000198, 0, 0, 0)
			Label_4.Size = UDim2.new(0, 117, 0, 25)
			Label_4.Font = Enum.Font.Roboto
			Label_4.Text = name
			Label_4.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label_4.TextSize = 14.000
			Label_4.TextWrapped = true
			Label_4.TextXAlignment = Enum.TextXAlignment.Left

			List.Name = "List"
			List.Parent = ListItem
			List.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			List.BackgroundTransparency = 1.000
			List.BorderColor3 = Color3.fromRGB(0, 0, 0)
			List.BorderSizePixel = 0
			List.Position = UDim2.new(0.694999993, 0, 0, 0)
			List.Size = UDim2.new(0, 40, 0, 25)
			List.Font = Enum.Font.Roboto
			List.Text = list[1] or ""
			List.TextColor3 = Color3.fromRGB(255, 255, 255)
			List.TextSize = 14.000
			List.TextWrapped = true
			List.TextXAlignment = Enum.TextXAlignment.Center

			Left.Name = "Left"
			Left.Parent = ListItem
			Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Left.BackgroundTransparency = 1.000
			Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Left.BorderSizePixel = 0
			Left.Position = UDim2.new(0.620000005, 0, 0.200000003, 0)
			Left.Size = UDim2.new(0, 15, 0, 15)
			Left.Image = "rbxassetid://2418687610"

			Right.Name = "Right"
			Right.Parent = ListItem
			Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Right.BackgroundTransparency = 1.000
			Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Right.BorderSizePixel = 0
			Right.Position = UDim2.new(0.894999981, 0, 0.200000003, 0)
			Right.Size = UDim2.new(0, 15, 0, 15)
			Right.Image = "rbxassetid://2418686949"

			table.insert(items, {
				{
					ListItem, Label_4, List, Left, Right
				},
				{
					["ListItem"] = {
						["Original"] = {
							BackgroundTransparency = 0.2,
							BackgroundColor3 = Color3.fromRGB(29, 29, 29)
						},
						["TweenGoal"] = {
							BackgroundTransparency = 0,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						}
					},
					["Label_4"] = {
						["Original"] = {
							TextColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							TextColor3 = Color3.fromRGB(0, 0, 0)
						}
					},
					["List"] = {
						["Original"] = {
							TextColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							TextColor3 = Color3.fromRGB(0, 0, 0)
						}
					},
					["Left"] = {
						["Original"] = {
							ImageColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							ImageColor3 = Color3.fromRGB(0, 0, 0)
						}
					},
					["Right"] = {
						["Original"] = {
							ImageColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							ImageColor3 = Color3.fromRGB(0, 0, 0)
						}
					}
				},
				["Callback"] = callback,
				["ListItem"] = "ListItem",
				["List"] = list,
				["selectedItem"] = 1
			})
			local index = #items

			ListItem.MouseButton1Down:Connect(function()
				if selected ~= nil then
					PlaySound()
					if selected ~= index then
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["Original"])
							end
						end
						selected = index
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
							end
						end
					else
						pcall(callback, items[index]["List"][items[index]["selectedItem"]])
					end
				end
			end)

			Left.MouseButton1Down:Connect(function()
				if selected ~= nil then
					if selected == index then
						PlaySound()
						if items[index]["selectedItem"] > 1 then
							items[index]["selectedItem"] -= 1
							List.Text = items[index]["List"][items[index]["selectedItem"]]
						else
							items[index]["selectedItem"] = #items[index]["List"]
							List.Text = items[index]["List"][items[index]["selectedItem"]]
						end
					end
				end
			end)

			Right.MouseButton1Down:Connect(function()
				if selected ~= nil then
					if selected == index then
						PlaySound()
						if items[index]["selectedItem"] ~= #items[index]["List"] then
							items[index]["selectedItem"] += 1
							List.Text = items[index]["List"][items[index]["selectedItem"]]
						else
							items[index]["selectedItem"] = 1
							List.Text = items[index]["List"][items[index]["selectedItem"]]
						end
					end
				end
			end)
		end

		function items:CreateSlider(name, minvalue, maxvalue, callback)
			local SliderItem = Instance.new("TextButton")
			local SliderValue = Instance.new("TextBox")
			local Outer = Instance.new("Frame")
			local Left_2 = Instance.new("ImageButton")
			local Right_2 = Instance.new("ImageButton")
			local Inner = Instance.new("Frame")
			local Label_5 = Instance.new("TextLabel")
			local UIGradient = Instance.new("UIGradient")

			SliderItem.Name = "SliderItem"
			SliderItem.Parent = TabFrame
			SliderItem.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
			SliderItem.BackgroundTransparency = 0.200
			SliderItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SliderItem.BorderSizePixel = 0
			SliderItem.Position = UDim2.new(0, 0, 1.48199999, 0)
			SliderItem.Size = UDim2.new(0, 200, 0, 25)
			SliderItem.AutoButtonColor = false
			SliderItem.Font = Enum.Font.Unknown
			SliderItem.Text = ""
			SliderItem.TextColor3 = Color3.fromRGB(255, 255, 255)
			SliderItem.TextSize = 16.000
			SliderItem.TextXAlignment = Enum.TextXAlignment.Left

			SliderValue.Parent = SliderItem
			SliderValue.Name = "SliderValue"
			SliderValue.BackgroundColor3 = Color3.fromRGB(0, 64, 94)
			SliderValue.BackgroundTransparency = 0
			SliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SliderValue.BorderSizePixel = 0
			SliderValue.Position = UDim2.new(0.890000105, 0, 0.200000003, 0)
			SliderValue.Size = UDim2.new(0, 15, 0, 15)
			SliderValue.ZIndex = 2
			SliderValue.Font = Enum.Font.SourceSans
			SliderValue.PlaceholderColor3 = Color3.fromRGB(0, 174, 255)
			SliderValue.PlaceholderText = minvalue
			SliderValue.Text = ""
			SliderValue.TextColor3 = Color3.fromRGB(0, 174, 255)
			SliderValue.TextScaled = true
			SliderValue.TextSize = 14.000
			SliderValue.TextWrapped = true

			Outer.Name = "Outer"
			Outer.Parent = SliderItem
			Outer.BackgroundColor3 = Color3.fromRGB(0, 174, 255)
			Outer.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Outer.BorderSizePixel = 0
			Outer.Position = UDim2.new(0.395000011, 0, 0.400000006, 0)
			Outer.Size = UDim2.new(0, 0, 0, 5)
			Outer.ZIndex = 2

			Left_2.Name = "Left_2"
			Left_2.Parent = SliderItem
			Left_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Left_2.BackgroundTransparency = 1.000
			Left_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Left_2.BorderSizePixel = 0
			Left_2.Position = UDim2.new(0.319999993, 0, 0.200000003, 0)
			Left_2.Size = UDim2.new(0, 15, 0, 15)
			Left_2.Image = "rbxassetid://2418687610"

			Right_2.Name = "Right_2"
			Right_2.Parent = SliderItem
			Right_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Right_2.BackgroundTransparency = 1.000
			Right_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Right_2.BorderSizePixel = 0
			Right_2.Position = UDim2.new(0.819999993, 0, 0.200000003, 0)
			Right_2.Size = UDim2.new(0, 15, 0, 15)
			Right_2.Image = "rbxassetid://2418686949"

			Inner.Name = "Inner"
			Inner.Parent = SliderItem
			Inner.BackgroundColor3 = Color3.fromRGB(0, 64, 94)
			Inner.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inner.Position = UDim2.new(0.395000011, 0, 0.400000006, 0)
			Inner.Size = UDim2.new(0, 85, 0, 5)

			Label_5.Name = "Label_5"
			Label_5.Parent = SliderItem
			Label_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label_5.BackgroundTransparency = 1.000
			Label_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label_5.BorderSizePixel = 0
			Label_5.Position = UDim2.new(0.0299999993, 0, 0, 0)
			Label_5.Size = UDim2.new(0, 73, 0, 25)
			Label_5.Font = Enum.Font.Roboto
			Label_5.Text = name
			Label_5.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label_5.TextSize = 14.000
			Label_5.TextWrapped = true
			Label_5.TextXAlignment = Enum.TextXAlignment.Left

			table.insert(items, {
				{
					SliderItem, Label_5, SliderValue, Inner, Outer, Left_2, Right_2, UIGradient
				},
				{
					["SliderItem"] = {
						["Original"] = {
							BackgroundTransparency = 0.2,
							BackgroundColor3 = Color3.fromRGB(29, 29, 29)
						},
						["TweenGoal"] = {
							BackgroundTransparency = 0,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						}
					},
					["Label_5"] = {
						["Original"] = {
							TextColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							TextColor3 = Color3.fromRGB(0, 0, 0)
						}
					},
					["Left_2"] = {
						["Original"] = {
							ImageColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							ImageColor3 = Color3.fromRGB(0, 0, 0)
						}
					},
					["Right_2"] = {
						["Original"] = {
							ImageColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							ImageColor3 = Color3.fromRGB(0, 0, 0)
						}
					}
				},
				["Callback"] = callback,
				["Slider"] = "Slider",
				["MinValue"] = minvalue,
				["MaxValue"] = maxvalue,
				["Value"] = minvalue
			})
			local index = #items

			SliderItem.MouseButton1Down:Connect(function()
				if selected ~= nil then
					PlaySound(game.Players.LocalPlayer.Character)
					if selected ~= index then
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["Original"])
							end
						end
						selected = index
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
							end
						end
					else
						pcall(callback, items[index]["Value"])
					end
				end
			end)

			SliderValue.Focused:Connect(function()
				if selected ~= index then
					SliderValue.Text = items[index]["Value"]
					PlaySound(game.Players.LocalPlayer.Character)
					if selected ~= index then
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["Original"])
							end
						end
						selected = index
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
							end
						end
					end
					return
				end
			end)

			SliderValue.FocusLost:Connect(function()
				PlaySound(game.Players.LocalPlayer.Character)

				if tonumber(SliderValue.Text) then
					if tonumber(SliderValue.Text) > items[index]["MaxValue"] then
						items[index]["Value"] = items[index]["MaxValue"]
						SliderValue.Text = items[index]["Value"]
						Outer.Size = UDim2.new(0, (items[index]["Value"] / items[index]["MaxValue"] * 85), 0, 5)
					elseif tonumber(SliderValue.Text) < items[index]["MinValue"] then
						items[index]["Value"] = items[index]["MinValue"]
						SliderValue.Text = items[index]["Value"]
						Outer.Size = UDim2.new(0, (items[index]["Value"] / items[index]["MaxValue"] * 85), 0, 5)
					else
						items[index]["Value"] = tonumber(SliderValue.Text)
						SliderValue.Text = items[index]["Value"]
						Outer.Size = UDim2.new(0, (items[index]["Value"] / items[index]["MaxValue"] * 85), 0, 5)
					end
				end
			end)

			Left_2.MouseButton1Down:Connect(function()
				if selected ~= nil then
					if selected == index then
						if items[index]["Value"] ~= items[index]["MinValue"] then
							PlaySound(game.Players.LocalPlayer.Character)
							items[index]["Value"] -= 1
							SliderValue.Text = items[index]["Value"]
							Outer.Size = UDim2.new(0, (items[index]["Value"] / items[index]["MaxValue"] * 85), 0, 5)
							task.wait(0.1)
						end
					end
				end
			end)

			Right_2.MouseButton1Down:Connect(function()
				if selected ~= nil then
					if selected == index then
						if items[index]["Value"] ~= items[index]["MaxValue"] then
							PlaySound(game.Players.LocalPlayer.Character)
							items[index]["Value"] += 1
							SliderValue.Text = items[index]["Value"]
							Outer.Size = UDim2.new(0, (items[index]["Value"] / items[index]["MaxValue"] * 85), 0, 5)
							task.wait(0.1)
						end
					end
				end
			end)
		end

		function items:CreateTextbox(name, placeholder, callback)
			local TextBoxItem = Instance.new("TextButton")
			local TextBox = Instance.new("TextBox")
			local Label_8 = Instance.new("TextLabel")
			local Frame_2 = Instance.new("Frame")
			local UIGradient = Instance.new("UIGradient")

			TextBoxItem.Name = "TextBoxItem"
			TextBoxItem.Parent = TabFrame
			TextBoxItem.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
			TextBoxItem.BackgroundTransparency = 0.200
			TextBoxItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextBoxItem.BorderSizePixel = 0
			TextBoxItem.Position = UDim2.new(0, 0, 1.48199999, 0)
			TextBoxItem.Size = UDim2.new(0, 200, 0, 25)
			TextBoxItem.AutoButtonColor = false
			TextBoxItem.Font = Enum.Font.Unknown
			TextBoxItem.Text = ""
			TextBoxItem.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBoxItem.TextSize = 16.000
			TextBoxItem.TextXAlignment = Enum.TextXAlignment.Left

			TextBox.Parent = TextBoxItem
			TextBox.Name = "TextBox"
			TextBox.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
			TextBox.BackgroundTransparency = 1.000
			TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextBox.BorderSizePixel = 0
			TextBox.Position = UDim2.new(0.469999999, 0, 0.200000003, 0)
			TextBox.Size = UDim2.new(0, 85, 0, 15)
			TextBox.ZIndex = 2
			TextBox.Font = Enum.Font.SourceSans
			TextBox.PlaceholderColor3 = Color3.fromRGB(0, 174, 255)
			TextBox.PlaceholderText = placeholder
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.fromRGB(0, 174, 255)
			TextBox.TextSize = 14.000
			TextBox.TextWrapped = true

			Label_8.Name = "Label_8"
			Label_8.Parent = TextBoxItem
			Label_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label_8.BackgroundTransparency = 1.000
			Label_8.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label_8.BorderSizePixel = 0
			Label_8.Position = UDim2.new(0.0299999993, 0, 0, 0)
			Label_8.Size = UDim2.new(0, 66, 0, 25)
			Label_8.Font = Enum.Font.Roboto
			Label_8.Text = name
			Label_8.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label_8.TextSize = 14.000
			Label_8.TextWrapped = true
			Label_8.TextXAlignment = Enum.TextXAlignment.Left

			Frame_2.Parent = TextBoxItem
			Frame_2.Name = "Frame_2"
			Frame_2.BackgroundColor3 = Color3.fromRGB(0, 64, 94)
			Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame_2.BorderSizePixel = 0
			Frame_2.Position = UDim2.new(0.469999999, 0, 0.200000003, 0)
			Frame_2.Size = UDim2.new(0, 85, 0, 15)

			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(111, 111, 111)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(175, 175, 175))}
			UIGradient.Parent = Frame_2

			table.insert(items, {
				{
					TextBoxItem, Label_8, TextBox, Frame_2, UIGradient
				},
				{
					["TextBoxItem"] = {
						["Original"] = {
							BackgroundTransparency = 0.2,
							BackgroundColor3 = Color3.fromRGB(29, 29, 29)
						},
						["TweenGoal"] = {
							BackgroundTransparency = 0,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						}
					},
					["Label_8"] = {
						["Original"] = {
							TextColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							TextColor3 = Color3.fromRGB(0, 0, 0)
						}
					}
				},
				["Callback"] = callback,
				["Textbox"] = "Textbox",
				["Text"] = TextBox.Text
			})
			local index = #items

			TextBoxItem.MouseButton1Down:Connect(function()
				if selected ~= nil then
					PlaySound()
					if selected ~= index then
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["Original"])
							end
						end
						selected = index
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
							end
						end
					else
						pcall(callback, items[index]["Text"])
					end
				end
			end)

			TextBox.FocusLost:Connect(function()
				if selected ~= nil then
					if selected == index then
						PlaySound()
						items[index]["Text"] = TextBox.Text
					else
						TextBox.Text = items[index]["Text"]
					end
				end
			end)
		end

		function items:CreateKeybind(name, keybind, callback)
			local KeybindItem = Instance.new("TextButton")
			local Button = Instance.new("TextButton")
			local Label_8 = Instance.new("TextLabel")
			local Frame_2 = Instance.new("Frame")
			local UIGradient = Instance.new("UIGradient")

			KeybindItem.Name = "KeybindItem"
			KeybindItem.Parent = TabFrame
			KeybindItem.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
			KeybindItem.BackgroundTransparency = 0.200
			KeybindItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
			KeybindItem.BorderSizePixel = 0
			KeybindItem.Position = UDim2.new(0, 0, 1.48199999, 0)
			KeybindItem.Size = UDim2.new(0, 200, 0, 25)
			KeybindItem.AutoButtonColor = false
			KeybindItem.Font = Enum.Font.Unknown
			KeybindItem.Text = ""
			KeybindItem.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeybindItem.TextSize = 16.000
			KeybindItem.TextXAlignment = Enum.TextXAlignment.Left

			Button.Parent = KeybindItem
			Button.Name = "Button"
			Button.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
			Button.BackgroundTransparency = 1.000
			Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Button.BorderSizePixel = 0
			Button.Position = UDim2.new(0.469999999, 0, 0.200000003, 0)
			Button.Size = UDim2.new(0, 85, 0, 15)
			Button.ZIndex = 2
			Button.Font = Enum.Font.SourceSans
			Button.Text = keybind
			Button.TextColor3 = Color3.fromRGB(0, 174, 255)
			Button.TextSize = 14.000
			Button.TextWrapped = true

			Label_8.Name = "Label_8"
			Label_8.Parent = KeybindItem
			Label_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label_8.BackgroundTransparency = 1.000
			Label_8.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label_8.BorderSizePixel = 0
			Label_8.Position = UDim2.new(0.0299999993, 0, 0, 0)
			Label_8.Size = UDim2.new(0, 66, 0, 25)
			Label_8.Font = Enum.Font.Roboto
			Label_8.Text = name
			Label_8.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label_8.TextSize = 14.000
			Label_8.TextWrapped = true
			Label_8.TextXAlignment = Enum.TextXAlignment.Left

			Frame_2.Parent = KeybindItem
			Frame_2.Name = "Frame_2"
			Frame_2.BackgroundColor3 = Color3.fromRGB(0, 64, 94)
			Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame_2.BorderSizePixel = 0
			Frame_2.Position = UDim2.new(0.469999999, 0, 0.200000003, 0)
			Frame_2.Size = UDim2.new(0, 85, 0, 15)

			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(111, 111, 111)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(175, 175, 175))}
			UIGradient.Parent = Frame_2

			table.insert(items, {
				{
					KeybindItem, Label_8, Button, Frame_2, UIGradient
				},
				{
					["KeybindItem"] = {
						["Original"] = {
							BackgroundTransparency = 0.2,
							BackgroundColor3 = Color3.fromRGB(29, 29, 29)
						},
						["TweenGoal"] = {
							BackgroundTransparency = 0,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						}
					},
					["Label_8"] = {
						["Original"] = {
							TextColor3 = Color3.fromRGB(255, 255, 255)
						},
						["TweenGoal"] = {
							TextColor3 = Color3.fromRGB(0, 0, 0)
						}
					}
				},
				["Bind"] = "Bind",
				["Keybind"] = keybind
			})
			local index = #items

			KeybindItem.MouseButton1Down:Connect(function()
				if selected ~= nil then
					PlaySound()
					if selected ~= index then
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["Original"])
							end
						end
						selected = index
						for _,instance in pairs(items[selected][1]) do
							if items[selected][2][instance.Name] then
								Tween(instance, items[selected][2][instance.Name]["TweenGoal"])
							end
						end
					end
				end
			end)

			Button.MouseButton1Click:Connect(function()
				if not keybindtoggle then
					keybindtoggle = true
					Button.Text = ". . ."
					local CheckKeyPress
					CheckKeyPress = UIS.InputBegan:Connect(function(input, gpe)
						if gpe then return end

						if input.UserInputType == Enum.UserInputType.Keyboard then
							if input.KeyCode == Enum.KeyCode.Up or input.KeyCode == Enum.KeyCode.KeypadFive or input.KeyCode == Enum.KeyCode.Down or input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.Right then
								Button.Text = items[index]["Keybind"]
								CheckKeyPress:Disconnect()
								task.wait(1)
								keybindtoggle = false
								return
							end

							Button.Text = input.KeyCode.Name
							items[index]["Keybind"] = input.KeyCode.Name
							CheckKeyPress:Disconnect()
							task.wait(1)
							keybindtoggle = false
						else
							Button.Text = "Unknown"
							CheckKeyPress:Disconnect()
							task.wait(1)
							keybindtoggle = false
						end
					end)
				end
			end)

			UIS.InputBegan:Connect(function(input, gpe)
				if gpe then return end

				if keybindtoggle then return end

				if input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode.Name == items[index]["Keybind"] then
						pcall(callback, items[index]["Keybind"])
					end
				end
			end)
		end

		return items
	end

	return tabs
end

return Menu
