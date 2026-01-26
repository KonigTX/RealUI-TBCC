local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
-- local Util = Aurora.Util

do --[[ AddOns\Blizzard_CompactRaidFrames.lua ]]
    do --[[ Blizzard_CompactRaidFrameManager ]]
        function Hook.CompactRaidFrameManager_Toggle(self)
            if self.collapsed then
                Base.SetTexture(self.toggleButton:GetNormalTexture(), "arrowRight")
            else
                Base.SetTexture(self.toggleButton:GetNormalTexture(), "arrowLeft")
            end
         end
    end
end

do --[[ AddOns\Blizzard_CompactRaidFrames.xml ]]
    function Skin.CRFManagerFilterButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 2,
            right = 2,
            top = 2,
            bottom = 2,
        })
        if  Button.Background then
            Button.Background:Hide()
        end
        Button.TopEdge:Hide()
        Button.TopLeftCorner:Hide()
        Button.TopRightCorner:Hide()
        Button.BottomEdge:Hide()
        Button.BottomLeftCorner:Hide()
        Button.BottomRightCorner:Hide()
        Button.LeftEdge:Hide()
        Button.RightEdge:Hide()
        if Button.Text then
            local bg = Button:GetBackdropTexture("bg")
            Button.Text:SetPoint("CENTER", bg, 0, 0)
            if Button.selectedHighlight then
                Button.selectedHighlight:SetColorTexture(1, 1, 0, 0.3)
                Button.selectedHighlight:SetPoint("TOPLEFT", bg, 1, -1)
                Button.selectedHighlight:SetPoint("BOTTOMRIGHT", bg, -1, 1)
            end
        end
    end
    Skin.CRFManagerFilterRoleButtonTemplate = Skin.CRFManagerFilterButtonTemplate
    Skin.CRFManagerFilterGroupButtonTemplate = Skin.CRFManagerFilterButtonTemplate
    Skin.CRFManagerTooltipTemplate = Skin.CRFManagerFilterButtonTemplate

    function Skin.CRFManagerRaidIconButtonTemplate(Button)
        Button:SetSize(24, 24)
        Button:SetPoint(Button:GetPoint())
        Button:GetNormalTexture()
        Button:SetSize(24, 24)
    end
end

function private.AddOns.Blizzard_CompactRaidFrames()
    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameReservationManager --
    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----

    ----====####$$$$%%%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameContainer --
    ----====####$$$$%%%%%%%%$$$$####====----

    ----====####$$$$%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameManager --
    ----====####$$$$%%%%%%$$$$####====----
    if type(_G.hooksecurefunc) == "function" and type(_G.CompactRaidFrameManager_Toggle) == "function" then
        _G.hooksecurefunc("CompactRaidFrameManager_Toggle", Hook.CompactRaidFrameManager_Toggle)
    end

    local CompactRaidFrameManager = _G.CompactRaidFrameManager
    if not CompactRaidFrameManager then return end
    CompactRaidFrameManager:DisableDrawLayer("ARTWORK")
    Skin.FrameTypeFrame(CompactRaidFrameManager)

    local toggleButtonForward = CompactRaidFrameManager.toggleButtonForward
    if toggleButtonForward then
        toggleButtonForward:SetPoint("RIGHT", -1, 0)
        toggleButtonForward:SetScript("OnMouseDown", private.nop)
        toggleButtonForward:SetScript("OnMouseUp", private.nop)

        local arrowForward = toggleButtonForward:GetNormalTexture()
        if arrowForward then
            arrowForward:ClearAllPoints()
            arrowForward:SetPoint("TOPLEFT", 3, -5)
            arrowForward:SetPoint("BOTTOMRIGHT", -3, 5)
            Base.SetTexture(arrowForward, "arrowRight")
        end
    end


    local toggleButtonBack = CompactRaidFrameManager.toggleButtonBack
    if toggleButtonBack then
        toggleButtonBack:SetPoint("RIGHT", -1, 0)
        toggleButtonBack:SetScript("OnMouseDown", private.nop)
        toggleButtonBack:SetScript("OnMouseUp", private.nop)

        local arrowBack = toggleButtonBack:GetNormalTexture()
        if arrowBack then
            arrowBack:ClearAllPoints()
            arrowBack:SetPoint("TOPLEFT", 3, -5)
            arrowBack:SetPoint("BOTTOMRIGHT", -3, 5)
            Base.SetTexture(arrowBack, "arrowLeft")
        end
    end

    local displayFrame = CompactRaidFrameManager.displayFrame
    if not displayFrame then return end
    local displayFrameName = displayFrame:GetName()
    displayFrame:GetRegions():Hide()
    if displayFrameName then
        local optionsButton = _G[displayFrameName.."OptionsButton"]
        if optionsButton then
            Skin.UIPanelInfoButton(optionsButton)
        end
    end

    local filterOptions = displayFrame.filterOptions
    if filterOptions then
        if filterOptions["filterRoleTank"] then
            Skin.CRFManagerFilterRoleButtonTemplate(filterOptions["filterRoleTank"])
        end
        if filterOptions.filterRoleHealer then
            Skin.CRFManagerFilterRoleButtonTemplate(filterOptions.filterRoleHealer)
        end
        if filterOptions.filterRoleDamager then
            Skin.CRFManagerFilterRoleButtonTemplate(filterOptions.filterRoleDamager)
        end
        for i = 1, 8 do
            local groupButton = filterOptions["filterGroup"..i]
            if groupButton then
                Skin.CRFManagerFilterRoleButtonTemplate(groupButton)
            end
        end
    end

    if displayFrame.editMode then
        Skin.CRFManagerTooltipTemplate(displayFrame.editMode)
    end
    if displayFrame.hiddenModeToggle then
        Skin.CRFManagerTooltipTemplate(displayFrame.hiddenModeToggle)
    end
    -- FIXMELATER
    -- Skin.CRFManagerTooltipTemplate(displayFrame.convertToGroup)
    -- Skin.CRFManagerTooltipTemplate(displayFrame.convertToRaid)

    local icons = {displayFrame.raidMarkers:GetChildren()}
    for i, icon in next, icons do
        Skin.CRFManagerRaidIconButtonTemplate(icon)
    end

    if displayFrame.rolePollButton then
        Skin.CRFManagerTooltipTemplate(displayFrame.rolePollButton)
    end
    if displayFrame.readyCheckButton then
        Skin.CRFManagerTooltipTemplate(displayFrame.readyCheckButton)
    end
    if displayFrame.countdownButton then
        Skin.CRFManagerTooltipTemplate(displayFrame.countdownButton)
    end
    if displayFrame.difficulty then
        Skin.CRFManagerTooltipTemplate(displayFrame.difficulty)
    end
    if displayFrame.everyoneIsAssistButton then
        Skin.UICheckButtonTemplate(displayFrame.everyoneIsAssistButton)
    end

end
