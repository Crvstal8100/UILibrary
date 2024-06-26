-- Load UI Lib
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Crvstal8100/UILibrary/main/Library.lua"))()

-- Create Menu
local Menu = Library:Create("Title", "http://www.roblox.com/asset/?id=14299630623", "Description")

--[[
Create Menu
arg1: string: Title
arg2: string: Banner
arg3: string: Description
]]

-- Send Notification
Library:Notify("Text", 5, true, "bottommiddle")

--[[
Send Notification
arg1: string: Text
arg2: number: Time
arg3: boolean: BackgroundVisible
arg4: string: Position
^
|
"topleft", "bottommiddle"
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
Tab:CreateButton("Button", function()
	print("Ok")
end)

--[[
Create Button
arg1: string: Text
arg2: callback: function
]]

-- Create Toggle
Tab:CreateToggle("Toggle", false, function(state)
	print(state)
end)

--[[
Create Toggle
arg1: string: Text
arg2: bool: State
arg3: callback: function
]]

-- Create Slider
Tab:CreateSlider("Slider", 0, 10, function(value)
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
Tab:CreateList("List", {"1", "2", "3"}, function(value)
	print(value)
end)

--[[
Create List
arg1: string: Text
arg2: table: List
arg3: callback: function
]]

-- Create Keybind
Tab:CreateKeybind("Keybind", "K", function()
	print("Key Pressed")
end)

--[[
Create Keybind
arg1: string: Text
arg2: string: Keybind
arg3: callback: function
]]

-- Create Textbox
Tab:CreateTextbox("Textbox", ". . .", function(text)
	print(text)
end)

--[[
Create Textbox
arg1: string: Text
arg2: string: placeholder
arg3: callback: function
]]
