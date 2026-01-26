local _, private = ...
-- This file contains Retail-only code, skip on Classic
if not private.isRetail then return end

-- [[ Lua Globals ]]
-- luacheck: globals

-- [[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Color = Aurora.Color

-- do --[[ FrameXML\LFGFrame.lua ]]
-- end

-- do --[[ FrameXML\LFGFrame.xml ]]
-- end

-- TBCC: LFG (Looking For Group) frame is different in TBC - LFD was added in WotLK
-- Check if private.AddOns["LFGFrame"] exists before hooking
if private.AddOns and private.AddOns["LFGFrame"] and type(private.AddOns["LFGFrame"]) == "function" then
    _G.hooksecurefunc(private.AddOns, "LFGFrame", function()
        -- TBCC: Use IsAddOnLoaded() instead of C_AddOns.IsAddOnLoaded()
        local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
        if IsAddOnLoaded("DBM-Core") or IsAddOnLoaded("BigWigs") then return end

    local LFGDungeonReadyDialog = _G.LFGDungeonReadyDialog

    local timerBar = _G.CreateFrame("StatusBar", nil, LFGDungeonReadyDialog)
    Skin.FrameTypeStatusBar(timerBar)
    timerBar:SetPoint("BOTTOM", 0, 8)
    timerBar:SetSize(242, 12)
    timerBar:SetStatusBarColor(Color.yellow:GetRGB())
    LFGDungeonReadyDialog.timerBar = timerBar

    local duration, remaining = 40
    timerBar:SetMinMaxValues(0, duration)
    timerBar:SetScript("OnUpdate", function(dialog, elapsed)
        if not remaining then
            remaining = duration
        end
        remaining = remaining - elapsed

        if remaining > 0 then
            dialog:SetValue(remaining)
        else
            remaining = nil
        end
    end)
    end)
end -- TBCC: End of safety check for private.AddOns["LFGFrame"]
