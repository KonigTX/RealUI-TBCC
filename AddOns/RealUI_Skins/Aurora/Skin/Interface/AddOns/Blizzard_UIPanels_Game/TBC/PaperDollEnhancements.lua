local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals next tonumber type pcall ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base

local RealUI = _G.RealUI

--[[
    TBC-Compatible Item Level and Durability Display

    This module adds item level and durability overlays to character equipment slots.
    Designed for TBCC Anniversary with fallback for missing APIs.
]]

-- Get item level with fallback for missing C_Item API
local scanningTooltip = _G.RealUIScanningTooltip
local itemLevelPattern = _G.ITEM_LEVEL and _G.ITEM_LEVEL:gsub("%%d", "(%%d+)") or "Item Level (%d+)"

local function GetItemLevel(itemLink)
    if not itemLink then return 0 end

    -- Try modern API first (if available)
    if _G.C_Item and _G.C_Item.GetDetailedItemLevelInfo then
        local iLvl = _G.C_Item.GetDetailedItemLevelInfo(itemLink)
        if iLvl and iLvl > 0 then
            return iLvl
        end
    end

    -- Fallback: Use RealUI's item level function if available
    if RealUI and RealUI.GetItemLevel then
        return RealUI.GetItemLevel(itemLink)
    end

    -- Last resort: Parse tooltip
    if not scanningTooltip then
        return 0
    end

    scanningTooltip:ClearLines()
    local success = pcall(scanningTooltip.SetHyperlink, scanningTooltip, itemLink)
    if not success then
        return 0
    end

    -- Scan tooltip lines for item level
    for i = 2, scanningTooltip:NumLines() do
        local line = _G["RealUIScanningTooltipTextLeft"..i]
        if line then
            local text = line:GetText()
            if text then
                local iLvl = text:match(itemLevelPattern)
                if iLvl then
                    return tonumber(iLvl) or 0
                end
            end
        end
    end

    return 0
end

-- Get durability color (red->yellow->green gradient)
local function GetDurabilityColor(current, max)
    if not current or not max or max == 0 then
        return 0, 1, 0 -- Default green
    end

    local percent = current / max

    if percent >= 0.5 then
        -- Green to yellow (100% to 50%)
        local ratio = (1 - percent) * 2
        return ratio, 1, 0
    else
        -- Yellow to red (50% to 0%)
        local ratio = percent * 2
        return 1, ratio, 0
    end
end

-- Hide all enhancements
local function HideEnhancements(button)
    if button.ilvl then
        button.ilvl:Hide()
    end
    if button.dura then
        button.dura:Hide()
    end
end

-- Update item level and durability displays
local function UpdateEnhancements(button)
    if not button.ilvl or not button.dura then
        return
    end

    local slotID = button:GetID()
    local itemLink = _G.GetInventoryItemLink("player", slotID)

    if not itemLink then
        HideEnhancements(button)
        return
    end

    -- Update item level
    local itemLevel = GetItemLevel(itemLink)
    if itemLevel > 1 then
        local quality = _G.GetInventoryItemQuality("player", slotID)
        if quality and _G.ITEM_QUALITY_COLORS[quality] then
            local color = _G.ITEM_QUALITY_COLORS[quality]
            button.ilvl:SetTextColor(color.r, color.g, color.b)
        else
            button.ilvl:SetTextColor(1, 1, 1) -- White fallback
        end
        button.ilvl:SetText(itemLevel)
        button.ilvl:Show()
    else
        button.ilvl:Hide()
    end

    -- Update durability
    local curDurability, maxDurability = _G.GetInventoryItemDurability(slotID)
    if maxDurability and maxDurability > 0 then
        local percent = curDurability / maxDurability
        button.dura:SetMinMaxValues(0, 1)
        button.dura:SetValue(percent)

        local r, g, b = GetDurabilityColor(curDurability, maxDurability)
        button.dura:SetStatusBarColor(r, g, b)
        button.dura:Show()
    else
        button.dura:Hide()
    end
end

-- Create enhancement overlays for a button
local function CreateEnhancements(button)
    if button.ilvl then return end -- Already created

    local name = button:GetName()
    if not name then return end

    -- Create item level text
    local ilvl = button:CreateFontString(name.."ItemLevel", "OVERLAY")
    ilvl:SetFontObject(_G.NumberFont_Outline_Med)
    ilvl:SetJustifyH("RIGHT")
    ilvl:SetPoint("BOTTOMRIGHT", -1, 1)
    ilvl:SetPoint("BOTTOMLEFT", 1, 1)
    button.ilvl = ilvl

    -- Create durability bar
    local dura = _G.CreateFrame("StatusBar", nil, button)
    dura:SetStatusBarTexture(private.textures.plain or [[Interface\TargetingFrame\UI-StatusBar]])
    dura:SetOrientation("VERTICAL")
    dura:SetMinMaxValues(0, 1)
    dura:SetValue(0)
    dura:SetWidth(2)
    dura:SetPoint("TOPRIGHT", -1, -1)
    dura:SetPoint("BOTTOMRIGHT", -1, 1)

    -- Add background to durability bar
    local duraBG = dura:CreateTexture(nil, "BACKGROUND")
    duraBG:SetColorTexture(0, 0, 0, 0.5)
    duraBG:SetPoint("TOPLEFT", dura, -1, 1)
    duraBG:SetPoint("BOTTOMRIGHT", dura, 1, -1)

    button.dura = dura
end

-- Equipment slot names to enhance
local equipmentSlots = {
    "CharacterHeadSlot",
    "CharacterNeckSlot",
    "CharacterShoulderSlot",
    "CharacterBackSlot",
    "CharacterChestSlot",
    "CharacterShirtSlot",
    "CharacterTabardSlot",
    "CharacterWristSlot",
    "CharacterHandsSlot",
    "CharacterWaistSlot",
    "CharacterLegsSlot",
    "CharacterFeetSlot",
    "CharacterFinger0Slot",
    "CharacterFinger1Slot",
    "CharacterTrinket0Slot",
    "CharacterTrinket1Slot",
    "CharacterMainHandSlot",
    "CharacterSecondaryHandSlot",
    "CharacterRangedSlot",
}

-- Initialize enhancements on all equipment slots
local function InitializeEnhancements()
    for _, slotName in ipairs(equipmentSlots) do
        local button = _G[slotName]
        if button then
            CreateEnhancements(button)
            -- Update immediately
            UpdateEnhancements(button)
        end
    end
end

-- Hook the update function
local function HookSlotUpdate(button)
    UpdateEnhancements(button)
end

-- Register hooks when PaperDollFrame is available
function private.FrameXML.PaperDollEnhancements()
    -- Wait for frame to be ready
    if not _G.CharacterHeadSlot then
        -- Schedule retry
        _G.C_Timer.After(0.1, private.FrameXML.PaperDollEnhancements)
        return
    end

    -- Create enhancement overlays
    InitializeEnhancements()

    -- Hook the update function if it exists
    if _G.PaperDollItemSlotButton_Update then
        _G.hooksecurefunc("PaperDollItemSlotButton_Update", HookSlotUpdate)
    end
end

-- Initialize when PaperDollFrame is loaded
if private.FrameXML and private.FrameXML.PaperDollFrame then
    _G.hooksecurefunc(private.FrameXML, "PaperDollFrame", function()
        if private.FrameXML.PaperDollEnhancements then
            private.FrameXML.PaperDollEnhancements()
        end
    end)
end
