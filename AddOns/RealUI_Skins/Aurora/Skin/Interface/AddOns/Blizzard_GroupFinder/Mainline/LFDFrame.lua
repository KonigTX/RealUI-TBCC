local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\LFDFrame.lua ]]
    function Hook.LFDQueueFrameRandomCooldownFrame_Update()
        for i = 1, _G.GetNumSubgroupMembers() do
            local nameLabel = _G["LFDQueueFrameCooldownFrameName"..i]

            local _, classFilename = _G.UnitClass("party"..i)
            local classColor = classFilename and _G.CUSTOM_CLASS_COLORS[classFilename] or _G.NORMAL_FONT_COLOR
            nameLabel:SetFormattedText("|cff%.2x%.2x%.2x%s|r", classColor.r * 255, classColor.g * 255, classColor.b * 255, _G.GetUnitName("party"..i, true))
        end
    end
end

do --[[ FrameXML\LFDFrame.xml ]]
    function Skin.LFDRoleButtonTemplate(Button)
        Skin.LFGRoleButtonWithBackgroundAndRewardTemplate(Button)
    end
    function Skin.LFDRoleCheckPopupButtonTemplate(Button)
        Skin.LFGRoleButtonTemplate(Button)
    end
    function Skin.LFDFrameDungeonChoiceTemplate(Button)
        Skin.LFGSpecificChoiceTemplate(Button)
    end
end

function private.FrameXML.LFDFrame()
    if _G.LFDQueueFrameRandomCooldownFrame_Update then
        _G.hooksecurefunc("LFDQueueFrameRandomCooldownFrame_Update", Hook.LFDQueueFrameRandomCooldownFrame_Update)
    end

    -----------------------
    -- LFDRoleCheckPopup --
    -----------------------
    local LFDRoleCheckPopup = _G.LFDRoleCheckPopup
    if not LFDRoleCheckPopup then return end
    if LFDRoleCheckPopup.Border then
        Skin.DialogBorderTemplate(LFDRoleCheckPopup.Border)
    end

    if _G.LFDRoleCheckPopupRoleButtonTank then
        _G.LFDRoleCheckPopupRoleButtonTank:SetPoint("LEFT", 33, 0)
        Skin.LFDRoleCheckPopupButtonTemplate(_G.LFDRoleCheckPopupRoleButtonTank)
    end
    if _G.LFDRoleCheckPopupRoleButtonHealer then
        Skin.LFDRoleCheckPopupButtonTemplate(_G.LFDRoleCheckPopupRoleButtonHealer)
    end
    if _G.LFDRoleCheckPopupRoleButtonDPS then
        Skin.LFDRoleCheckPopupButtonTemplate(_G.LFDRoleCheckPopupRoleButtonDPS)
    end

    if _G.LFDRoleCheckPopupAcceptButton then
        Skin.UIPanelButtonTemplate(_G.LFDRoleCheckPopupAcceptButton)
    end
    if _G.LFDRoleCheckPopupDeclineButton then
        Skin.UIPanelButtonTemplate(_G.LFDRoleCheckPopupDeclineButton)
    end
    if _G.LFDRoleCheckPopupAcceptButton and _G.LFDRoleCheckPopupDeclineButton then
        Util.PositionRelative("BOTTOMLEFT", LFDRoleCheckPopup, "BOTTOMLEFT", 36, 15, 5, "Right", {
            _G.LFDRoleCheckPopupAcceptButton,
            _G.LFDRoleCheckPopupDeclineButton,
        })
    end


    ------------------------
    -- LFDReadyCheckPopup --
    ------------------------
    local LFDReadyCheckPopup = _G.LFDReadyCheckPopup
    if LFDReadyCheckPopup then
        if LFDReadyCheckPopup.Border then
            Skin.DialogBorderTemplate(LFDReadyCheckPopup.Border)
        end
        if LFDReadyCheckPopup.YesButton then
            Skin.UIPanelButtonTemplate(LFDReadyCheckPopup.YesButton)
        end
        if LFDReadyCheckPopup.NoButton then
            Skin.UIPanelButtonTemplate(LFDReadyCheckPopup.NoButton)
        end
        if LFDReadyCheckPopup.YesButton and LFDReadyCheckPopup.NoButton then
            Util.PositionRelative("BOTTOMLEFT", LFDReadyCheckPopup, "BOTTOMLEFT", 32, 15, 5, "Right", {
                LFDReadyCheckPopup.YesButton,
                LFDReadyCheckPopup.NoButton,
            })
        end
    end


    --------------------
    -- LFDParentFrame --
    --------------------
    local LFDParentFrame = _G.LFDParentFrame
    if LFDParentFrame then
        if _G.LFDParentFrameRoleBackground then _G.LFDParentFrameRoleBackground:Hide() end
        if LFDParentFrame.TopTileStreaks then LFDParentFrame.TopTileStreaks:Hide() end
        if LFDParentFrame.Inset then Skin.InsetFrameTemplate(LFDParentFrame.Inset) end
    end

    -- LFDQueueFrame --
    local LFDQueueFrame = _G.LFDQueueFrame
    if _G.LFDQueueFrameBackground then _G.LFDQueueFrameBackground:Hide() end

    if _G.LFDQueueFrameRoleButtonTank then Skin.LFDRoleButtonTemplate(_G.LFDQueueFrameRoleButtonTank) end
    if _G.LFDQueueFrameRoleButtonHealer then Skin.LFDRoleButtonTemplate(_G.LFDQueueFrameRoleButtonHealer) end
    if _G.LFDQueueFrameRoleButtonDPS then Skin.LFDRoleButtonTemplate(_G.LFDQueueFrameRoleButtonDPS) end
    if _G.LFDQueueFrameRoleButtonLeader then Skin.LFGRoleButtonTemplate(_G.LFDQueueFrameRoleButtonLeader) end
    if _G.LFDQueueFrameTypeDropdown then Skin.DropdownButton(_G.LFDQueueFrameTypeDropdown) end
    if _G.LFDQueueFrameRandomScrollFrame then Skin.ScrollFrameTemplate(_G.LFDQueueFrameRandomScrollFrame) end
    if _G.LFDQueueFrameRandomScrollFrameChildFrame then Skin.LFGRewardFrameTemplate(_G.LFDQueueFrameRandomScrollFrameChildFrame) end

    if LFDQueueFrame and LFDQueueFrame.Specific then
        if LFDQueueFrame.Specific.ScrollBox then
            Skin.WowScrollBoxList(LFDQueueFrame.Specific.ScrollBox)
        end
        if LFDQueueFrame.Specific.ScrollBar then
            Skin.MinimalScrollBar(LFDQueueFrame.Specific.ScrollBar)
        end
    end

    if _G.LFDQueueFrameFindGroupButton then Skin.MagicButtonTemplate(_G.LFDQueueFrameFindGroupButton) end
    if LFDQueueFrame and LFDQueueFrame.PartyBackfill then Skin.LFGBackfillCoverTemplate(LFDQueueFrame.PartyBackfill) end
    if LFDQueueFrame and LFDQueueFrame.CooldownFrame then Skin.LFGCooldownCoverTemplate(LFDQueueFrame.CooldownFrame) end
end
