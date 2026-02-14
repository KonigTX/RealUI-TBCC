local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select hooksecurefunc

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

-- Helper to hide ONLY border/background textures, preserving icons
local function StripBorderTextures(frame)
    if not frame then return end
    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if region and region:IsObjectType("Texture") then
            local texturePath = region:GetTexture()
            -- Only hide border/background textures, not icons
            if texturePath and type(texturePath) == "string" and (
                texturePath:find("Border") or
                texturePath:find("Background") or
                texturePath:find("Edge") or
                texturePath:find("Corner") or
                texturePath:find("DialogFrame") or
                texturePath:find("UI%-Panel") or
                texturePath:find("Portrait")
            ) then
                region:SetTexture("")
                region:SetAlpha(0)
            end
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

function private.FrameXML.LootFrame()
    local LootFrame = _G.LootFrame
    if not LootFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if LootFrame.NineSlice then
        StripBorderTextures(LootFrame.NineSlice)
        LootFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(LootFrame, "portrait")
    HideElement(LootFrame, "PortraitFrame")
    HideElement(LootFrame, "PortraitContainer")
    HideElement(_G, "LootFramePortrait")
    HideElement(_G, "LootFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(LootFrame, "TopEdge")
    HideElement(LootFrame, "BottomEdge")
    HideElement(LootFrame, "LeftEdge")
    HideElement(LootFrame, "RightEdge")
    HideElement(LootFrame, "TopLeftCorner")
    HideElement(LootFrame, "TopRightCorner")
    HideElement(LootFrame, "BottomLeftCorner")
    HideElement(LootFrame, "BottomRightCorner")
    HideElement(LootFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "LootFrameTopLeftCorner")
    HideElement(_G, "LootFrameTopRightCorner")
    HideElement(_G, "LootFrameBottomLeftCorner")
    HideElement(_G, "LootFrameBottomRightCorner")
    HideElement(_G, "LootFrameTopBorder")
    HideElement(_G, "LootFrameBottomBorder")
    HideElement(_G, "LootFrameLeftBorder")
    HideElement(_G, "LootFrameRightBorder")

    -- Hide Bg and TitleBg
    HideElement(LootFrame, "Bg")
    HideElement(LootFrame, "TitleBg")
    HideElement(_G, "LootFrameBg")
    HideElement(_G, "LootFrameTitleBg")

    -- Hide inset
    local LootFrameInset = LootFrame.Inset or _G.LootFrameInset
    if LootFrameInset then
        StripBorderTextures(LootFrameInset)
        if LootFrameInset.NineSlice then
            StripBorderTextures(LootFrameInset.NineSlice)
            LootFrameInset.NineSlice:Hide()
        end
        HideElement(LootFrameInset, "Bg")
    end

    -- Strip only border textures from main frame (preserve icons!)
    StripBorderTextures(LootFrame)

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(LootFrame, Color.frame)

    -- Skin close button with TBC-compatible X
    local closeButton = LootFrame.CloseButton or _G.LootFrameCloseButton
    if closeButton then
        if Skin.UIPanelCloseButton then
            Skin.UIPanelCloseButton(closeButton)
        else
            Skin.FrameTypeButton(closeButton)
        end
        -- Reposition close button to top-right corner
        closeButton:ClearAllPoints()
        closeButton:SetPoint("TOPRIGHT", LootFrame, "TOPRIGHT", -5, -5)
    end

    -- Position LootFrame at cursor on open
    LootFrame:HookScript("OnShow", function(self)
        local x, y = _G.GetCursorPosition()
        local scale = self:GetEffectiveScale()
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", _G.UIParent, "BOTTOMLEFT", x / scale, y / scale)
    end)

    -- Style loot buttons WITHOUT stripping their icon textures
    -- LootButton1-4 (or more) contain the item icons that need tooltips
    for i = 1, _G.LOOTFRAME_NUMBUTTONS or 4 do
        local lootButton = _G["LootButton"..i]
        if lootButton then
            -- DO NOT call Skin.FrameTypeButton as it strips textures
            -- The loot button icon is essential for tooltips and display

            -- Just add a subtle border around the button
            if lootButton.SetBackdrop then
                lootButton:SetBackdrop({
                    edgeFile = "Interface\\Buttons\\WHITE8x8",
                    edgeSize = 1,
                })
                lootButton:SetBackdropBorderColor(0.3, 0.3, 0.3)
            end

            -- Make sure the icon is visible and properly styled
            local icon = lootButton.icon or _G["LootButton"..i.."IconTexture"]
            if icon then
                icon:SetAlpha(1)
                -- Crop icon to remove default border
                if Base.CropIcon then
                    Base.CropIcon(icon)
                end
            end

            -- Make sure the item name text is readable
            local nameFrame = _G["LootButton"..i.."NameFrame"]
            if nameFrame then
                nameFrame:SetAlpha(0) -- Hide the name background texture
            end

            local text = lootButton.Text or _G["LootButton"..i.."Text"]
            if text and text.SetTextColor then
                text:SetTextColor(1, 1, 1)
            end
        end
    end

    -- Make sure the title text is visible
    local titleText = LootFrame.TitleText or _G.LootFrameTitleText
    if titleText and titleText.SetTextColor then
        titleText:SetTextColor(1, 1, 1)
    end

    -- Recolor loot text with rarity colors
    local function RecolorLootText()
        -- Title text
        if titleText and titleText.SetTextColor then
            titleText:SetTextColor(1, 1, 1)
        end

        -- Loot button item names with rarity coloring
        for i = 1, _G.LOOTFRAME_NUMBUTTONS or 4 do
            local text = _G["LootButton"..i.."Text"]
            if text and text.SetTextColor then
                -- Get loot slot info - returns: icon, name, quantity, rarity, locked, isQuestItem
                local lootIcon, lootName, lootQuantity, rarity, locked, isQuestItem = _G.GetLootSlotInfo(i)

                if rarity and rarity >= 0 then
                    -- Use rarity-based coloring
                    local r, g, b, hex = _G.GetItemQualityColor(rarity)
                    text:SetTextColor(r, g, b)
                else
                    -- Fallback to white for non-item loot (currency, etc.)
                    text:SetTextColor(1, 1, 1)
                end
            end
        end
    end

    -- Hook LootFrame_Update to reapply text colors when loot contents change
    if _G.LootFrame_Update then
        hooksecurefunc("LootFrame_Update", RecolorLootText)
    end
end
