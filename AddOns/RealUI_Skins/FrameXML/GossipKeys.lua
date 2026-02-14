local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals hooksecurefunc

--[[ Core ]]
-- Add keyboard shortcuts (1-9) for GossipFrame dialog options
-- Uses override bindings to avoid protected function taint

local GossipKeyHandler = CreateFrame("Frame", "RealUI_GossipKeyHandler", UIParent)
local bindingsActive = false

-- Click a gossip option by number
local function ClickGossipOption(num)
    local button = _G["GossipTitleButton"..num]
    if button and button:IsVisible() and button:IsEnabled() then
        button:Click()
    end
end

-- Create click functions for each number key
local function GossipKey1() ClickGossipOption(1) end
local function GossipKey2() ClickGossipOption(2) end
local function GossipKey3() ClickGossipOption(3) end
local function GossipKey4() ClickGossipOption(4) end
local function GossipKey5() ClickGossipOption(5) end
local function GossipKey6() ClickGossipOption(6) end
local function GossipKey7() ClickGossipOption(7) end
local function GossipKey8() ClickGossipOption(8) end
local function GossipKey9() ClickGossipOption(9) end

-- Register these as global functions so SetOverrideBindingClick can use them
_G["RealUI_GossipKey1"] = GossipKey1
_G["RealUI_GossipKey2"] = GossipKey2
_G["RealUI_GossipKey3"] = GossipKey3
_G["RealUI_GossipKey4"] = GossipKey4
_G["RealUI_GossipKey5"] = GossipKey5
_G["RealUI_GossipKey6"] = GossipKey6
_G["RealUI_GossipKey7"] = GossipKey7
_G["RealUI_GossipKey8"] = GossipKey8
_G["RealUI_GossipKey9"] = GossipKey9

-- Create invisible buttons that the bindings will click
for i = 1, 9 do
    local btn = CreateFrame("Button", "RealUI_GossipKeyBtn"..i, GossipKeyHandler, "SecureActionButtonTemplate")
    btn:SetAttribute("type", "click")
    btn:SetScript("PreClick", function()
        ClickGossipOption(i)
    end)
end

-- Enable keybinds when GossipFrame opens
local function EnableGossipBindings()
    if bindingsActive then return end
    bindingsActive = true

    -- Use override bindings (these override action bar binds temporarily)
    for i = 1, 9 do
        SetOverrideBindingClick(GossipKeyHandler, false, tostring(i), "RealUI_GossipKeyBtn"..i)
    end
end

-- Disable keybinds when GossipFrame closes
local function DisableGossipBindings()
    if not bindingsActive then return end
    bindingsActive = false

    -- Clear all override bindings
    ClearOverrideBindings(GossipKeyHandler)
end

-- Watch for GossipFrame show/hide
GossipKeyHandler:RegisterEvent("GOSSIP_SHOW")
GossipKeyHandler:RegisterEvent("GOSSIP_CLOSED")
GossipKeyHandler:SetScript("OnEvent", function(self, event)
    if event == "GOSSIP_SHOW" then
        EnableGossipBindings()
    elseif event == "GOSSIP_CLOSED" then
        DisableGossipBindings()
    end
end)

-- Also check if GossipFrame is hidden via other means
if _G.GossipFrame then
    _G.GossipFrame:HookScript("OnHide", DisableGossipBindings)
end
