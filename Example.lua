local Library, Config = loadstring(game:HttpGet('https://raw.githubusercontent.com/rremedyy/Ecstasy/main/Library'))()

local Library = Library:Init({
	Name = "Test UI";
});

local Main = Library:AddTab({
	Name = "Tab 1";
});
local General = Main:AddSection({
	Name = 'Section 1';
	Side = 'Left';
});
General:AddToggle('ToggleFlag1', {
	Text = 'Toggle 1';
	Default = false;
	Callback = function(Value)
      print(Value)
	end;
}):AddColorPicker('ColorPickerFlag1', {
	Default = Color3.fromRGB(255,255,255);
	Callback = function(Value)
      print(Value)
	end;
});
General:AddToggle('ToggleFlag2', {
	Text = 'Toggle 2';
	Default = true;
	Callback = function(Value)
      print(Value)
	end;
}):AddKeypicker('KeyPickerFlag1', {
	Default = 'X';
	Mode = 'Toggle'; -- Held, Toggle
	Callback = function(Value)
		print(Value)
	end;
});
General:AddSlider('SliderFlag1', {
	Text = 'Slider 1';
	Default = 15;
	Min = 5;
	Max = 65;
	Callback = function(Value)
      print(Value)
	end;
});
General:AddLabel({
	Text = 'Label 1';
})
ConfigSection:AddButton({
	Text = 'Button 1';
	Callback = function()
		print('Button Clicked')
	end;
});
