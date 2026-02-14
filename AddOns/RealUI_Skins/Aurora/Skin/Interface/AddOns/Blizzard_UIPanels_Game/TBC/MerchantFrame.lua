local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select hooksecurefunc

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
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

function private.FrameXML.MerchantFrame()
    local MerchantFrame = _G.MerchantFrame
    if not MerchantFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if MerchantFrame.NineSlice then
        StripTextures(MerchantFrame.NineSlice)
        MerchantFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(MerchantFrame, "portrait")
    HideElement(MerchantFrame, "PortraitFrame")
    HideElement(MerchantFrame, "PortraitContainer")
    HideElement(_G, "MerchantFramePortrait")
    HideElement(_G, "MerchantFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(MerchantFrame, "TopEdge")
    HideElement(MerchantFrame, "BottomEdge")
    HideElement(MerchantFrame, "LeftEdge")
    HideElement(MerchantFrame, "RightEdge")
    HideElement(MerchantFrame, "TopLeftCorner")
    HideElement(MerchantFrame, "TopRightCorner")
    HideElement(MerchantFrame, "BottomLeftCorner")
    HideElement(MerchantFrame, "BottomRightCorner")
    HideElement(MerchantFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "MerchantFrameTopLeftCorner")
    HideElement(_G, "MerchantFrameTopRightCorner")
    HideElement(_G, "MerchantFrameBottomLeftCorner")
    HideElement(_G, "MerchantFrameBottomRightCorner")
    HideElement(_G, "MerchantFrameTopBorder")
    HideElement(_G, "MerchantFrameBottomBorder")
    HideElement(_G, "MerchantFrameLeftBorder")
    HideElement(_G, "MerchantFrameRightBorder")

    -- Hide Bg and TitleBg
    HideElement(MerchantFrame, "Bg")
    HideElement(MerchantFrame, "TitleBg")
    HideElement(_G, "MerchantFrameBg")
    HideElement(_G, "MerchantFrameTitleBg")

    -- Hide inset
    local MerchantFrameInset = MerchantFrame.Inset or _G.MerchantFrameInset
    if MerchantFrameInset then
        StripTextures(MerchantFrameInset)
        if MerchantFrameInset.NineSlice then
            StripTextures(MerchantFrameInset.NineSlice)
            MerchantFrameInset.NineSlice:Hide()
        end
        HideElement(MerchantFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(MerchantFrame)

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(MerchantFrame, Color.frame)

    -- Skin close button
    local closeButton = MerchantFrame.CloseButton or _G.MerchantFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin tabs if present
    for i = 1, 2 do
        local tab = _G["MerchantFrameTab"..i]
        if tab then
            StripTextures(tab)
            Skin.FrameTypeButton(tab)
        end
    end

    -- Skin repair button
    local MerchantRepairAllButton = _G.MerchantRepairAllButton
    if MerchantRepairAllButton then
        Skin.FrameTypeButton(MerchantRepairAllButton)
    end

    -- Skin buyback button
    local MerchantBuyBackButton = _G.MerchantBuyBackButton
    if MerchantBuyBackButton then
        Skin.FrameTypeButton(MerchantBuyBackButton)
    end

    -- Skin scroll frame
    local MerchantFrameScrollFrame = _G.MerchantFrameScrollFrame
    if MerchantFrameScrollFrame then
        Base.SetBackdrop(MerchantFrameScrollFrame, Color.frame, 0.3)
    end

    -- Recolor TBC MerchantFrame FontStrings for readability
    -- NOTE: Item names keep their rarity colors, only money/UI text is white
    local function RecolorMerchantText()
        -- Recolor the frame title
        local titleText = _G.MerchantFrameTitleText or _G.MerchantNameText
        if titleText and titleText.SetTextColor then
            titleText:SetTextColor(1, 1, 1)
        end

        -- Recolor repair text
        local repairText = _G.MerchantRepairText
        if repairText and repairText.SetTextColor then
            repairText:SetTextColor(1, 1, 1)
        end

        -- Recolor MerchantItem money text (gold/silver/copper) - NOT item names
        for i = 1, _G.MERCHANT_ITEMS_PER_PAGE or 12 do
            -- DO NOT recolor item names - they have rarity colors from Blizzard
            -- local itemName = _G["MerchantItem"..i.."Name"]

            -- Item slot cost (money text) - make white
            local itemMoney = _G["MerchantItem"..i.."MoneyFrame"]
            if itemMoney then
                -- Money frame children (gold, silver, copper text)
                for j = 1, itemMoney:GetNumChildren() do
                    local child = select(j, itemMoney:GetChildren())
                    if child then
                        local text = child.Text or _G[child:GetName() and (child:GetName().."Text")]
                        if text and text.SetTextColor then
                            text:SetTextColor(1, 1, 1)
                        end
                    end
                end
                -- Also check direct regions
                for j = 1, itemMoney:GetNumRegions() do
                    local region = select(j, itemMoney:GetRegions())
                    if region and region:IsObjectType("FontString") then
                        region:SetTextColor(1, 1, 1)
                    end
                end
            end

            -- Alternate cost text (for items that cost other items/currency)
            local altCurrency = _G["MerchantItem"..i.."AltCurrencyFrame"]
            if altCurrency then
                for j = 1, altCurrency:GetNumRegions() do
                    local region = select(j, altCurrency:GetRegions())
                    if region and region:IsObjectType("FontString") then
                        region:SetTextColor(1, 1, 1)
                    end
                end
            end
        end

        -- Recolor buyback money - but NOT the item name
        local buybackMoney = _G.MerchantBuyBackItemMoneyFrame
        if buybackMoney then
            for j = 1, buybackMoney:GetNumRegions() do
                local region = select(j, buybackMoney:GetRegions())
                if region and region:IsObjectType("FontString") then
                    region:SetTextColor(1, 1, 1)
                end
            end
        end

        -- Page text
        local pageText = _G.MerchantPageText
        if pageText and pageText.SetTextColor then
            pageText:SetTextColor(1, 1, 1)
        end
    end

    -- Delayed recolor to run AFTER Blizzard's color changes
    local function DelayedRecolorMerchantText()
        C_Timer.After(0, RecolorMerchantText)
    end

    -- Hook MerchantFrame_Update to reapply colors after Blizzard updates
    if _G.MerchantFrame_Update then
        hooksecurefunc("MerchantFrame_Update", DelayedRecolorMerchantText)
    end

    -- Also hook OnShow for initial display
    MerchantFrame:HookScript("OnShow", DelayedRecolorMerchantText)

    -- Set initial colors immediately
    RecolorMerchantText()
end
