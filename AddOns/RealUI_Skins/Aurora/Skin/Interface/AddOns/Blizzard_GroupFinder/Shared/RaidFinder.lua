local _, private = ...
if private.shouldSkip() then return end

-- [[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\RaidFinder.lua ]]
    function Hook.RaidFinderQueueFrameCooldownFrame_Update()
        local numPlayers, prefix
        if _G.IsInRaid() then
            numPlayers = _G.GetNumGroupMembers()
            prefix = "raid"
        else
            numPlayers = _G.GetNumSubgroupMembers()
            prefix = "party"
        end

        local cooldowns = 0
        for i = 1, numPlayers do
            local unit = prefix .. i
            if _G.UnitHasLFGDeserter(unit) and not _G.UnitIsUnit(unit, "player") then
                cooldowns = cooldowns + 1
                if cooldowns <= _G.MAX_RAID_FINDER_COOLDOWN_NAMES then
                    local _, classToken = _G.UnitClass(unit)
                    local classColor = classToken and _G.CUSTOM_CLASS_COLORS[classToken]
                    if classColor then
                        _G["RaidFinderQueueFrameCooldownFrameName" .. cooldowns]:SetFormattedText("|c%s%s|r", classColor.colorStr, _G.UnitName(unit))
                    end
                end
            end
        end
    end
end

do --[[ FrameXML\RaidFinder.xml ]]
    function Skin.RaidFinderRoleButtonTemplate(Button)
        Skin.LFGRoleButtonWithBackgroundAndRewardTemplate(Button)
    end
end

function private.FrameXML.RaidFinder()
    if _G.RaidFinderQueueFrameCooldownFrame_Update then
        _G.hooksecurefunc("RaidFinderQueueFrameCooldownFrame_Update", Hook.RaidFinderQueueFrameCooldownFrame_Update)
    end

    local RaidFinderFrame = _G.RaidFinderFrame
    if not RaidFinderFrame then return end
    if _G.RaidFinderFrameRoleBackground then _G.RaidFinderFrameRoleBackground:Hide() end

    if RaidFinderFrame.NoRaidsCover then
        RaidFinderFrame.NoRaidsCover:SetPoint("TOPRIGHT", 0, -25)
        RaidFinderFrame.NoRaidsCover:SetPoint("BOTTOMLEFT", 0, 0)
    end

    if _G.RaidFinderFrameRoleInset then Skin.InsetFrameTemplate(_G.RaidFinderFrameRoleInset) end
    if _G.RaidFinderFrameBottomInset then Skin.InsetFrameTemplate(_G.RaidFinderFrameBottomInset) end

    --------------------------
    -- RaidFinderQueueFrame --
    --------------------------
    if _G.RaidFinderQueueFrameBackground then _G.RaidFinderQueueFrameBackground:Hide() end

    if _G.RaidFinderQueueFrameRoleButtonTank then Skin.RaidFinderRoleButtonTemplate(_G.RaidFinderQueueFrameRoleButtonTank) end
    if _G.RaidFinderQueueFrameRoleButtonHealer then Skin.RaidFinderRoleButtonTemplate(_G.RaidFinderQueueFrameRoleButtonHealer) end
    if _G.RaidFinderQueueFrameRoleButtonDPS then Skin.RaidFinderRoleButtonTemplate(_G.RaidFinderQueueFrameRoleButtonDPS) end
    if _G.RaidFinderQueueFrameRoleButtonLeader then Skin.LFGRoleButtonTemplate(_G.RaidFinderQueueFrameRoleButtonLeader) end
    if _G.RaidFinderQueueFrameSelectionDropdown then Skin.DropdownButton(_G.RaidFinderQueueFrameSelectionDropdown) end

    if _G.RaidFinderQueueFrameScrollFrame then Skin.ScrollFrameTemplate(_G.RaidFinderQueueFrameScrollFrame) end
    if _G.RaidFinderQueueFrameScrollFrameChildFrame then Skin.LFGRewardFrameTemplate(_G.RaidFinderQueueFrameScrollFrameChildFrame) end

    if _G.RaidFinderQueueFramePartyBackfill then Skin.LFGBackfillCoverTemplate(_G.RaidFinderQueueFramePartyBackfill) end
    if _G.RaidFinderQueueFrame and _G.RaidFinderQueueFrame.CooldownFrame then
        Skin.LFGCooldownCoverTemplate(_G.RaidFinderQueueFrame.CooldownFrame)
    end
    if _G.RaidFinderQueueFrameIneligibleFrame and _G.RaidFinderQueueFrameIneligibleFrame.leaveQueueButton then
        Skin.UIPanelButtonTemplate(_G.RaidFinderQueueFrameIneligibleFrame.leaveQueueButton)
    end

    if _G.RaidFinderFrameFindRaidButton then Skin.MagicButtonTemplate(_G.RaidFinderFrameFindRaidButton) end
end
