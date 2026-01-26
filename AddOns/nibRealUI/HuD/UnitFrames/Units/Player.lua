local _, private = ...

-- Libs --
local oUF = private.oUF

-- RealUI --
local RealUI = private.RealUI
local db

local UnitFrames = RealUI:GetModule("UnitFrames")

-- TBCC: TotemFrame works differently in TBC Classic
-- Only Shamans have totems and the API is completely different
local function CreateTotems(parent)
    -- In TBCC, TotemFrame is only available for Shamans and uses a different structure
    local TotemFrame = _G.TotemFrame
    if not TotemFrame then return end

    -- TBCC: Check if we're a Shaman (class ID 7)
    local _, classFile = _G.UnitClass("player")
    if classFile ~= "SHAMAN" then return end

    -- TBCC: TotemFrame exists but has a simpler structure
    -- Just reposition it relative to the player frame
    TotemFrame:SetParent(parent.overlay)
    TotemFrame:ClearAllPoints()
    TotemFrame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 10, -4)

    -- TBCC: Individual totem buttons are TotemFrameTotem1, TotemFrameTotem2, etc.
    for i = 1, _G.MAX_TOTEMS or 4 do
        local totem = _G["TotemFrameTotem" .. i]
        if totem then
            totem:SetSize(22, 22)
        end
    end
end

UnitFrames.player = {
    create = function(dialog)
        CreateTotems(dialog)

        --[[ Additional Power ]]--
        local AdditionalPower = _G.CreateFrame("StatusBar", nil, dialog.Power)
        AdditionalPower:SetStatusBarTexture(RealUI.textures.plain, "BORDER")
        AdditionalPower:SetStatusBarColor(0, 0, 0, 0.75)
        AdditionalPower:SetPoint("BOTTOMLEFT", dialog.Power, "TOPLEFT", 0, 0)
        AdditionalPower:SetPoint("BOTTOMRIGHT", dialog.Power, "TOPRIGHT", -dialog.Power:GetHeight(), 0)
        AdditionalPower:SetHeight(1)

        local bg = AdditionalPower:CreateTexture(nil, 'BACKGROUND')
        bg:SetAllPoints(AdditionalPower)
        bg:SetColorTexture(.2, .2, 1)

        function AdditionalPower.PostUpdate(this, cur, max)
            if cur == max then
                if this:IsVisible() then
                    this:Hide()
                end
            else
                if not this:IsVisible() then
                    this:Show()
                end
            end
        end

        AdditionalPower.colorPower = true
        -- TBCC: Power types are simple integers, not Enum.PowerType
        -- 0 = Mana, 1 = Rage, 2 = Focus, 3 = Energy
        AdditionalPower.displayPairs = {
            DRUID = {
                [1] = true, -- Rage (Bear form)
                [3] = true, -- Energy (Cat form)
            },
            -- TBCC: Priest doesn't have Insanity, Shaman doesn't have Maelstrom
        }

        dialog.AdditionalPower = AdditionalPower
        dialog.AdditionalPower.bg = bg

        --[[ PvP Timer ]]--
        local pvp = dialog.PvPIndicator
        pvp.text = pvp:CreateFontString(nil, "OVERLAY")
        pvp.text:SetPoint("BOTTOMLEFT", dialog.Health, "TOPLEFT", 15, 2)
        pvp.text:SetFontObject("SystemFont_Shadow_Med1_Outline")
        pvp.text:SetJustifyH("LEFT")
        pvp.text.frequentUpdates = 1
        dialog:Tag(pvp.text, "[realui:pvptimer]")

        --[[ Raid Icon ]]--
        dialog.RaidTargetIndicator = dialog:CreateTexture(nil, "OVERLAY")
        dialog.RaidTargetIndicator:SetSize(20, 20)
        dialog.RaidTargetIndicator:SetPoint("BOTTOMLEFT", dialog, "TOPRIGHT", 10, 4)

        --[[ Class Resource ]]--
        RealUI:GetModule("ClassResource"):Setup(dialog, dialog.unit)
    end,
    health = {
        leftVertex = 1,
        rightVertex = 4,
        point = "RIGHT",
        text = "[realui:health]",
        predict = true,
    },
    power = {
        leftVertex = 2,
        rightVertex = 3,
        point = "RIGHT",
        text = true,
    },
    isBig = true,
    hasCastBars = true,
}

-- Init
_G.tinsert(UnitFrames.units, function(...)
    db = UnitFrames.db.profile

    local player = oUF:Spawn("player", "RealUIPlayerFrame")
    player:SetPoint("RIGHT", "RealUIPositionersUnitFrames", "LEFT", db.positions[UnitFrames.layoutSize].player.x, db.positions[UnitFrames.layoutSize].player.y)
    player:RegisterEvent("PLAYER_FLAGS_CHANGED", player.AwayIndicator.Override)
    player:RegisterEvent("UPDATE_SHAPESHIFT_FORM", player.PostUpdate, true)
end)
