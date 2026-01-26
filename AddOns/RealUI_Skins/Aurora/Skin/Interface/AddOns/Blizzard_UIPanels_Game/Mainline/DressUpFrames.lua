local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Util = Aurora.Util

function private.FrameXML.DressUpFrames()
    -----------------
    -- SideDressUp --
    -----------------

    --[[ Used with:
        - AuctionUI - classic
        - AuctionHouseUI - retail
    ]]
    local SideDressUpFrame = _G.SideDressUpFrame
    if not SideDressUpFrame then return end
    Skin.FrameTypeFrame(SideDressUpFrame)

    local top, bottom, left, right = SideDressUpFrame:GetRegions()
    if top then top:Hide() end
    if bottom then bottom:Hide() end
    if left then left:Hide() end
    if right then right:Hide() end

    if SideDressUpFrame.ModelScene then
        SideDressUpFrame.ModelScene:SetPoint("TOPLEFT")
        SideDressUpFrame.ModelScene:SetPoint("BOTTOMRIGHT")
    end

    if SideDressUpFrame.ResetButton then
        Skin.UIPanelButtonTemplate(SideDressUpFrame.ResetButton)
    end
    if _G.SideDressUpFrameCloseButton then
        Skin.UIPanelCloseButton(_G.SideDressUpFrameCloseButton)
    end

    ----------------------------------
    -- TransmogAndMountDressupFrame --
    ----------------------------------
    local TransmogAndMountDressupFrame = _G.TransmogAndMountDressupFrame
    if TransmogAndMountDressupFrame and TransmogAndMountDressupFrame.ShowMountCheckButton then
        Skin.UICheckButtonTemplate(TransmogAndMountDressupFrame.ShowMountCheckButton)
        TransmogAndMountDressupFrame.ShowMountCheckButton:ClearAllPoints()
        TransmogAndMountDressupFrame.ShowMountCheckButton:SetPoint("BOTTOMRIGHT", -5, 5)
    end

    ------------------
    -- DressUpFrame --
    ------------------
    local DressUpFrame = _G.DressUpFrame
    if not DressUpFrame then return end

    Skin.ButtonFrameTemplateMinimizable(DressUpFrame)
    if DressUpFrame.OutfitDropdown then
        Skin.DropdownButton(DressUpFrame.OutfitDropdown)
    end
    if DressUpFrame.MaxMinButtonFrame then
        Skin.MaximizeMinimizeButtonFrameTemplate(DressUpFrame.MaxMinButtonFrame)
    end
    if _G.DressUpFrameCancelButton then
        Skin.UIPanelButtonTemplate(_G.DressUpFrameCancelButton)
    end

    local ModelScene = DressUpFrame.ModelScene
    if ModelScene then
        ModelScene:SetPoint("TOPLEFT", 0, -private.FRAME_TITLE_HEIGHT)
        ModelScene:SetPoint("BOTTOMRIGHT")
    end

    local detailsButton = DressUpFrame.ToggleOutfitDetailsButton
    if detailsButton then
        Base.CropIcon(detailsButton:GetNormalTexture())
        Base.CropIcon(detailsButton:GetPushedTexture())
    end

    local settings = private.CLASS_BACKGROUND_SETTINGS[private.charClass.token] or private.CLASS_BACKGROUND_SETTINGS["DEFAULT"];
    local OutfitDetailsPanel = DressUpFrame.OutfitDetailsPanel
    if OutfitDetailsPanel then
        local blackBG, classBG, frameBG = OutfitDetailsPanel:GetRegions()
        if blackBG then
            blackBG:SetPoint("TOPLEFT", 10, -19)
        end
        if classBG and blackBG then
            classBG:SetPoint("TOPLEFT", blackBG, 1, -1)
            classBG:SetPoint("BOTTOMRIGHT", blackBG, -1, 1)
        end
        if classBG then
            classBG:SetDesaturation(settings.desaturation)
            classBG:SetAlpha(settings.alpha)
        end
        if frameBG then
            frameBG:Hide()
        end
    end

    if DressUpFrame.ResetButton then
        Skin.UIPanelButtonTemplate(DressUpFrame.ResetButton)
        if _G.DressUpFrameCancelButton then
            Util.PositionRelative("BOTTOMRIGHT", DressUpFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
                _G.DressUpFrameCancelButton,
                DressUpFrame.ResetButton,
            })
        end
    end

    if DressUpFrame.LinkButton then
        Skin.UIPanelButtonTemplate(DressUpFrame.LinkButton)
        DressUpFrame.LinkButton:SetPoint("BOTTOMLEFT", 15, 15)
    end

    if DressUpFrame.ModelBackground then
        DressUpFrame.ModelBackground:SetDrawLayer("BACKGROUND", 3)
        DressUpFrame.ModelBackground:SetDesaturation(settings.desaturation)
        DressUpFrame.ModelBackground:SetAlpha(settings.alpha)
    end

    -- Raise the frame level of interactable child frames above the model frame.
    if ModelScene then
        local newFrameLevel = ModelScene:GetFrameLevel() + 1
        if DressUpFrame.OutfitDropdown then
            DressUpFrame.OutfitDropdown:SetFrameLevel(newFrameLevel)
        end
        if DressUpFrame.MaximizeMinimizeFrame then
            DressUpFrame.MaximizeMinimizeFrame:SetFrameLevel(newFrameLevel)
        end
        if _G.DressUpFrameCancelButton then
            _G.DressUpFrameCancelButton:SetFrameLevel(newFrameLevel)
        end
        if DressUpFrame.ToggleOutfitDetailsButton then
            DressUpFrame.ToggleOutfitDetailsButton:SetFrameLevel(newFrameLevel)
        end
        if DressUpFrame.ResetButton then
            DressUpFrame.ResetButton:SetFrameLevel(newFrameLevel)
        end
        if DressUpFrame.LinkButton then
            DressUpFrame.LinkButton:SetFrameLevel(newFrameLevel)
        end
    end
end
