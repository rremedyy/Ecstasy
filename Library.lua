local Instance_new = Instance.new;
local UDim2_new = UDim2.new;
local UDim_new = UDim.new;
local Vector2_new = Vector2.new;
local Color3_new = Color3.new;
local Color3_fromRGB = Color3.fromRGB;
local Color3_fromHSV = Color3.fromHSV;
local Color3_fromHex = Color3.fromHex;
local math_clamp = math.clamp;
local math_ceil = math.ceil;
local math_floor = math.floor;
local Drawing_new = Drawing.new;
local table_insert = table.insert;

local TweenService = game:GetService('TweenService');
local HttpService = game:GetService('HttpService');
local RunService = game:GetService('RunService');
local UserInputService = game:GetService('UserInputService');
local Players = game:GetService('Players');
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local CurrentCamera = workspace.CurrentCamera;

local Library = {};
local Config = {};
do -- ui source
	function Library:Init(Properties)
		local UI = Instance_new("ScreenGui");
		local UnlockFrame = Instance_new("TextButton");
		local MainFrame = Instance_new("Frame");
		local TitleFrame = Instance_new("Frame");
		local TitleText = Instance_new("TextLabel");
		local Main = Instance_new("Frame");
		local Tabs = Instance_new("Frame");
		local TabLayout = Instance_new("UIListLayout");
		local TabItems = Instance_new("Frame");

		UI.Parent = game.Players.LocalPlayer.PlayerGui
		-- UnlockFrame
		UnlockFrame.Parent = UI;
		UnlockFrame.BackgroundTransparency = 1;
		UnlockFrame.Text = '';
		UnlockFrame.Size = UDim2_new(0,0,0,0);
		UnlockFrame.Modal = true;
		-- Frame
		MainFrame.Parent = UI;
		MainFrame.Active = true;
		MainFrame.Draggable = true;
		MainFrame.AnchorPoint = Vector2_new(0,0);
		MainFrame.BackgroundColor3 = Color3_fromRGB(23, 23, 23);
		MainFrame.BorderColor3 = Color3_fromRGB(0, 0, 0);
		MainFrame.BorderSizePixel = 0;
		MainFrame.Position = UDim2_new(0.5, -450/2, 0.5, -500/2);
		MainFrame.Size = UDim2_new(0, 450, 0, 500);
		-- Title
		TitleFrame.Parent = MainFrame;
		TitleFrame.AnchorPoint = Vector2_new(0.5, 0.5);
		TitleFrame.BackgroundColor3 = Color3_fromRGB(23, 23, 23);
		TitleFrame.BorderColor3 = Color3_fromRGB(50, 50, 50);
		TitleFrame.Position = UDim2_new(0.5, 0, 0, 17);
		TitleFrame.Size = UDim2_new(1, -10, 0, 24);
		-- TitleText
		TitleText.Parent = TitleFrame;
		TitleText.AnchorPoint = Vector2_new(0.5, 0.5);
		TitleText.BackgroundColor3 = Color3_fromRGB(255, 255, 255);
		TitleText.BackgroundTransparency = 1;
		TitleText.BorderColor3 = Color3_fromRGB(0, 0, 0);
		TitleText.BorderSizePixel = 0;
		TitleText.Position = UDim2_new(0.5, 0, 0.5, 0);
		TitleText.Size = UDim2_new(1, -10, 1, 0);
		TitleText.Font = Enum.Font.Code;
		TitleText.Text = Properties.Name;
		TitleText.TextColor3 = Color3_fromRGB(160, 160, 160);
		TitleText.TextSize = 13;
		TitleText.TextXAlignment = Enum.TextXAlignment.Left;
		-- Main
		Main.Parent = MainFrame;
		Main.AnchorPoint = Vector2_new(0.5, 0);
		Main.BackgroundColor3 = Color3_fromRGB(23, 23, 23);
		Main.BorderColor3 = Color3_fromRGB(50, 50, 50);
		Main.Position = UDim2_new(0.5, 0, 0, 41);
		Main.Size = UDim2_new(1, -10, 0, 454);
		-- Tabs
		Tabs.Parent = Main;
		Tabs.AnchorPoint = Vector2_new(0.5, 0);
		Tabs.BackgroundColor3 = Color3_fromRGB(23, 23, 23);
		Tabs.BorderColor3 = Color3_fromRGB(50, 50, 50);
		Tabs.Position = UDim2_new(0.5, -1, 0, 10);
		Tabs.Size = UDim2_new(1, -21, 0, 38);
		-- TabLayout
		TabLayout.Parent = Tabs;
		TabLayout.FillDirection = Enum.FillDirection.Horizontal;
		TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
		TabLayout.SortOrder = Enum.SortOrder.LayoutOrder;
		-- Items
		TabItems.Parent = MainFrame;
		TabItems.AnchorPoint = Vector2_new(0.5, 0);
		TabItems.BackgroundColor3 = Color3_fromRGB(23, 23, 23);
		TabItems.BackgroundTransparency = 1;
		TabItems.BorderColor3 = Color3_fromRGB(50, 50, 50);
		TabItems.Position = UDim2_new(0.5, 0, 0, 88);
		TabItems.Size = UDim2_new(1, -10, 0, 407);

		local FirstTab = true;
		local SelectedTab = nil;
		local Items = {};

		local Horizontal = Drawing_new("Line");
		Horizontal.Visible = true;
		Horizontal.Color = Color3_new(1,1,1);
		local Vertical = Drawing_new("Line");
		Vertical.Visible = true;
		Vertical.Color = Color3_new(1,1,1);
		
		RunService.RenderStepped:Connect(function()
			if UI.Enabled then
				local Mouse = game:GetService("UserInputService"):GetMouseLocation()
				Horizontal.From = Vector2.new(Mouse.X - 7, Mouse.Y)
				Horizontal.To = Vector2.new(Mouse.X + 8, Mouse.Y)
				Vertical.From = Vector2.new(Mouse.X, Mouse.Y - 7)
				Vertical.To = Vector2.new(Mouse.X, Mouse.Y + 8)
			end
		end)
		
		function Items:Toggle()
			local Boolean = UI.Enabled
			UI.Enabled = not Boolean
			UnlockFrame.Modal = not Boolean
			local LastState = UserInputService.MouseIconEnabled
			while UI.Enabled do
				UserInputService.MouseIconEnabled = false
				Horizontal.Visible = true
				Vertical.Visible = true
				task.wait()
			end
			Horizontal.Visible = false;
			Vertical.Visible = false;
			UserInputService.MouseIconEnabled = LastState;
			UnlockFrame.Modal = false;
		end
		
		Config['Toggles'] = {};
		Config['Sliders'] = {};
		Config['KeyPickers'] = {};
		Config['ColorPickers'] = {};
		function Items:AddTab(Properties)
			-- Tab
			local TabButton = Instance_new("TextButton");
			TabButton.Parent = Tabs;
			TabButton.BackgroundColor3 = Color3_fromRGB(255, 255, 255);
			TabButton.BackgroundTransparency = 1;
			TabButton.BorderColor3 = Color3_fromRGB(0, 0, 0);
			TabButton.BorderSizePixel = 0;
			TabButton.Size = UDim2_new(0, 75, 1, 0);
			TabButton.Font = Enum.Font.Code;
			TabButton.Text = Properties.Name;
			TabButton.TextColor3 = Color3_fromRGB(173, 70, 108);
			TabButton.TextSize = 13;

			local Tab = Instance_new("Frame")
			Tab.Parent = TabItems;
			Tab.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
			Tab.BackgroundTransparency = 1.000
			Tab.BorderColor3 = Color3_fromRGB(0, 0, 0)
			Tab.BorderSizePixel = 0
			Tab.Size = UDim2_new(1, 0, 1, 0)

			for i, Object in pairs(TabItems:GetChildren()) do
				if Object == Tab and not string.find(Object.ClassName, "UI") then
					Object.Visible = false
				end
			end

			if FirstTab then
				Tab.Visible = true
				SelectedTab = TabButton;
				FirstTab = false;
			else
				TabButton.TextColor3 = Color3_fromRGB(160, 160, 160);
			end

			TabButton.MouseButton1Click:Connect(function()
				for i, Object in pairs(TabItems:GetChildren()) do
					if Object ~= Tab and not string.find(Object.ClassName, "UI") then
						Object.Visible = false;
					end
				end
				for i, Object in pairs(Tabs:GetChildren()) do
					if Object ~= Tab and not string.find(Object.ClassName, "UI") then
						Object.TextColor3 = Color3_fromRGB(160, 160, 160);
					end
				end
				Tab.Visible = true
				TabButton.TextColor3 = Color3_fromRGB(173, 70, 108);
				SelectedTab = Tab;
			end);

			local Left = Instance_new("ScrollingFrame");
			Left.Parent = Tab;
			Left.BackgroundTransparency = 1;
			Left.Position = UDim2_new(0, 9, 0, 11);
			Left.Size = UDim2_new(0.5, -16, 0, 397);
			Left.ScrollBarThickness = 0;
			local LeftLayout = Instance_new('UIListLayout');
			LeftLayout.Parent = Left;
			LeftLayout.Padding = UDim_new(0, 10);
			LeftLayout.FillDirection = Enum.FillDirection.Vertical;
			LeftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
			LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder;
			Left.ChildAdded:Connect(function(child)
				if string.find(child.ClassName, 'UI') then return end;
				repeat wait() until child.Size ~= nil and child.Size ~= UDim2_new(0,0,0,0);
				task.spawn(function()
					wait(.05)
					Left.CanvasSize = UDim2_new(0, LeftLayout.AbsoluteContentSize.X, 0, LeftLayout.AbsoluteContentSize.Y + 11);
				end)
			end)
			local Right = Instance_new("ScrollingFrame");
			Right.Parent = Tab;
			Right.BackgroundTransparency = 1;
			Right.Position = UDim2_new(0.5, 7, 0, 11);
			Right.Size = UDim2_new(0.5, -16, 0, 397);
			Right.ScrollBarThickness = 0;
			local RightLayout = Instance_new('UIListLayout');
			RightLayout.Parent = Right;
			RightLayout.Padding = UDim_new(0, 10);
			RightLayout.FillDirection = Enum.FillDirection.Vertical;
			RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
			RightLayout.SortOrder = Enum.SortOrder.LayoutOrder;
			Right.ChildAdded:Connect(function(child)
				if string.find(child.ClassName, 'UI') then return end;
				repeat wait() until child.Size ~= nil and child.Size ~= UDim2_new(0,0,0,0);
				task.spawn(function()
					wait(.05)
					Right.CanvasSize = UDim2_new(0, RightLayout.AbsoluteContentSize.X, 0, RightLayout.AbsoluteContentSize.Y + 11);
				end)
			end)

			local Items = {}
			function Items:AddSection(Properties)
				local Chosen = Left;
				if Properties.Side ~= 'Left' then
					Chosen = Right;
				end

				local SectionFrame = Instance_new("Frame");
				local Title = Instance_new("TextLabel");
				local Section = Instance_new("ScrollingFrame");
				local FramePadding = Instance_new("UIPadding");
				local FrameLayout = Instance_new("UIListLayout");

				-- SectionFrame
				SectionFrame.Parent = Chosen;
				SectionFrame.AnchorPoint = Vector2_new(0.5, 0);
				SectionFrame.BackgroundTransparency = 1;
				SectionFrame.Position = UDim2_new(0.5, 0, 0, 0);
				SectionFrame.Size = UDim2_new(1, 0, 0, 50);
				-- Title
				Title.Parent = SectionFrame;
				Title.AnchorPoint = Vector2_new(0.5, 0);
				Title.BackgroundColor3 = Color3_fromRGB(23, 23, 23);
				Title.BorderColor3 = Color3_fromRGB(50, 50, 50);
				Title.Position = UDim2_new(0.5, -1, 0, 1);
				Title.Size = UDim2_new(1, -3, 0, 27);
				Title.Font = Enum.Font.Code;
				Title.Text = Properties.Name;
				Title.TextColor3 = Color3_fromRGB(216, 170, 202);
				Title.TextSize = 13;
				-- Section
				Section.Parent = SectionFrame;
				Section.Active = true;
				Section.BackgroundColor3 = Color3_fromRGB(23, 23, 23);
				Section.BorderColor3 = Color3_fromRGB(50, 50, 50);
				Section.BorderSizePixel = 1;
				Section.Position = UDim2_new(0, 1, 0, 26);
				Section.Size = UDim2_new(1, -3, 1, -25);
				Section.ScrollBarThickness = 0;
				-- FramePadding
				FramePadding.Parent = Section;
				FramePadding.PaddingTop = UDim_new(0, 8);
				-- FrameLayout
				FrameLayout.Parent = Section;
				FrameLayout.SortOrder = Enum.SortOrder.LayoutOrder;

				Section.ChildAdded:Connect(function(child)
					if string.find(child.ClassName, 'UI') then return end;
					repeat wait() until child.Size ~= nil and child.Size ~= UDim2_new(0,0,0,0);
					SectionFrame.Size = UDim2_new(1, 0, 0, FrameLayout.AbsoluteContentSize.Y+41);
					Section.CanvasSize = UDim2_new(0, FrameLayout.AbsoluteContentSize.X, 0, FrameLayout.AbsoluteContentSize.Y);
				end)

				local Items = {}
				function Items:AddToggle(Flag, Properties)
					local ToggleFrame = Instance_new("Frame");
					local ToggleButton = Instance_new("TextButton");
					local TextLabel = Instance_new("TextLabel");

					-- ToggleFrame
					ToggleFrame.Name = "Toggle";
					ToggleFrame.Parent = Section;
					ToggleFrame.BackgroundColor3 = Color3_fromRGB(255, 255, 255);
					ToggleFrame.BackgroundTransparency = 1;
					ToggleFrame.BorderColor3 = Color3_fromRGB(0, 0, 0);
					ToggleFrame.BorderSizePixel = 0;
					ToggleFrame.Size = UDim2_new(1, 0, 0, 20);
					-- ToggleButton
					ToggleButton.Parent = ToggleFrame;
					ToggleButton.AutoButtonColor = false;
					ToggleButton.BackgroundColor3 = Color3_fromRGB(22, 19, 22);
					ToggleButton.BorderColor3 = Color3_fromRGB(45, 42, 45);
					ToggleButton.Position = UDim2_new(0, 12, 0.5, -6);
					ToggleButton.Size = UDim2_new(0, 12, 0, 12);
					ToggleButton.Font = Enum.Font.SourceSans;
					ToggleButton.TextColor3 = Color3_fromRGB(0, 0, 0);
					ToggleButton.TextSize = 14;
					ToggleButton.TextTransparency = 1;
					-- TextLabel
					TextLabel.Parent = ToggleFrame;
					TextLabel.BackgroundColor3 = Color3_fromRGB(255, 255, 255);
					TextLabel.BackgroundTransparency = 1;
					TextLabel.BorderColor3 = Color3_fromRGB(0, 0, 0);
					TextLabel.BorderSizePixel = 0;
					TextLabel.Position = UDim2_new(0, 29, 0.5, -6);
					TextLabel.Size = UDim2_new(0, 162, 0, 12);
					TextLabel.Font = Enum.Font.Code;
					TextLabel.Text = Properties.Text;
					TextLabel.TextColor3 = Color3_fromRGB(160, 160, 160);
					TextLabel.TextSize = 14;
					TextLabel.TextXAlignment = Enum.TextXAlignment.Left;

					if Properties.Default then
						ToggleButton.BackgroundColor3 = Color3_fromRGB(252, 33, 122);
						ToggleButton.BorderColor3 = Color3_fromRGB(80, 6, 39);
					end

					local function SetValue(boolean)
						if boolean then
							ToggleButton.BackgroundColor3 = Color3_fromRGB(252, 33, 122);
							ToggleButton.BorderColor3 = Color3_fromRGB(80, 6, 39);
							Properties.Default = true;
							pcall(Properties.Callback, true);
						else
							ToggleButton.BackgroundColor3 = Color3_fromRGB(22, 19, 22);
							ToggleButton.BorderColor3 = Color3_fromRGB(45, 42, 45);
							Properties.Default = false;
							pcall(Properties.Callback, false);
						end
					end
					
					local Cooldown = false;
					ToggleButton.MouseButton1Click:Connect(function()
						if Properties.Default then
							SetValue(false)
							Config.Toggles[Flag].Value = Properties.Default
						else
							SetValue(true)
							Config.Toggles[Flag].Value = Properties.Default
						end
					end)
					
					Config.Toggles[Flag] = {
						Value = Properties.Default or false,
						SetValue = SetValue,
					}
					
					local Items = {}
					function Items:AddKeypicker(Flag, Properties)
						local TextButton = Instance_new("TextButton")
						TextButton.Parent = ToggleFrame
						TextButton.BackgroundTransparency = 1
						TextButton.Position = UDim2_new(1, -47, 0.5, -6)
						TextButton.Size = UDim2_new(0, 35, 0, 12)
						TextButton.AutoButtonColor = false
						TextButton.Font = Enum.Font.SourceSans
						TextButton.Text = "[" .. Properties.Default .. "]";
						TextButton.TextColor3 = Color3_fromRGB(255, 255, 255)
						TextButton.TextSize = 14
						TextButton.TextXAlignment = Enum.TextXAlignment.Right

						local cooldown = false
						local key = Properties.Default
						local allowKeyChange = false
						TextButton.MouseButton1Click:Connect(function()
							if not cooldown then
								cooldown = true
								TextButton.Text = "[...]"
								allowKeyChange = true
							end
						end)

						local toggled = false
						UserInputService.InputBegan:Connect(function(input, processed)
							if allowKeyChange and not processed then
								if input.UserInputType == Enum.UserInputType.Keyboard then
									key = input.KeyCode.Name
								elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
									key = 'MB1'
								elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
									key = 'MB2'
								end
								allowKeyChange = false
								Config.KeyPickers[Flag].Value = key
								TextButton.Text = "[" .. key .. "]"
								wait(0.1)
								cooldown = false
							else
								if not processed and not cooldown then
									if (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == key) or (input.UserInputType == Enum.UserInputType.MouseButton1 and key == "MB1") or (input.UserInputType == Enum.UserInputType.MouseButton2 and key == "MB2") then
										toggled = not toggled
										if Properties.Mode == 'Held' then
											pcall(Properties.Callback, true)
										elseif Properties.Mode == 'Toggle' then
											pcall(Properties.Callback, toggled)
										end
									end
								end
							end
						end)
						UserInputService.InputEnded:Connect(function(input, processed)
							if not processed and not cooldown then
								if (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == key) or (input.UserInputType == Enum.UserInputType.MouseButton1 and key == "MB1") or (input.UserInputType == Enum.UserInputType.MouseButton2 and key == "MB2") then
									if Properties.Mode == 'Held' then
										pcall(Properties.Callback, false)
									end
								end
							end
						end)
						
						local function SetValue(KeyInput)
							key = KeyInput
							TextButton.Text = "[" .. key .. "]"
							Config.KeyPickers[Flag].Value = key
						end
						
						Config.KeyPickers[Flag] = {
							Value = key,
							SetValue = SetValue
						}
					end
					
					function Items:AddColorPicker(Flag, Properties)
						local ColorButton = Instance_new("ImageButton")
						local UICorner = Instance_new("UICorner")

						ColorButton.Parent = ToggleFrame
						ColorButton.AutoButtonColor = false
						ColorButton.BackgroundColor3 = Properties.Default
						ColorButton.Position = UDim2_new(1, -32, 0.5, -6)
						ColorButton.Size = UDim2_new(0, 20, 0, 12)

						UICorner.CornerRadius = UDim_new(0, 2)
						UICorner.Parent = ColorButton

						local Frame = Instance_new("Frame")
						local Color = Instance_new("ImageButton")
						local HSV = Instance_new("ImageButton")
						local RGBBox = Instance_new("TextBox")
						local HEXBox = Instance_new("TextBox")

						Frame.Parent = MainFrame
						Frame.BackgroundColor3 = Color3_fromRGB(23, 23, 23)
						Frame.Size = UDim2_new(0, 160, 0, 160)
						Frame.Visible = false

						Color.Parent = Frame
						Color.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
						Color.BorderColor3 = Color3_fromRGB(0, 0, 0)
						Color.BorderSizePixel = 0
						Color.Size = UDim2_new(0, 150, 0, 150)
						Color.AutoButtonColor = false
						Color.Image = "rbxassetid://17346159171"
						Color.ImageColor3 = Properties.Default

						local Picking = false
						local Hue, Saturation, Value = Properties.Default:ToHSV()
						Color.ImageColor3 = Color3_fromHSV(Hue, 1, 1);
						Color.InputBegan:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								Picking = true
							end
						end)

						Color.InputEnded:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								Picking = false
							end
						end)

						UserInputService.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement and Picking then
								Saturation = 1-math_clamp((Mouse.X-Frame.AbsolutePosition.X)/Frame.AbsoluteSize.X, 0, 1)
								Value = 1-math_clamp((Mouse.Y-Frame.AbsolutePosition.Y)/Frame.AbsoluteSize.Y, 0, 1)
								local ChosenColor = Color3_fromHSV(Hue, Saturation, Value)
								ColorButton.BackgroundColor3 = ChosenColor
								RGBBox.Text = table.concat({ math.floor(ChosenColor.R * 255), math.floor(ChosenColor.G * 255), math.floor(ChosenColor.B * 255) }, ', ')
								HEXBox.Text = "#" .. ChosenColor:ToHex()
								Config.ColorPickers[Flag].H = Hue
								Config.ColorPickers[Flag].S = Saturation
								Config.ColorPickers[Flag].V = Value
								pcall(Properties.Callback, ChosenColor);
							end
						end)

						HSV.Parent = Frame
						HSV.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
						HSV.BorderColor3 = Color3_fromRGB(0, 0, 0)
						HSV.BorderSizePixel = 0
						HSV.Position = UDim2_new(0, 150, 0, 0)
						HSV.Size = UDim2_new(0, 10, 0, 150)
						HSV.AutoButtonColor = false
						HSV.Image = "rbxassetid://17336552773"

						local PickingHue = false
						HSV.InputBegan:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								PickingHue = true
							end
						end)

						HSV.InputEnded:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								PickingHue = false
							end
						end)

						UserInputService.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement and PickingHue then
								local ChosenHue = 1-math_clamp((Mouse.Y-HSV.AbsolutePosition.Y)/HSV.AbsoluteSize.Y, 0, 1)
								Hue = ChosenHue
								local ChosenColor = Color3_fromHSV(Hue, Saturation, Value)
								Color.ImageColor3 = Color3_fromHSV(Hue, 1,1)
								ColorButton.BackgroundColor3 = ChosenColor
								RGBBox.Text = table.concat({ math.floor(ChosenColor.R * 255), math.floor(ChosenColor.G * 255), math.floor(ChosenColor.B * 255) }, ', ')
								HEXBox.Text = "#" .. ChosenColor:ToHex()
								Config.ColorPickers[Flag].H = Hue
								Config.ColorPickers[Flag].S = Saturation
								Config.ColorPickers[Flag].V = Value
								pcall(Properties.Callback, ChosenColor);
							end
						end)

						ColorButton.MouseButton1Click:Connect(function()
							Frame.Visible = not Frame.Visible
							Frame.Position = UDim2_new(0, (ColorButton.AbsolutePosition.X + ColorButton.AbsoluteSize.X)-MainFrame.AbsolutePosition.X, 0, (ColorButton.AbsolutePosition.Y + ColorButton.AbsoluteSize.Y)-MainFrame.AbsolutePosition.Y)
						end)

						RGBBox.Parent = Frame
						RGBBox.BackgroundTransparency = 1
						RGBBox.Position = UDim2_new(0, 0, 1, -10)
						RGBBox.Size = UDim2_new(0.5, 0, 0, 10)
						RGBBox.Font = Enum.Font.Code
						RGBBox.PlaceholderColor3 = Color3_fromRGB(160, 160, 160)
						RGBBox.PlaceholderText = "RGB"
						local function hex2rgb(hex)
							hex = hex:gsub("#","")
							local r = tonumber("0x"..hex:sub(1,2))
							local g = tonumber("0x"..hex:sub(3,4))
							local b = tonumber("0x"..hex:sub(5,6))
							return table.concat({r,g,b}, ', ')
						end
						RGBBox.Text = hex2rgb(Properties.Default:ToHex())
						RGBBox.TextColor3 = Color3_fromRGB(160, 160, 160)
						RGBBox.TextSize = 11
						RGBBox.TextXAlignment = Enum.TextXAlignment.Center
						RGBBox.FocusLost:Connect(function(Enter)
							if Enter then
								local r, g, b = RGBBox.Text:match('(%d+),%s*(%d+),%s*(%d+)')
								if r and g and b then
									local H,S,V = Color3_fromRGB(r, g, b):ToHSV()
									Color.ImageColor3 = Color3_fromHSV(H, 1,1)
									local HSVColor = Color3_fromHSV(H,S,V)
									ColorButton.BackgroundColor3 = HSVColor
									RGBBox.Text = hex2rgb(HSVColor:ToHex());
									HEXBox.Text = "#" .. HSVColor:ToHex();
									Config.ColorPickers[Flag].H = H
									Config.ColorPickers[Flag].S = S
									Config.ColorPickers[Flag].V = V
									pcall(Properties.Callback, HSVColor);
								end
							end
						end)

						HEXBox.Parent = Frame
						HEXBox.BackgroundTransparency = 1
						HEXBox.Position = UDim2_new(.5, 0, 1, -10)
						HEXBox.Size = UDim2_new(0.5, 0, 0, 10)
						HEXBox.Font = Enum.Font.Code
						HEXBox.PlaceholderColor3 = Color3_fromRGB(160, 160, 160)
						HEXBox.PlaceholderText = "HEX"
						HEXBox.Text = "#" .. Properties.Default:ToHex();
						HEXBox.TextColor3 = Color3_fromRGB(160, 160, 160)
						HEXBox.TextSize = 11
						HEXBox.TextXAlignment = Enum.TextXAlignment.Center
						HEXBox.FocusLost:Connect(function(Enter)
							if Enter then
								local success, result = pcall(Color3_fromHex, HEXBox.Text)
								if success and typeof(result) == 'Color3' then
									local H,S,V = result:ToHSV()
									Color.ImageColor3 = Color3_fromHSV(H, 1,1)
									local HSVColor = Color3_fromHSV(H,S,V);
									ColorButton.BackgroundColor3 = HSVColor
									RGBBox.Text = hex2rgb(HSVColor:ToHex());
									HEXBox.Text = "#" .. HSVColor:ToHex();
									Config.ColorPickers[Flag].H = H
									Config.ColorPickers[Flag].S = S
									Config.ColorPickers[Flag].V = V
									pcall(Properties.Callback, Color3_fromHSV(H,S,V));
								end
							end
						end)
						
						local function SetValue(ColorInput)
							local ChosenColor = ColorInput:ToHex()
							
							local r, g, b = hex2rgb(ChosenColor):match('(%d+),%s*(%d+),%s*(%d+)')
							if r and g and b then
								local H,S,V = Color3_fromRGB(r, g, b):ToHSV()
								Hue, Saturation, Value = H,S,V;
								Color.ImageColor3 = Color3_fromHSV(H,1,1)
								local HSVColor = Color3_fromHSV(H,S,V)
								ColorButton.BackgroundColor3 = HSVColor
								RGBBox.Text = hex2rgb(HSVColor:ToHex());
								HEXBox.Text = "#" .. HSVColor:ToHex();
								Config.ColorPickers[Flag].H = Hue
								Config.ColorPickers[Flag].S = Saturation
								Config.ColorPickers[Flag].V = Value
								pcall(Properties.Callback, HSVColor);
							end
						end
	
						Config.ColorPickers[Flag] = {
							H = Hue,
							S = Saturation,
							V = Value,
							SetValue = SetValue,
						}
					end
					return Items;
				end;
				
				function Items:AddSlider(Flag, Properties)
					Config.Sliders[Flag] = {}
					local Slider = Instance_new("Frame");
					local SliderText = Instance_new("TextLabel");
					local SliderBackground = Instance_new("TextButton");
					local SliderFill = Instance_new("Frame");
					local SliderValue = Instance_new("TextLabel");
					local SliderTick = Instance_new("Frame");
					-- Slider		
					Slider.Name = "Slider";
					Slider.Parent = Section;
					Slider.BackgroundColor3 = Color3_fromRGB(255, 255, 255);
					Slider.BackgroundTransparency = 1;
					Slider.BorderColor3 = Color3_fromRGB(0, 0, 0);
					Slider.BorderSizePixel = 0;
					Slider.Size = UDim2_new(1, 0, 0, 35);
					-- SliderText
					SliderText.Name = "SliderText";
					SliderText.Parent = Slider;
					SliderText.BackgroundColor3 = Color3_fromRGB(255, 255, 255);
					SliderText.BackgroundTransparency = 1;
					SliderText.BorderColor3 = Color3_fromRGB(0, 0, 0);
					SliderText.BorderSizePixel = 0;
					SliderText.Position = UDim2_new(0, 12, 0, 3);
					SliderText.Size = UDim2_new(0, 162, 0, 12);
					SliderText.Font = Enum.Font.Code;
					SliderText.Text = Properties.Text;
					SliderText.TextColor3 = Color3_fromRGB(160, 160, 160);
					SliderText.TextSize = 14;
					SliderText.TextXAlignment = Enum.TextXAlignment.Left;
					-- SliderBackground
					SliderBackground.Name = "SliderBackground";
					SliderBackground.AutoButtonColor = false;
					SliderBackground.TextTransparency = 1;
					SliderBackground.Parent = Slider;
					SliderBackground.AnchorPoint = Vector2_new(0.5, 0);
					SliderBackground.BackgroundColor3 = Color3_fromRGB(22, 19, 22);
					SliderBackground.BorderColor3 = Color3_fromRGB(45, 42, 45);
					SliderBackground.Position = UDim2_new(0.5, 0, 1, -16);
					SliderBackground.Size = UDim2_new(1, -25, 0, 11);
					-- SliderFill
					SliderFill.Name = "SliderFill";
					SliderFill.Parent = SliderBackground;
					SliderFill.BackgroundColor3 = Color3_fromRGB(252, 33, 122);
					SliderFill.BorderColor3 = Color3_fromRGB(22, 19, 22);
					SliderFill.Size = UDim2_new(0.25, 0, 1, 0);
					-- SliderValue
					SliderValue.Name = "SliderValue";
					SliderValue.Parent = SliderBackground;
					SliderValue.AnchorPoint = Vector2_new(0.5, 0);
					SliderValue.BackgroundColor3 = Color3_fromRGB(255, 255, 255);
					SliderValue.BackgroundTransparency = 1;
					SliderValue.BorderColor3 = Color3_fromRGB(0, 0, 0);
					SliderValue.BorderSizePixel = 0;
					SliderValue.Position = UDim2_new(0.5, 0, 0, 0);
					SliderValue.Size = UDim2_new(1, 0, 1, 0);
					SliderValue.Font = Enum.Font.Code;
					SliderValue.Text = Properties.Default;
					SliderValue.TextColor3 = Color3_fromRGB(160, 160, 160);
					SliderValue.TextSize = 13;
					SliderValue.TextXAlignment = Enum.TextXAlignment.Center;
					-- SliderTick
					SliderTick.Name = "SliderTick";
					SliderTick.Parent = SliderBackground;
					SliderTick.BackgroundColor3 = Color3_fromRGB(255, 255, 255);
					SliderTick.BorderColor3 = Color3_fromRGB(45, 42, 45);
					SliderTick.BorderSizePixel = 0;
					SliderTick.Position = UDim2_new(0.5, 1, 0, 0);
					SliderTick.Size = UDim2_new(0, 2, 1, 0);

					local function GetValue(Value, MinA, MaxA, MinB, MaxB)
						return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB;
					end
					
					local function SetValue(Integer)
						local Offset = math_ceil(GetValue(Integer, Properties.Min, Properties.Max, 0, SliderBackground.AbsoluteSize.X));
						SliderTick.Position = UDim2_new(0, Offset, 0, 0);
						SliderFill.Size = UDim2_new(Offset/SliderBackground.AbsoluteSize.X, 0, 1, 0);
						SliderValue.Text = Integer
						Config.Sliders[Flag].Value = Integer
						pcall(Properties.Callback, Integer);
					end
					
					SetValue(Properties.Default)

					local function UpdateSlider()
						local OffsetMouse = math_floor(math_clamp(UserInputService:GetMouseLocation().X-SliderBackground.AbsolutePosition.X, 0, SliderBackground.AbsoluteSize.X));
						local OldPosition = Mouse.X;
						local Difference = OldPosition - (SliderBackground.AbsolutePosition.X + OffsetMouse);
						local MathX = math_clamp(OffsetMouse + (Mouse.X - OldPosition) + Difference, 0, SliderBackground.AbsoluteSize.X);
						local CurrentValue = math_floor(GetValue(MathX, 0, SliderBackground.AbsoluteSize.X, Properties.Min, Properties.Max));
						local Offset = math_ceil(GetValue(CurrentValue, Properties.Min, Properties.Max, 0, SliderBackground.AbsoluteSize.X));
						SliderFill.Size = UDim2_new(Offset/SliderBackground.AbsoluteSize.X, 0, 1, 0);
						SliderTick.Position = UDim2_new(0, MathX, 0, 0);
						SliderValue.Text = tostring(CurrentValue);
						Config.Sliders[Flag].Value = CurrentValue
						pcall(Properties.Callback, CurrentValue);
					end

					local MoveConnection, ReleaseConnection;
					local function Update()
						UpdateSlider();
						MoveConnection = Mouse.Move:Connect(function()
							UpdateSlider();
						end)
						ReleaseConnection = UserInputService.InputEnded:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								UpdateSlider();
								MoveConnection:Disconnect();
								ReleaseConnection:Disconnect();
							end
						end)
					end
					SliderBackground.MouseButton1Down:Connect(Update)	
					
					Config.Sliders[Flag] = {
						Value = Properties.Default or Properties.Min,
						SetValue = SetValue,
					}
				end
				
				function Items:AddLabel(Properties)
					local Label = Instance_new("Frame")
					local LabelText = Instance_new("TextLabel")

					Label.Name = "Label"
					Label.Parent = Section
					Label.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
					Label.BackgroundTransparency = 1
					Label.BorderColor3 = Color3_fromRGB(0, 0, 0)
					Label.BorderSizePixel = 0
					Label.Size = UDim2_new(1, 0, 0, 20)

					LabelText.Parent = Label
					LabelText.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
					LabelText.BackgroundTransparency = 1
					LabelText.BorderColor3 = Color3_fromRGB(0, 0, 0)
					LabelText.BorderSizePixel = 0
					LabelText.Position = UDim2_new(0, 12, 0, 3)
					LabelText.Size = UDim2_new(0, 162, 0, 12)
					LabelText.Font = Enum.Font.Code
					LabelText.Text = Properties.Text
					LabelText.TextColor3 = Color3_fromRGB(160, 160, 160)
					LabelText.TextSize = 14
					LabelText.TextXAlignment = Enum.TextXAlignment.Left
					
					local Items = {}
					function Items:AddKeypicker(Flag, Properties)
						local TextButton = Instance_new("TextButton")
						TextButton.Parent = Label
						TextButton.BackgroundTransparency = 1
						TextButton.Position = UDim2_new(1, -47, 0.5, -6)
						TextButton.Size = UDim2_new(0, 35, 0, 12)
						TextButton.AutoButtonColor = false
						TextButton.Font = Enum.Font.SourceSans
						TextButton.Text = "[" .. Properties.Default .. "]";
						TextButton.TextColor3 = Color3_fromRGB(255, 255, 255)
						TextButton.TextSize = 14
						TextButton.TextXAlignment = Enum.TextXAlignment.Right

						local cooldown = false
						local key = Properties.Default
						local allowKeyChange = false
						TextButton.MouseButton1Click:Connect(function()
							if not cooldown then
								cooldown = true
								TextButton.Text = "[...]"
								allowKeyChange = true
							end
						end)

						local toggled = false
						UserInputService.InputBegan:Connect(function(input, processed)
							if allowKeyChange and not processed then
								if input.UserInputType == Enum.UserInputType.Keyboard then
									key = input.KeyCode.Name
								elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
									key = 'MB1'
								elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
									key = 'MB2'
								end
								allowKeyChange = false
								Config.KeyPickers[Flag].Value = key
								TextButton.Text = "[" .. key .. "]"
								wait(0.1)
								cooldown = false
							else
								if not processed and not cooldown then
									if (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == key) or (input.UserInputType == Enum.UserInputType.MouseButton1 and key == "MB1") or (input.UserInputType == Enum.UserInputType.MouseButton2 and key == "MB2") then
										toggled = not toggled
										if Properties.Mode == 'Held' then
											pcall(Properties.Callback, true)
										elseif Properties.Mode == 'Toggle' then
											pcall(Properties.Callback, toggled)
										end
									end
								end
							end
						end)
						UserInputService.InputEnded:Connect(function(input, processed)
							if not processed and not cooldown then
								if (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == key) or (input.UserInputType == Enum.UserInputType.MouseButton1 and key == "MB1") or (input.UserInputType == Enum.UserInputType.MouseButton2 and key == "MB2") then
									if Properties.Mode == 'Held' then
										pcall(Properties.Callback, false)
									end
								end
							end
						end)

						local function SetValue(KeyInput)
							key = KeyInput
							TextButton.Text = "[" .. key .. "]"
							Config.KeyPickers[Flag].Value = key
						end

						Config.KeyPickers[Flag] = {
							Value = key,
							SetValue = SetValue
						}
					end

					function Items:AddColorPicker(Flag, Properties)
						local ColorButton = Instance_new("ImageButton")
						local UICorner = Instance_new("UICorner")

						ColorButton.Parent = Label
						ColorButton.AutoButtonColor = false
						ColorButton.BackgroundColor3 = Properties.Default
						ColorButton.Position = UDim2_new(1, -32, 0.5, -6)
						ColorButton.Size = UDim2_new(0, 20, 0, 12)

						UICorner.CornerRadius = UDim_new(0, 2)
						UICorner.Parent = ColorButton

						local Frame = Instance_new("Frame")
						local Color = Instance_new("ImageButton")
						local HSV = Instance_new("ImageButton")
						local RGBBox = Instance_new("TextBox")
						local HEXBox = Instance_new("TextBox")

						Frame.Parent = MainFrame
						Frame.BackgroundColor3 = Color3_fromRGB(23, 23, 23)
						Frame.Size = UDim2_new(0, 160, 0, 160)
						Frame.Visible = false

						Color.Parent = Frame
						Color.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
						Color.BorderColor3 = Color3_fromRGB(0, 0, 0)
						Color.BorderSizePixel = 0
						Color.Size = UDim2_new(0, 150, 0, 150)
						Color.AutoButtonColor = false
						Color.Image = "rbxassetid://17346159171"
						Color.ImageColor3 = Properties.Default

						local Picking = false
						local Hue, Saturation, Value = Properties.Default:ToHSV()
						Color.ImageColor3 = Color3_fromHSV(Hue, 1, 1);
						Color.InputBegan:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								Picking = true
							end
						end)

						Color.InputEnded:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								Picking = false
							end
						end)

						UserInputService.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement and Picking then
								Saturation = 1-math_clamp((Mouse.X-Frame.AbsolutePosition.X)/Frame.AbsoluteSize.X, 0, 1)
								Value = 1-math_clamp((Mouse.Y-Frame.AbsolutePosition.Y)/Frame.AbsoluteSize.Y, 0, 1)
								local ChosenColor = Color3_fromHSV(Hue, Saturation, Value)
								ColorButton.BackgroundColor3 = ChosenColor
								RGBBox.Text = table.concat({ math.floor(ChosenColor.R * 255), math.floor(ChosenColor.G * 255), math.floor(ChosenColor.B * 255) }, ', ')
								HEXBox.Text = "#" .. ChosenColor:ToHex()
								Config.ColorPickers[Flag].H = Hue
								Config.ColorPickers[Flag].S = Saturation
								Config.ColorPickers[Flag].V = Value
								pcall(Properties.Callback, ChosenColor);
							end
						end)

						HSV.Parent = Frame
						HSV.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
						HSV.BorderColor3 = Color3_fromRGB(0, 0, 0)
						HSV.BorderSizePixel = 0
						HSV.Position = UDim2_new(0, 150, 0, 0)
						HSV.Size = UDim2_new(0, 10, 0, 150)
						HSV.AutoButtonColor = false
						HSV.Image = "rbxassetid://17336552773"

						local PickingHue = false
						HSV.InputBegan:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								PickingHue = true
							end
						end)

						HSV.InputEnded:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								PickingHue = false
							end
						end)

						UserInputService.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement and PickingHue then
								local ChosenHue = 1-math_clamp((Mouse.Y-HSV.AbsolutePosition.Y)/HSV.AbsoluteSize.Y, 0, 1)
								Hue = ChosenHue
								local ChosenColor = Color3_fromHSV(Hue, Saturation, Value)
								Color.ImageColor3 = Color3_fromHSV(Hue, 1,1)
								ColorButton.BackgroundColor3 = ChosenColor
								RGBBox.Text = table.concat({ math.floor(ChosenColor.R * 255), math.floor(ChosenColor.G * 255), math.floor(ChosenColor.B * 255) }, ', ')
								HEXBox.Text = "#" .. ChosenColor:ToHex()
								Config.ColorPickers[Flag].H = Hue
								Config.ColorPickers[Flag].S = Saturation
								Config.ColorPickers[Flag].V = Value
								pcall(Properties.Callback, ChosenColor);
							end
						end)

						ColorButton.MouseButton1Click:Connect(function()
							Frame.Visible = not Frame.Visible
							Frame.Position = UDim2_new(0, (ColorButton.AbsolutePosition.X + ColorButton.AbsoluteSize.X)-MainFrame.AbsolutePosition.X, 0, (ColorButton.AbsolutePosition.Y + ColorButton.AbsoluteSize.Y)-MainFrame.AbsolutePosition.Y)
						end)

						RGBBox.Parent = Frame
						RGBBox.BackgroundTransparency = 1
						RGBBox.Position = UDim2_new(0, 0, 1, -10)
						RGBBox.Size = UDim2_new(0.5, 0, 0, 10)
						RGBBox.Font = Enum.Font.Code
						RGBBox.PlaceholderColor3 = Color3_fromRGB(160, 160, 160)
						RGBBox.PlaceholderText = "RGB"
						local function hex2rgb(hex)
							hex = hex:gsub("#","")
							local r = tonumber("0x"..hex:sub(1,2))
							local g = tonumber("0x"..hex:sub(3,4))
							local b = tonumber("0x"..hex:sub(5,6))
							return table.concat({r,g,b}, ', ')
						end
						RGBBox.Text = hex2rgb(Properties.Default:ToHex())
						RGBBox.TextColor3 = Color3_fromRGB(160, 160, 160)
						RGBBox.TextSize = 11
						RGBBox.TextXAlignment = Enum.TextXAlignment.Center
						RGBBox.FocusLost:Connect(function(Enter)
							if Enter then
								local r, g, b = RGBBox.Text:match('(%d+),%s*(%d+),%s*(%d+)')
								if r and g and b then
									local H,S,V = Color3_fromRGB(r, g, b):ToHSV()
									Color.ImageColor3 = Color3_fromHSV(H, 1,1)
									local HSVColor = Color3_fromHSV(H,S,V)
									ColorButton.BackgroundColor3 = HSVColor
									RGBBox.Text = hex2rgb(HSVColor:ToHex());
									HEXBox.Text = "#" .. HSVColor:ToHex();
									Config.ColorPickers[Flag].H = H
									Config.ColorPickers[Flag].S = S
									Config.ColorPickers[Flag].V = V
									pcall(Properties.Callback, HSVColor);
								end
							end
						end)

						HEXBox.Parent = Frame
						HEXBox.BackgroundTransparency = 1
						HEXBox.Position = UDim2_new(.5, 0, 1, -10)
						HEXBox.Size = UDim2_new(0.5, 0, 0, 10)
						HEXBox.Font = Enum.Font.Code
						HEXBox.PlaceholderColor3 = Color3_fromRGB(160, 160, 160)
						HEXBox.PlaceholderText = "HEX"
						HEXBox.Text = "#" .. Properties.Default:ToHex();
						HEXBox.TextColor3 = Color3_fromRGB(160, 160, 160)
						HEXBox.TextSize = 11
						HEXBox.TextXAlignment = Enum.TextXAlignment.Center
						HEXBox.FocusLost:Connect(function(Enter)
							if Enter then
								local success, result = pcall(Color3_fromHex, HEXBox.Text)
								if success and typeof(result) == 'Color3' then
									local H,S,V = result:ToHSV()
									Color.ImageColor3 = Color3_fromHSV(H, 1,1)
									local HSVColor = Color3_fromHSV(H,S,V);
									ColorButton.BackgroundColor3 = HSVColor
									RGBBox.Text = hex2rgb(HSVColor:ToHex());
									HEXBox.Text = "#" .. HSVColor:ToHex();
									Config.ColorPickers[Flag].H = H
									Config.ColorPickers[Flag].S = S
									Config.ColorPickers[Flag].V = V
									pcall(Properties.Callback, Color3_fromHSV(H,S,V));
								end
							end
						end)

						local function SetValue(ColorInput)
							local ChosenColor = ColorInput:ToHex()

							local r, g, b = hex2rgb(ChosenColor):match('(%d+),%s*(%d+),%s*(%d+)')
							if r and g and b then
								local H,S,V = Color3_fromRGB(r, g, b):ToHSV()
								Hue, Saturation, Value = H,S,V;
								Color.ImageColor3 = Color3_fromHSV(H,1,1)
								local HSVColor = Color3_fromHSV(H,S,V)
								ColorButton.BackgroundColor3 = HSVColor
								RGBBox.Text = hex2rgb(HSVColor:ToHex());
								HEXBox.Text = "#" .. HSVColor:ToHex();
								Config.ColorPickers[Flag].H = Hue
								Config.ColorPickers[Flag].S = Saturation
								Config.ColorPickers[Flag].V = Value
								pcall(Properties.Callback, HSVColor);
							end
						end

						Config.ColorPickers[Flag] = {
							H = Hue,
							S = Saturation,
							V = Value,
							SetValue = SetValue,
						}
					end
					return Items;
				end
				
				function Items:AddButton(Properties)
					local Button = Instance_new("Frame")
					local ButtonButton = Instance_new("TextButton")
					
					Button.Parent = Section
					Button.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
					Button.BackgroundTransparency = 1
					Button.BorderColor3 = Color3_fromRGB(0, 0, 0)
					Button.BorderSizePixel = 0
					Button.Size = UDim2_new(1, 0, 0, 24)

					ButtonButton.Parent = Button
					ButtonButton.AnchorPoint = Vector2_new(0.5, 0)
					ButtonButton.BackgroundColor3 = Color3_fromRGB(22, 19, 22)
					ButtonButton.BorderColor3 = Color3_fromRGB(45, 42, 45)
					ButtonButton.Position = UDim2_new(0.5, 0, 1, -20)
					ButtonButton.Size = UDim2_new(1, -25, 0, 16)
					ButtonButton.Font = Enum.Font.Code
					ButtonButton.Text = Properties.Text
					ButtonButton.TextColor3 = Color3_fromRGB(160, 160, 160)
					ButtonButton.TextSize = 13
					
					ButtonButton.MouseButton1Click:Connect(Properties.Callback)
				end
				return Items;
			end
			return Items;
		end
		return Items;
	end
end

return Library, Config