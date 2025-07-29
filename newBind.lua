-- newBind - Hoverbind functionality for default WoW UI
-- Based on pfUI hoverbind module but adapted for default UI

local newBind = CreateFrame("Frame", "newBindFrame", UIParent)
newBind:Hide()

-- Key mapping for different action bar buttons
local keymap = {
    -- Default action bar buttons
    ["ActionButton"] = "ACTIONBUTTON",
    
    -- Multi-action bar buttons
    ["MultiBarBottomLeftButton"] = "MULTIACTIONBAR1BUTTON",
    ["MultiBarBottomRightButton"] = "MULTIACTIONBAR2BUTTON", 
    ["MultiBarRightButton"] = "MULTIACTIONBAR3BUTTON",
    ["MultiBarLeftButton"] = "MULTIACTIONBAR4BUTTON",
    
    -- Pet action bar
    ["PetActionButton"] = "BONUSACTIONBUTTON",
    
    -- Shapeshift/Stance bar
    ["ShapeshiftButton"] = "SHAPESHIFTBUTTON",
}

-- Mouse button mapping
local mousebuttonmap = {
    ["LeftButton"]   = "BUTTON1",
    ["RightButton"]  = "BUTTON2", 
    ["MiddleButton"] = "BUTTON3",
    ["Button4"]      = "BUTTON4",
    ["Button5"]      = "BUTTON5",
}

-- Mouse wheel mapping
local mousewheelmap = {
    [1]  = "MOUSEWHEELUP",
    [-1] = "MOUSEWHEELDOWN",
}

-- Modifier keys
local modifiers = {
    ["ALT"]   = "ALT-",
    ["CTRL"]  = "CTRL-", 
    ["SHIFT"] = "SHIFT-"
}

-- Keys that require modifiers to bind
local blockedKeys = {
    "LeftButton",
    "RightButton",
}

-- Initialize the addon
function newBind:Initialize()
    -- Create the overlay frame
    self.edit = CreateFrame("Button", "newBindEditFrame", self)
    self.edit:SetFrameStrata("BACKGROUND")
    self.edit:SetAllPoints(UIParent)
    
    -- Create background texture
    self.edit.tex = self.edit:CreateTexture("newBindShade", "BACKGROUND")
    self.edit.tex:SetAllPoints(self.edit)
    self.edit.tex:SetTexture(0, 0, 0, 0.5)
    
    -- Click to exit
    self.edit:SetScript("OnClick", function()
        newBind:Hide()
    end)
    
    -- Register events
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:EnableMouse(true)
    
    -- Set up event handlers
    self:SetScript("OnMouseUp", function()
        newBind:Hide()
    end)
    
    self:SetScript("OnShow", function()
        newBind:ShowHoverbindFrames()
        newBind.edit:Show()
        
        local txt = "|cff33ffccKeybind Mode|r\nThis mode allows you to bind keyboard shortcuts to your actionbars.\nBy hovering a button with your cursor and pressing a key, the key will be assigned to that button.\nHit Escape on a button to remove bindings.\n\nPress Escape or click on an empty area to leave the keybind mode."
        newBind:CreateInfoBox(txt, 5)
    end)
    
    self:SetScript("OnHide", function()
        newBind:HideHoverbindFrames()
        newBind.edit:Hide()
    end)
    
    -- Combat event handler
    self:SetScript("OnEvent", function()
        newBind:Hide()
    end)
    
    -- Create hoverbind frames for all action buttons
    self:CreateHoverbindFrames()
end

-- Create info box for instructions
function newBind:CreateInfoBox(text, lines)
    if self.infoBox then
        self.infoBox:Hide()
    end
    
    self.infoBox = CreateFrame("Frame", "newBindInfoBox", self.edit)
    self.infoBox:SetWidth(400)
    self.infoBox:SetHeight(lines * 20 + 40)
    self.infoBox:SetPoint("CENTER", self.edit, "CENTER", 0, 0)
    
    -- Background
    self.infoBox.bg = self.infoBox:CreateTexture(nil, "BACKGROUND")
    self.infoBox.bg:SetAllPoints()
    self.infoBox.bg:SetTexture(0.1, 0.1, 0.1, 0.9)
    
    -- Border
    self.infoBox.border = self.infoBox:CreateTexture(nil, "BORDER")
    self.infoBox.border:SetAllPoints()
    self.infoBox.border:SetTexture(0.3, 0.3, 0.3, 1)
    
    -- Text
    self.infoBox.text = self.infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.infoBox.text:SetAllPoints()
    self.infoBox.text:SetJustifyH("LEFT")
    self.infoBox.text:SetJustifyV("TOP")
    self.infoBox.text:SetText(text)
    
end

-- Get binding string for a button
function newBind:GetBinding(button_name)
    local found, _, buttontype, buttonindex = string.find(button_name, "^(.-)(%d+)$")
    if found then
        if keymap[buttontype] then
            return string.format("%s%d", keymap[buttontype], buttonindex)
        elseif buttontype == "ActionButton" then
            return string.format("ACTIONBUTTON%d", buttonindex)
        else
            return nil
        end
    else
        return nil
    end
