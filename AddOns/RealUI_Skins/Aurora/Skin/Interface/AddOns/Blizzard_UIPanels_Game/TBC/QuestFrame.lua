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

function private.FrameXML.QuestFrame()
    local QuestFrame = _G.QuestFrame
    if not QuestFrame then return end

    -- Hide NineSlice border system
    if QuestFrame.NineSlice then
        StripTextures(QuestFrame.NineSlice)
        QuestFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(QuestFrame, "portrait")
    HideElement(QuestFrame, "PortraitFrame")
    HideElement(QuestFrame, "PortraitContainer")
    HideElement(_G, "QuestFramePortrait")
    HideElement(_G, "QuestFramePortraitFrame")

    -- Hide border edges
    HideElement(QuestFrame, "TopEdge")
    HideElement(QuestFrame, "BottomEdge")
    HideElement(QuestFrame, "LeftEdge")
    HideElement(QuestFrame, "RightEdge")
    HideElement(QuestFrame, "TopLeftCorner")
    HideElement(QuestFrame, "TopRightCorner")
    HideElement(QuestFrame, "BottomLeftCorner")
    HideElement(QuestFrame, "BottomRightCorner")
    HideElement(QuestFrame, "Center")

    -- Hide named global textures
    HideElement(_G, "QuestFrameTopLeftCorner")
    HideElement(_G, "QuestFrameTopRightCorner")
    HideElement(_G, "QuestFrameBottomLeftCorner")
    HideElement(_G, "QuestFrameBottomRightCorner")
    HideElement(_G, "QuestFrameTopBorder")
    HideElement(_G, "QuestFrameBottomBorder")
    HideElement(_G, "QuestFrameLeftBorder")
    HideElement(_G, "QuestFrameRightBorder")

    -- Hide Bg and TitleBg
    HideElement(QuestFrame, "Bg")
    HideElement(QuestFrame, "TitleBg")

    -- Hide inset
    local QuestFrameInset = QuestFrame.Inset or _G.QuestFrameInset
    if QuestFrameInset then
        StripTextures(QuestFrameInset)
        if QuestFrameInset.NineSlice then
            StripTextures(QuestFrameInset.NineSlice)
            QuestFrameInset.NineSlice:Hide()
        end
    end

    -- Strip ALL textures from main frame
    StripTextures(QuestFrame)

    -- Apply Aurora backdrop
    Base.SetBackdrop(QuestFrame, Color.frame)

    -- Skin close button
    local closeButton = QuestFrame.CloseButton or _G.QuestFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin scroll frames
    local scrollFrames = {
        "QuestDetailScrollFrame",
        "QuestRewardScrollFrame",
        "QuestProgressScrollFrame",
        "QuestGreetingScrollFrame",
    }
    for _, scrollName in ipairs(scrollFrames) do
        local scrollFrame = _G[scrollName]
        if scrollFrame then
            StripTextures(scrollFrame)
            Base.SetBackdrop(scrollFrame, Color.frame, 0.3)
        end
    end

    -- Skin quest buttons
    local buttons = {
        "QuestFrameAcceptButton",
        "QuestFrameDeclineButton",
        "QuestFrameCompleteButton",
        "QuestFrameGoodbyeButton",
        "QuestFrameCompleteQuestButton",
        "QuestFrameCancelButton",
        "QuestFrameGreetingGoodbyeButton",
    }
    for _, btnName in ipairs(buttons) do
        local btn = _G[btnName]
        if btn then
            Skin.FrameTypeButton(btn)
        end
    end
end
