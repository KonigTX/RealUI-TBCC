local _, private = ...

-- RealUI --
local RealUI = private.RealUI
local L = RealUI.L
local MODNAME = "Tooltips"
local Tooltips = RealUI:NewModule(MODNAME, "AceEvent-3.0")

local defaults = {
    profile = {
        anchor = "CURSOR",
        offsetX = 0,
        offsetY = 0,
        showTarget = true,
        classColors = true,
        guildBrackets = true,
    }
}

function Tooltips:OnInitialize()
    self.db = RealUI.db:RegisterNamespace(MODNAME, defaults)
end

function Tooltips:OnEnable()
    self:UpdateTooltipAnchor()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateTooltipAnchor")
end

function Tooltips:UpdateTooltipAnchor()
    if self.db.profile.anchor == "CURSOR" then
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR", self.db.profile.offsetX, self.db.profile.offsetY)
    else
        GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
        GameTooltip:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 4, 250)
    end
end

-- Targeting Information
local function GetUnitColor(unit)
    local color
    if UnitIsPlayer(unit) then
        if not Tooltips.db.profile.classColors then
            return nil
        end
        local _, class = UnitClass(unit)
        color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            color = FACTION_BAR_COLORS[reaction]
        end
    end
    return color
end

local function GetUnitName(unit)
    local name = UnitName(unit)
    -- local server = GetUnitServer(unit) -- This function doesn't exist in TBCC
    -- if server and server ~= "" then
    --     name = name .. "-" .. server
    -- end
    return name
end

local function Tooltip_OnShow(self)
    local _, unit = self:GetUnit()
    if not unit then return end

    if Tooltips.db.profile.classColors or Tooltips.db.profile.guildBrackets then
        local namePrefix = self:GetName()
        if namePrefix then
            if Tooltips.db.profile.classColors and UnitIsPlayer(unit) then
                local _, class = UnitClass(unit)
                local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
                local nameLine = _G[namePrefix .. "TextLeft1"]
                if nameLine and color then
                    nameLine:SetTextColor(color.r, color.g, color.b)
                end
            end
            if Tooltips.db.profile.guildBrackets then
                local guildName = GetGuildInfo(unit)
                local guildLine = _G[namePrefix .. "TextLeft2"]
                if guildName and guildLine and guildLine:GetText() then
                    local r, g, b = guildLine:GetTextColor()
                    guildLine:SetText("<" .. guildName .. ">")
                    guildLine:SetTextColor(r, g, b)
                end
            end
        end
    end

    if not Tooltips.db.profile.showTarget then return end

    C_Timer.After(0, function()
        if not self:IsVisible() then return end
        local unitTarget = unit .. "target"
        if UnitExists(unitTarget) then
            local text
            local r, g, b = 1, 1, 1
            if UnitIsUnit(unitTarget, "player") then
                text = "|cffff0000>> "..YOU.." <<|r"
            else
                text = GetUnitName(unitTarget)
                local color = GetUnitColor(unitTarget)
                if color then
                    r, g, b = color.r, color.g, color.b
                end
            end
            self:AddDoubleLine("Target:", text, 1, 1, 1, r, g, b)
            self:Show()
        end
    end)
end

local function Tooltip_OnTooltipSetUnit(self)
    local _, unit = self:GetUnit()
    if not unit or not UnitIsPlayer(unit) then return end

    local namePrefix = self:GetName()
    if not namePrefix then return end

    if Tooltips.db.profile.classColors then
        local _, class = UnitClass(unit)
        local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
        local nameLine = _G[namePrefix .. "TextLeft1"]
        if nameLine and color then
            nameLine:SetTextColor(color.r, color.g, color.b)
        end
    end

    if Tooltips.db.profile.guildBrackets then
        local guildName = GetGuildInfo(unit)
        local guildLine = _G[namePrefix .. "TextLeft2"]
        if guildName and guildLine and guildLine:GetText() then
            local r, g, b = guildLine:GetTextColor()
            guildLine:SetText("<" .. guildName .. ">")
            guildLine:SetTextColor(r, g, b)
        end
    end
end

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    if Tooltips.db.profile.anchor == "CURSOR" then
        tooltip:SetOwner(parent, "ANCHOR_CURSOR", Tooltips.db.profile.offsetX, Tooltips.db.profile.offsetY)
    else
        -- If you want to use a static position, define it here
        tooltip:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 4, 250)
    end
end)

GameTooltip:HookScript("OnShow", Tooltip_OnShow)
GameTooltip:HookScript("OnTooltipSetUnit", Tooltip_OnTooltipSetUnit)

if _G.Aurora then
    local frameColor = _G.Aurora.Color.frame
    local function OnTooltipCleared(tooltip)
        if tooltip and tooltip.NineSlice then
            tooltip.NineSlice:SetBorderColor(frameColor.r, frameColor.g, frameColor.b)
        end
    end

    GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
    ItemRefTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
end
