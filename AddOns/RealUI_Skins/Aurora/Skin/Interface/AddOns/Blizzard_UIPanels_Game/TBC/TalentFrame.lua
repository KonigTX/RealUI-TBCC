local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select

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

-- TalentFrame is created by Blizzard_TalentUI (load-on-demand)
-- Register as AddOn skin instead of FrameXML
private.AddOns["Blizzard_TalentUI"] = function()
    local TalentFrame = _G.TalentFrame or _G.PlayerTalentFrame
    if not TalentFrame then return end

    -- Hide NineSlice border system
    if TalentFrame.NineSlice then
        StripTextures(TalentFrame.NineSlice)
        TalentFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(TalentFrame, "portrait")
    HideElement(TalentFrame, "PortraitFrame")
    HideElement(TalentFrame, "PortraitContainer")
    HideElement(_G, "TalentFramePortrait")
    HideElement(_G, "TalentFramePortraitFrame")
    HideElement(_G, "PlayerTalentFramePortrait")

    -- Hide border edges
    HideElement(TalentFrame, "TopEdge")
    HideElement(TalentFrame, "BottomEdge")
    HideElement(TalentFrame, "LeftEdge")
    HideElement(TalentFrame, "RightEdge")
    HideElement(TalentFrame, "TopLeftCorner")
    HideElement(TalentFrame, "TopRightCorner")
    HideElement(TalentFrame, "BottomLeftCorner")
    HideElement(TalentFrame, "BottomRightCorner")
    HideElement(TalentFrame, "Center")

    -- Hide named global textures
    HideElement(_G, "TalentFrameTopLeftCorner")
    HideElement(_G, "TalentFrameTopRightCorner")
    HideElement(_G, "TalentFrameBottomLeftCorner")
    HideElement(_G, "TalentFrameBottomRightCorner")
    HideElement(_G, "TalentFrameTopBorder")
    HideElement(_G, "TalentFrameBottomBorder")
    HideElement(_G, "TalentFrameLeftBorder")
    HideElement(_G, "TalentFrameRightBorder")
    HideElement(_G, "TalentFrameTopTileStreaks")

    -- Hide Bg and TitleBg
    HideElement(TalentFrame, "Bg")
    HideElement(TalentFrame, "TitleBg")

    -- Hide inset
    local TalentFrameInset = TalentFrame.Inset or _G.TalentFrameInset
    if TalentFrameInset then
        StripTextures(TalentFrameInset)
        if TalentFrameInset.NineSlice then
            StripTextures(TalentFrameInset.NineSlice)
            TalentFrameInset.NineSlice:Hide()
        end
    end

    -- Hide talent background textures
    HideElement(_G, "TalentFrameBackgroundTopLeft")
    HideElement(_G, "TalentFrameBackgroundTopRight")
    HideElement(_G, "TalentFrameBackgroundBottomLeft")
    HideElement(_G, "TalentFrameBackgroundBottomRight")

    -- Strip ALL textures from main frame
    StripTextures(TalentFrame)

    -- Apply Aurora backdrop
    Base.SetBackdrop(TalentFrame, Color.frame)

    -- Skin close button
    local closeButton = TalentFrame.CloseButton or _G.TalentFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin talent tree tabs (bottom tabs: Elemental, Enhancement, Restoration)
    for i = 1, 5 do
        local tab = _G["TalentFrameTab"..i] or _G["PlayerTalentFrameTab"..i]
        if tab then
            StripTextures(tab)
            Skin.FrameTypeButton(tab)

            -- Explicitly set tab size and positioning to prevent overlap
            tab:SetWidth(115)
            tab:SetHeight(32)
            tab:ClearAllPoints()
            if i == 1 then
                tab:SetPoint("BOTTOMLEFT", TalentFrame, "BOTTOMLEFT", 10, -30)
            else
                tab:SetPoint("LEFT", _G["TalentFrameTab"..(i-1)] or _G["PlayerTalentFrameTab"..(i-1)], "RIGHT", 4, 0)
            end
        end
    end

    -- Skin talent tree selection tabs (side tabs if present)
    for i = 1, 3 do
        local treeTab = _G["TalentFrameTalentTab"..i]
        if treeTab then
            StripTextures(treeTab)
            Skin.FrameTypeButton(treeTab)
        end
    end

    -- Strip talent scroll frame if present
    local TalentFrameScrollFrame = _G.TalentFrameScrollFrame
    if TalentFrameScrollFrame then
        StripTextures(TalentFrameScrollFrame)
    end
end
