local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select hooksecurefunc

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

-- Helper to hide all textures in a frame
local function StripTextures(frame)
    if not frame then return end
    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if region and region:IsObjectType("Texture") then
            region:SetTexture("")
            region:SetAlpha(0)
            region:Hide()
        end
    end
end

-- Helper to hide a frame/texture by name or property
local function HideElement(parent, name)
    local element = parent[name] or _G[name]
    if element then
        if element.SetTexture then
            element:SetTexture("")
        end
        if element.SetAlpha then
            element:SetAlpha(0)
        end
        if element.Hide then
            element:Hide()
        end
    end
end

-- Hook function for item quality display
local function InspectPaperDollItemSlotButton_Update(button)
    if not button then return end
    local unit = _G.InspectFrame and _G.InspectFrame.unit
    if not unit then return end

    local slotID = button:GetID()
    if slotID then
        local quality = _G.GetInventoryItemQuality(unit, slotID)
        local itemID = _G.GetInventoryItemID(unit, slotID)

        -- Use Aurora's hook for item quality if available
        if Hook and Hook.SetItemButtonQuality then
            Hook.SetItemButtonQuality(button, quality, itemID)
        elseif quality and quality > 1 then
            -- Fallback: manually set border color based on quality
            local color = _G.BAG_ITEM_QUALITY_COLORS and _G.BAG_ITEM_QUALITY_COLORS[quality]
            if color and button._auroraIconBorder then
                button._auroraIconBorder:SetBackdropBorderColor(color.r, color.g, color.b)
            elseif color and button.IconBorder then
                button.IconBorder:SetVertexColor(color.r, color.g, color.b)
                button.IconBorder:Show()
            end
        else
            -- No quality or poor quality - hide border
            if button._auroraIconBorder then
                button._auroraIconBorder:SetBackdropBorderColor(Color.frame:GetRGB())
            elseif button.IconBorder then
                button.IconBorder:Hide()
            end
        end
    end
end

