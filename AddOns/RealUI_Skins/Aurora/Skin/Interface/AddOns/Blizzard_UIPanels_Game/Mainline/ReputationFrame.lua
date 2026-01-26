local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next type

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ReputationFrame.lua ]]
    function Hook.ReputationFrame_OnShow(self)
        -- The TOPRIGHT anchor for ReputationBar1 is set in C code
        _G.ReputationBar1:SetPoint("TOPRIGHT", -34, -(private.FRAME_TITLE_HEIGHT + 22))
    end
    function Hook.ReputationFrame_SetRowType(factionRow, isChild, isHeader, hasRep)
        if isHeader then
            factionRow:SetBackdrop(false)
        else
            factionRow:SetBackdrop(true)
        end
    end
    function Hook.ReputationFrame_InitReputationRow(factionRow, elementData)
        local _, _, _, _, _, _, atWarWith = _G.GetFactionInfo(elementData.index)

        local bd = factionRow._bdFrame or factionRow
        if atWarWith then
            Base.SetBackdropColor(bd, Color.red)
        else
            Base.SetBackdropColor(bd, Color.button)
        end

        if elementData.index == _G.GetSelectedFaction() then
            if _G.ReputationDetailFrame:IsShown() then
                bd:SetBackdropBorderColor(Color.highlight)
            end
        end
    end

    local hasShown = false
    function Hook.ReputationFrame_Update(self)
        if not hasShown then
            hasShown = true
            _G.ReputationFrame:Hide()
            _G.ReputationFrame:Show()
            return
        end

        for i = 1, _G.NUM_FACTIONS_DISPLAYED do
            local factionRow = _G["ReputationBar"..i]
            if factionRow.index then
                local _, _, _, _, _, _, atWarWith = _G.GetFactionInfo(factionRow.index)

                local bd = factionRow._bdFrame or factionRow
                if atWarWith then
                    Base.SetBackdropColor(bd, Color.red)
                else
                    Base.SetBackdropColor(bd, Color.button)
                end

                if factionRow.index == _G.C_Reputation.GetSelectedFaction() then
                    if _G.ReputationDetailFrame:IsShown() then
                        bd:SetBackdropBorderColor(Color.highlight)
                    end
                end
            end
        end

        Hook.ReputationFrame_OnShow(self)
    end
end

do --[[ FrameXML\ReputationFrame.xml ]]
    local function OnEnter(button)
        (button._bdFrame or button):SetBackdropBorderColor(Color.highlight)
    end
    local function OnLeave(button)
        if (_G.C_Reputation.GetSelectedFaction() ~= button.index) or (not _G.ReputationDetailFrame:IsShown()) then
            local _, _, _, _, _, _, atWarWith = _G.C_Reputation.GetFactionInfo(button.index)
            if atWarWith then
                (button._bdFrame or button):SetBackdropBorderColor(Color.red)
            else
                (button._bdFrame or button):SetBackdropBorderColor(Color.button)
            end
        end
    end

    function Skin.ReputationBarTemplate(Button)
        Skin.FrameTypeButton(Button, OnEnter, OnLeave)
        Button:SetBackdropOption("offsets", {
            left = 30,
            right = 10,
            top = 0,
            bottom = 0,
        })

        local Container = Button.Container
        Container.Background:SetAlpha(0)

        Skin.ExpandOrCollapse(Container.ExpandOrCollapseButton)

        local ReputationBar = Container.ReputationBar
        Skin.FrameTypeStatusBar(ReputationBar)
        ReputationBar:ClearAllPoints()
        ReputationBar:SetPoint("TOPRIGHT", -3, -2)
        ReputationBar:SetPoint("BOTTOMLEFT", Button, "BOTTOMRIGHT", -102, 2)

        ReputationBar.AtWarHighlight2:SetAlpha(0)
        ReputationBar.AtWarHighlight1:SetAlpha(0)

        ReputationBar.LeftTexture:Hide()
        ReputationBar.RightTexture:Hide()

        ReputationBar.Highlight2:SetAlpha(0)
        ReputationBar.Highlight1:SetAlpha(0)
    end
end

function private.FrameXML.ReputationFrame()
    local ReputationFrame = _G.ReputationFrame
    if not ReputationFrame then return end
    ---------------------
    -- ReputationFrame --
    ---------------------

    if ReputationFrame.ScrollBox and Skin.WowScrollBoxList then
        Skin.WowScrollBoxList(ReputationFrame.ScrollBox)
        if _G.CharacterFrame and _G.CharacterFrame.Inset then
            ReputationFrame.ScrollBox:SetPoint("TOPLEFT", _G.CharacterFrame.Inset, 4, -26)
        end
    end

    if ReputationFrame.ScrollBar and Skin.MinimalScrollBar then
        Skin.MinimalScrollBar(ReputationFrame.ScrollBar)
    end

    ---------------------------
    -- ReputationDetailFrame --
    ---------------------------
    local ReputationDetailFrame = ReputationFrame.ReputationDetailFrame
    if ReputationDetailFrame then
        if ReputationDetailFrame.Border then
            Skin.DialogBorderTemplate(ReputationDetailFrame.Border)
        end
        local repDetailBG = ReputationDetailFrame.Border and ReputationDetailFrame.Border.GetBackdropTexture
            and ReputationDetailFrame.Border:GetBackdropTexture("bg") or nil
        -- FIXLATER -- remove backdrop texture
        if ReputationDetailFrame.Title and repDetailBG then
            ReputationDetailFrame.Title:SetPoint("TOPLEFT", repDetailBG, 10, -8)
            ReputationDetailFrame.Title:SetPoint("BOTTOMRIGHT", repDetailBG, "TOPRIGHT", -10, -26)
        end
        if ReputationDetailFrame.ScrollingDescription and ReputationDetailFrame.Title then
            ReputationDetailFrame.ScrollingDescription:SetPoint("TOPLEFT", ReputationDetailFrame.Title, "BOTTOMLEFT", 0, -5)
            ReputationDetailFrame.ScrollingDescription:SetPoint("TOPRIGHT", ReputationDetailFrame.Title, "BOTTOMRIGHT", 0, -5)
        end

        if ReputationDetailFrame.Divider then
            ReputationDetailFrame.Divider:SetColorTexture(Color.frame:GetRGB())
            ReputationDetailFrame.Divider:SetHeight(1)
        end

        if ReputationDetailFrame.CloseButton then
            Skin.UIPanelCloseButton(ReputationDetailFrame.CloseButton)
        end
        if ReputationDetailFrame.MakeInactiveCheckbox then
            Skin.UICheckButtonTemplate(ReputationDetailFrame.MakeInactiveCheckbox)
        end
        if ReputationDetailFrame.AtWarCheckbox then
            Skin.UICheckButtonTemplate(ReputationDetailFrame.AtWarCheckbox)
        end
        if ReputationDetailFrame.WatchFactionCheckbox then
            Skin.UICheckButtonTemplate(ReputationDetailFrame.WatchFactionCheckbox)
        end
        if ReputationDetailFrame.ViewRenownButton then
            Skin.UIPanelButtonTemplate(ReputationDetailFrame.ViewRenownButton)
        end
    end
end
