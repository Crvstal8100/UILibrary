-- Load UI Lib
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Crvstal8100/UILibrary/main/Library.lua"))()

-- Create Menu
local Options = {
	["Keybinds"] = {
		["Up"] = Enum.KeyCode.Up,
		-- ["Down"],
		-- ["Left"],
		-- ["Right"],
		-- ["Enter"],
		-- ["Back"],
	}
}

local Menu = Library:Create("Title", "http://www.roblox.com/asset/?id=14299630623", "Description", Options)

--[[
Create Menu
arg1: string: Title
arg2: string: Banner
arg3: string: Description
]]

-- Send Alert
Menu:Alert("Text", function(option)
    -- Continue = 1, Cancel = 2
    print(option)
end)

--[[
Send Alert
arg1: string: Text
arg2: callback: function
]]

-- Send Notification
Menu:Notify("Text", 5)

--[[
Send Notification
arg1: string: Text
arg2: number: Time
]]

-- Create Tab
local Tab = Menu:CreateTab("Title", "http://www.roblox.com/asset/?id=14299630623", "Description")

--[[
Create Tab
arg1: string: Title
arg2: string: Banner
arg3: string: Description
]]

-- Create Button
tab:CreateButton("Button", function()
	print("Ok")
end)

--[[
Create Button
arg1: string: Text
arg2: callback: function
]]

-- Create Toggle
tab:CreateToggle("Toggle", false, function(state)
	print(state)
end)

--[[
Create Toggle
arg1: string: Text
arg2: bool: State
arg3: callback: function
]]

-- Create Slider
tab:CreateSlider("Slider", 0, 10, function(value)
	print(value)
end)

--[[
Create Slider
arg1: string: Text
arg2: number: MinValue
arg3: number: MaxValue
arg4: callback: function
]]

-- Create List
tab:CreateList("List", {"1", "2", "3"}, function(value)
	print(value)
end)

--[[
Create List
arg1: string: Text
arg2: table: List
arg3: callback: function
]]

-- Create Keybind
tab:CreateKeybind("Keybind", "K", function()
	print("Key Pressed")
end)

--[[
Create Keybind
arg1: string: Text
arg2: string: Keybind
arg3: callback: function
]]

-- Create Textbox
tab:CreateTextbox("Textbox", ". . .", function(text)
	print(text)
end)

--[[
Create Textbox
arg1: string: Text
arg2: string: placeholder
arg3: callback: function
]]