-- InspectFrame is created by Blizzard_InspectUI (load-on-demand)
-- Register as AddOn skin instead of FrameXML
private.AddOns["Blizzard_InspectUI"] = function()
    local InspectFrame = _G.InspectFrame
    if not InspectFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if InspectFrame.NineSlice then
        StripTextures(InspectFrame.NineSlice)
        InspectFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(InspectFrame, "portrait")
    HideElement(InspectFrame, "PortraitFrame")
    HideElement(InspectFrame, "PortraitContainer")
    HideElement(_G, "InspectFramePortrait")
    HideElement(_G, "InspectFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(InspectFrame, "TopEdge")
    HideElement(InspectFrame, "BottomEdge")
    HideElement(InspectFrame, "LeftEdge")
    HideElement(InspectFrame, "RightEdge")
    HideElement(InspectFrame, "TopLeftCorner")
    HideElement(InspectFrame, "TopRightCorner")
    HideElement(InspectFrame, "BottomLeftCorner")
    HideElement(InspectFrame, "BottomRightCorner")
    HideElement(InspectFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "InspectFrameTopLeftCorner")
    HideElement(_G, "InspectFrameTopRightCorner")
    HideElement(_G, "InspectFrameBottomLeftCorner")
    HideElement(_G, "InspectFrameBottomRightCorner")
    HideElement(_G, "InspectFrameTopBorder")
    HideElement(_G, "InspectFrameBottomBorder")
    HideElement(_G, "InspectFrameLeftBorder")
    HideElement(_G, "InspectFrameRightBorder")

    -- Hide Bg and TitleBg
    HideElement(InspectFrame, "Bg")
    HideElement(InspectFrame, "TitleBg")
    HideElement(_G, "InspectFrameBg")
    HideElement(_G, "InspectFrameTitleBg")

    -- Hide inset
    local InspectFrameInset = InspectFrame.Inset or _G.InspectFrameInset
    if InspectFrameInset then
        StripTextures(InspectFrameInset)
        if InspectFrameInset.NineSlice then
            StripTextures(InspectFrameInset.NineSlice)
            InspectFrameInset.NineSlice:Hide()
        end
        HideElement(InspectFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(InspectFrame)

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(InspectFrame, Color.frame)

    -- Skin close button with TBC-compatible X
    local closeButton = InspectFrame.CloseButton or _G.InspectFrameCloseButton
    if closeButton then
        if Skin.UIPanelCloseButton then
            Skin.UIPanelCloseButton(closeButton)
        else
            Skin.FrameTypeButton(closeButton)
        end
        -- Reposition close button to top-right corner
        closeButton:ClearAllPoints()
        closeButton:SetPoint("TOPRIGHT", InspectFrame, "TOPRIGHT", -5, -5)
    end

    -- Skin tabs (Character, Honor, Talents)
    for i = 1, 3 do
        local tab = _G["InspectFrameTab"..i]
        if tab then
            StripTextures(tab)
            Skin.FrameTypeButton(tab)
        end
    end

    -- Position tabs explicitly to prevent overlap
    local tab1 = _G.InspectFrameTab1
    local tab2 = _G.InspectFrameTab2
    local tab3 = _G.InspectFrameTab3

    if tab1 then
        tab1:ClearAllPoints()
        tab1:SetPoint("BOTTOMLEFT", InspectFrame, "BOTTOMLEFT", 5, -30)
    end

    if tab2 and tab1 then
        tab2:ClearAllPoints()
        tab2:SetPoint("LEFT", tab1, "RIGHT", 4, 0)
    end

    if tab3 and tab2 then
        tab3:ClearAllPoints()
        tab3:SetPoint("LEFT", tab2, "RIGHT", 4, 0)
    end

    -- Skin equipment slots
    local slotNames = {
        "Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard",
        "Wrist", "Hands", "Waist", "Legs", "Feet",
        "Finger0", "Finger1", "Trinket0", "Trinket1",
        "MainHand", "SecondaryHand", "Ranged"
    }

    for _, slotName in ipairs(slotNames) do
        local slot = _G["Inspect"..slotName.."Slot"]
        if slot then
            -- Hide slot background/frame textures
            local slotFrame = _G["Inspect"..slotName.."SlotFrame"]
            if slotFrame then
                slotFrame:SetAlpha(0)
                slotFrame:Hide()
            end

            -- Hide the slot's normal texture (the empty slot graphic)
            local normalTex = slot:GetNormalTexture()
            if normalTex then
                normalTex:SetTexture("")
                normalTex:SetAlpha(0)
            end

            -- Hide pushed/highlight textures
            local pushedTex = slot:GetPushedTexture()
            if pushedTex then
                pushedTex:SetTexture("")
            end

            local highlightTex = slot:GetHighlightTexture()
            if highlightTex then
                highlightTex:SetTexture("")
            end

            -- Apply Aurora button skin
            Skin.FrameTypeButton(slot)

            -- Crop icon properly
            if slot.icon then
                slot.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            end

            -- Also try to hide by global name pattern
            HideElement(_G, "Inspect"..slotName.."SlotFrame")
            HideElement(_G, "Inspect"..slotName.."SlotNormalTexture")
        end
    end

    -- Hide model frame background
    local InspectModelFrame = _G.InspectModelFrame
    if InspectModelFrame then
        StripTextures(InspectModelFrame)

        -- Hide individual background textures by global name (TBCC structure)
        HideElement(_G, "InspectModelFrameBackgroundTopLeft")
        HideElement(_G, "InspectModelFrameBackgroundTopRight")
        HideElement(_G, "InspectModelFrameBackgroundBotLeft")
        HideElement(_G, "InspectModelFrameBackgroundBotRight")
        HideElement(_G, "InspectModelFrameBackgroundTop")
        HideElement(_G, "InspectModelFrameBackgroundBot")
        HideElement(_G, "InspectModelFrameBackgroundLeft")
        HideElement(_G, "InspectModelFrameBackgroundRight")

        -- Disable background draw layer
        if InspectModelFrame.DisableDrawLayer then
            InspectModelFrame:DisableDrawLayer("BACKGROUND")
        end

        -- Hide BackgroundOverlay if exists
        if InspectModelFrame.BackgroundOverlay then
            InspectModelFrame.BackgroundOverlay:Hide()
        end
    end

    -- Hide InspectPaperDollFrame background elements
    local InspectPaperDollFrame = _G.InspectPaperDollFrame
    if InspectPaperDollFrame then
        StripTextures(InspectPaperDollFrame)

        -- Try to disable background layer
        if InspectPaperDollFrame.DisableDrawLayer then
            InspectPaperDollFrame:DisableDrawLayer("BACKGROUND")
        end
    end

    -- Hide any remaining vanilla inspect textures
    HideElement(_G, "InspectPaperDollFramePortrait")
    HideElement(_G, "InspectHeadSlotBackground")
    HideElement(_G, "InspectHandsSlotBackground")
    HideElement(_G, "InspectMainHandSlotBackground")
    HideElement(_G, "InspectSecondaryHandSlotBackground")

    -- Hook item slot updates for quality borders
    if _G.InspectPaperDollItemSlotButton_Update then
        hooksecurefunc("InspectPaperDollItemSlotButton_Update", InspectPaperDollItemSlotButton_Update)
    end

    -- Also update slots when the frame shows
    local InspectPaperDollFrame = _G.InspectPaperDollFrame
    if InspectPaperDollFrame then
        InspectPaperDollFrame:HookScript("OnShow", function()
            for _, slotName in ipairs(slotNames) do
                local slot = _G["Inspect"..slotName.."Slot"]
                if slot then
                    InspectPaperDollItemSlotButton_Update(slot)
                end
            end
        end)
    end

    -- Recolor InspectFrame text for readability (black text on dark bg fix)
    local function RecolorInspectText()
        -- Title text
        local titleText = _G.InspectFrameTitleText or InspectFrame.TitleText
        if titleText and titleText.SetTextColor then
            titleText:SetTextColor(1, 1, 1)
        end

        -- Stat labels (Strength, Agility, etc.) in PaperDollFrame
        local statLabels = {
            "InspectStatFrameLabel1", "InspectStatFrameLabel2", "InspectStatFrameLabel3",
            "InspectStatFrameLabel4", "InspectStatFrameLabel5"
        }
        for _, labelName in ipairs(statLabels) do
            local label = _G[labelName]
            if label and label.SetTextColor then
                label:SetTextColor(1, 1, 1)
            end
        end

        -- All FontStrings in InspectPaperDollFrame
        if InspectPaperDollFrame then
            for i = 1, InspectPaperDollFrame:GetNumRegions() do
                local region = select(i, InspectPaperDollFrame:GetRegions())
                if region and region:IsObjectType("FontString") then
                    local r, g, b = region:GetTextColor()
                    -- If text is too dark (black text), make it white
                    if r < 0.5 and g < 0.5 and b < 0.5 then
                        region:SetTextColor(1, 1, 1)
                    end
                end
            end
        end
    end

    -- Delayed recolor to run AFTER Blizzard's OnShow logic (same pattern as MerchantFrame)
    local function DelayedRecolorInspectText()
        C_Timer.After(0, RecolorInspectText)
    end

    -- Hook OnShow to reapply colors after Blizzard updates
    InspectFrame:HookScript("OnShow", DelayedRecolorInspectText)
end