end

-- Get current modifier prefix
function newBind:GetPrefix()
    return string.format("%s%s%s",
        (IsAltKeyDown() and modifiers.ALT or ""),
        (IsControlKeyDown() and modifiers.CTRL or ""),
        (IsShiftKeyDown() and modifiers.SHIFT or ""))
end

-- Create hoverbind frames for all action buttons
function newBind:CreateHoverbindFrames()
    self.frames = {}
    
    -- Action buttons (1-12)
    for i = 1, 12 do
        local button = getglobal("ActionButton"..i)
        if button then
            self:CreateHoverbindFrame(button)
        end
    end
    
    -- Multi-action bar buttons
    for i = 1, 12 do
        local button = getglobal("MultiBarBottomLeftButton"..i)
        if button then
            self:CreateHoverbindFrame(button)
        end
    end
    
    for i = 1, 12 do
        local button = getglobal("MultiBarBottomRightButton"..i)
        if button then
            self:CreateHoverbindFrame(button)
        end
    end
    
    for i = 1, 12 do
        local button = getglobal("MultiBarRightButton"..i)
        if button then
            self:CreateHoverbindFrame(button)
        end
    end
    
    for i = 1, 12 do
        local button = getglobal("MultiBarLeftButton"..i)
        if button then
            self:CreateHoverbindFrame(button)
        end
    end
    
    -- Pet action buttons
    for i = 1, 10 do
        local button = getglobal("PetActionButton"..i)
        if button then
            self:CreateHoverbindFrame(button)
        end
    end
    
    -- Shapeshift buttons
    for i = 1, 10 do
        local button = getglobal("ShapeshiftButton"..i)
        if button then
            self:CreateHoverbindFrame(button)
        end
    end
end

-- Create a hoverbind frame for a specific button
function newBind:CreateHoverbindFrame(button)
    if not button then return end
    
    local frame = CreateFrame("Frame", button:GetName() .. "HoverbindFrame", button)
    frame:SetAllPoints(button)
    frame:EnableKeyboard(true)
    frame:EnableMouse(true)
    frame:EnableMouseWheel(true)
    frame:Hide()
    
    -- Store reference to the button
    frame.button = button
    
    -- Create event handler
    local function GetHoverbindHandler(map)
        return function()
            if modifiers[arg1] then return end -- ignore single modifier keyup
            
            local prefix = newBind:GetPrefix()
            
            -- Don't allow binding certain buttons without modifiers
            if not prefix or prefix == "" then
                for _, blockedKey in ipairs(blockedKeys) do
                    if arg1 == blockedKey then return end
                end
            end
            
            local frame = GetMouseFocus()
            local hovername = (frame and frame.button and frame.button.GetName) and frame.button:GetName() or ""
            local binding = newBind:GetBinding(hovername)
            
            if arg1 == "ESCAPE" and not binding then 
                newBind:Hide() 
                return 
            end
            
            if binding then
                if arg1 == "ESCAPE" then
                    -- Remove existing binding
                    local key = GetBindingKey(binding)
                    if key then
                        SetBinding(key)
                        SaveBindings(GetCurrentBindingSet())
                    end
                else
                    -- Create new binding
                    local key = map and map[arg1] or arg1
                    if SetBinding(prefix..key, binding) then
                        SaveBindings(GetCurrentBindingSet())
                    end
                end
            end
        end
    end
    
    frame:SetScript("OnKeyUp", GetHoverbindHandler())
    frame:SetScript("OnMouseUp", GetHoverbindHandler(mousebuttonmap))
    frame:SetScript("OnMouseWheel", GetHoverbindHandler(mousewheelmap))
    
    -- Handle mouse enter/leave for tooltips
    frame:SetScript("OnEnter", function()
        if button:GetScript("OnEnter") then
            button:GetScript("OnEnter")(button)
        end
    end)
    
    frame:SetScript("OnLeave", function()
        if button:GetScript("OnLeave") then
            button:GetScript("OnLeave")(button)
        end
    end)
    
    table.insert(self.frames, frame)
end

-- Show all hoverbind frames
function newBind:ShowHoverbindFrames()
    if not self.frames then return end
    for _, frame in ipairs(self.frames) do
        frame:Show()
    end
end

-- Hide all hoverbind frames
function newBind:HideHoverbindFrames()
    if not self.frames then return end
    for _, frame in ipairs(self.frames) do
        frame:Hide()
    end
end

-- Slash command to activate hoverbind mode
SLASH_NEWBIND1 = "/newbind"
SLASH_NEWBIND2 = "/kb"
SlashCmdList["NEWBIND"] = function()
    if UnitAffectingCombat("player") then
        print("You can't bind keys in combat.")
        return
    end
    
    if not newBind.loaded then
        newBind:Initialize()
        newBind.loaded = true
    end
    
    newBind:Show()
end

-- Initialize when addon loads
newBind:Initialize()
newBind.loaded = true 