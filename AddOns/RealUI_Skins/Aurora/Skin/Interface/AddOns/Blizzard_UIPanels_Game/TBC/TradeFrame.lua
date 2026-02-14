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

function private.FrameXML.TradeFrame()
    local TradeFrame = _G.TradeFrame
    if not TradeFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if TradeFrame.NineSlice then
        StripTextures(TradeFrame.NineSlice)
        TradeFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(TradeFrame, "portrait")
    HideElement(TradeFrame, "PortraitFrame")
    HideElement(TradeFrame, "PortraitContainer")
    HideElement(_G, "TradeFramePortrait")
    HideElement(_G, "TradeFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(TradeFrame, "TopEdge")
    HideElement(TradeFrame, "BottomEdge")
    HideElement(TradeFrame, "LeftEdge")
    HideElement(TradeFrame, "RightEdge")
    HideElement(TradeFrame, "TopLeftCorner")
    HideElement(TradeFrame, "TopRightCorner")
    HideElement(TradeFrame, "BottomLeftCorner")
    HideElement(TradeFrame, "BottomRightCorner")
    HideElement(TradeFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "TradeFrameTopLeftCorner")
    HideElement(_G, "TradeFrameTopRightCorner")
    HideElement(_G, "TradeFrameBottomLeftCorner")
    HideElement(_G, "TradeFrameBottomRightCorner")
    HideElement(_G, "TradeFrameTopBorder")
    HideElement(_G, "TradeFrameBottomBorder")
    HideElement(_G, "TradeFrameLeftBorder")
    HideElement(_G, "TradeFrameRightBorder")

    -- Hide Bg and TitleBg
    HideElement(TradeFrame, "Bg")
    HideElement(TradeFrame, "TitleBg")
    HideElement(_G, "TradeFrameBg")
    HideElement(_G, "TradeFrameTitleBg")

    -- Hide inset
    local TradeFrameInset = TradeFrame.Inset or _G.TradeFrameInset
    if TradeFrameInset then
        StripTextures(TradeFrameInset)
        if TradeFrameInset.NineSlice then
            StripTextures(TradeFrameInset.NineSlice)
            TradeFrameInset.NineSlice:Hide()
        end
        HideElement(TradeFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(TradeFrame)

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(TradeFrame, Color.frame)

    -- Skin close button
    local closeButton = TradeFrame.CloseButton or _G.TradeFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin trade button
    local TradeFrameTradeButton = _G.TradeFrameTradeButton
    if TradeFrameTradeButton then
        Skin.FrameTypeButton(TradeFrameTradeButton)
    end

    local TradeFrameCancelButton = _G.TradeFrameCancelButton
    if TradeFrameCancelButton then
        Skin.FrameTypeButton(TradeFrameCancelButton)
    end

    -- Strip textures from player trade slots (these are item containers, not buttons)
    for i = 1, 7 do
        local playerItem = _G["TradePlayerItem"..i]
        if playerItem then
            StripTextures(playerItem)
            -- Skin the actual button inside if it exists
            local itemButton = playerItem.ItemButton or _G["TradePlayerItem"..i.."ItemButton"]
            if itemButton and itemButton.SetNormalTexture then
                Skin.FrameTypeButton(itemButton)
            end
        end
    end

    -- Strip textures from recipient trade slots
    for i = 1, 7 do
        local recipientItem = _G["TradeRecipientItem"..i]
        if recipientItem then
            StripTextures(recipientItem)
            -- Skin the actual button inside if it exists
            local itemButton = recipientItem.ItemButton or _G["TradeRecipientItem"..i.."ItemButton"]
            if itemButton and itemButton.SetNormalTexture then
                Skin.FrameTypeButton(itemButton)
            end
        end
    end

    -- Recolor TBC TradeFrame FontStrings for readability
    local function RecolorTradeText()
        -- Player and recipient name text
        local playerName = _G.TradeFramePlayerNameText
        if playerName and playerName.SetTextColor then
            playerName:SetTextColor(1, 1, 1)
        end

        local recipientName = _G.TradeFrameRecipientNameText
        if recipientName and recipientName.SetTextColor then
            recipientName:SetTextColor(1, 1, 1)
        end

        -- Recolor item names in trade slots
        for i = 1, 7 do
            local playerItemName = _G["TradePlayerItem"..i.."Name"]
            if playerItemName and playerItemName.SetTextColor then
                playerItemName:SetTextColor(1, 1, 1)
            end

            local recipientItemName = _G["TradeRecipientItem"..i.."Name"]
            if recipientItemName and recipientItemName.SetTextColor then
                recipientItemName:SetTextColor(1, 1, 1)
            end
        end

        -- Iterate trade frame regions to catch other dynamic text
        for i = 1, TradeFrame:GetNumRegions() do
            local region = select(i, TradeFrame:GetRegions())
            if region and region:IsObjectType("FontString") then
                region:SetTextColor(1, 1, 1)
            end
        end

        -- Also recolor children frame FontStrings (with pcall to handle MoneyFrames and other special frames)
        for _, child in pairs({TradeFrame:GetChildren()}) do
            if child.GetRegions then
                local ok, regions = pcall(function() return {child:GetRegions()} end)
                if ok and regions then
                    for _, region in pairs(regions) do
                        if region and region.IsObjectType and region:IsObjectType("FontString") then
                            region:SetTextColor(1, 1, 1)
                        end
                    end
                end
            end
        end
    end

    -- Delayed recolor to run AFTER Blizzard's color changes
    local function DelayedRecolorTradeText()
        C_Timer.After(0, RecolorTradeText)
    end

    -- Hook TradeFrame_Update to reapply colors after Blizzard updates
    if _G.TradeFrame_Update then
        hooksecurefunc("TradeFrame_Update", DelayedRecolorTradeText)
    end

    -- Also hook OnShow for initial display
    TradeFrame:HookScript("OnShow", DelayedRecolorTradeText)

    -- Set initial colors immediately
    RecolorTradeText()
end
