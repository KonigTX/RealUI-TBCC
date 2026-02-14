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

function private.FrameXML.QuestLogFrame()
    local QuestLogFrame = _G.QuestLogFrame
    if not QuestLogFrame then return end

    -- Hide NineSlice border system
    if QuestLogFrame.NineSlice then
        StripTextures(QuestLogFrame.NineSlice)
        QuestLogFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(QuestLogFrame, "portrait")
    HideElement(QuestLogFrame, "PortraitFrame")
    HideElement(QuestLogFrame, "PortraitContainer")
    HideElement(_G, "QuestLogFramePortrait")
    HideElement(_G, "QuestLogFramePortraitFrame")

    -- Hide border edges
    HideElement(QuestLogFrame, "TopEdge")
    HideElement(QuestLogFrame, "BottomEdge")
    HideElement(QuestLogFrame, "LeftEdge")
    HideElement(QuestLogFrame, "RightEdge")
    HideElement(QuestLogFrame, "TopLeftCorner")
    HideElement(QuestLogFrame, "TopRightCorner")
    HideElement(QuestLogFrame, "BottomLeftCorner")
    HideElement(QuestLogFrame, "BottomRightCorner")
    HideElement(QuestLogFrame, "Center")

    -- Hide named global textures
    HideElement(_G, "QuestLogFrameTopLeftCorner")
    HideElement(_G, "QuestLogFrameTopRightCorner")
    HideElement(_G, "QuestLogFrameBottomLeftCorner")
    HideElement(_G, "QuestLogFrameBottomRightCorner")
    HideElement(_G, "QuestLogFrameTopBorder")
    HideElement(_G, "QuestLogFrameBottomBorder")
    HideElement(_G, "QuestLogFrameLeftBorder")
    HideElement(_G, "QuestLogFrameRightBorder")
    HideElement(_G, "QuestLogFrameTopTileStreaks")

    -- Hide Bg and TitleBg
    HideElement(QuestLogFrame, "Bg")
    HideElement(QuestLogFrame, "TitleBg")
    HideElement(_G, "QuestLogFrameBg")
    HideElement(_G, "QuestLogFrameTitleBg")

    -- Hide inset
    local QuestLogFrameInset = QuestLogFrame.Inset or _G.QuestLogFrameInset
    if QuestLogFrameInset then
        StripTextures(QuestLogFrameInset)
        if QuestLogFrameInset.NineSlice then
            StripTextures(QuestLogFrameInset.NineSlice)
            QuestLogFrameInset.NineSlice:Hide()
        end
        HideElement(QuestLogFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(QuestLogFrame)

    -- Apply Aurora backdrop
    Base.SetBackdrop(QuestLogFrame, Color.frame)

    -- Enable dragging for QuestLogFrame
    QuestLogFrame:SetMovable(true)
    QuestLogFrame:EnableMouse(true)
    QuestLogFrame:RegisterForDrag("LeftButton")
    QuestLogFrame:SetScript("OnDragStart", QuestLogFrame.StartMoving)
    QuestLogFrame:SetScript("OnDragStop", QuestLogFrame.StopMovingOrSizing)

    -- Skin close button
    local closeButton = QuestLogFrame.CloseButton or _G.QuestLogFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin scroll frames
    local scrollFrames = {
        "QuestLogScrollFrame",
        "QuestLogDetailScrollFrame",
    }
    for _, scrollName in ipairs(scrollFrames) do
        local scrollFrame = _G[scrollName]
        if scrollFrame then
            StripTextures(scrollFrame)
            if scrollFrame.ScrollBar then
                Skin.FrameTypeScrollBar(scrollFrame.ScrollBar)
            end
            -- Try legacy scroll bar naming
            local scrollBar = _G[scrollName.."ScrollBar"]
            if scrollBar then
                Skin.FrameTypeScrollBar(scrollBar)
            end
        end
    end

    -- Skin quest log buttons
    local buttons = {
        "QuestLogFrameAbandonButton",
        "QuestFramePushQuestButton",  -- Share Quest button
        "QuestLogTrackToggle",
    }
    for _, btnName in ipairs(buttons) do
        local btn = _G[btnName]
        if btn then
            Skin.FrameTypeButton(btn)
        end
    end

    -- Skin quest log count frame (if present)
    local QuestLogCount = _G.QuestLogCount
    if QuestLogCount then
        StripTextures(QuestLogCount)
    end

    -- Skin quest log detail frame background
    local QuestLogDetailScrollFrameScrollChild = _G.QuestLogDetailScrollFrameScrollChild
    if QuestLogDetailScrollFrameScrollChild then
        StripTextures(QuestLogDetailScrollFrameScrollChild)
    end

    -- Hide any material frame textures
    HideElement(_G, "QuestLogDetailFrameMaterialTopLeft")
    HideElement(_G, "QuestLogDetailFrameMaterialTopRight")
    HideElement(_G, "QuestLogDetailFrameMaterialBotLeft")
    HideElement(_G, "QuestLogDetailFrameMaterialBotRight")

    -- Recolor TBC Quest Log FontStrings directly
    -- These are global FontString objects, not part of the scroll child
    local questLogFonts = {
        "QuestLogQuestTitle",
        "QuestLogQuestDescription",
        "QuestLogObjectivesText",
        "QuestLogDescriptionTitle",
        "QuestLogRewardTitleText",
        "QuestLogItemChooseText",
        "QuestLogItemReceiveText",
        "QuestLogRequiredMoneyText",
    }

    local function RecolorQuestLogText()
        -- Set color on named FontStrings
        for _, fontName in ipairs(questLogFonts) do
            local font = _G[fontName]
            if font and font.SetTextColor then
                font:SetTextColor(1, 1, 1)
            end
        end

        -- Also iterate scroll child regions to catch any dynamic text
        local QuestLogDetailScrollFrameScrollChild = _G.QuestLogDetailScrollFrameScrollChild
        if QuestLogDetailScrollFrameScrollChild then
            for i = 1, QuestLogDetailScrollFrameScrollChild:GetNumRegions() do
                local region = select(i, QuestLogDetailScrollFrameScrollChild:GetRegions())
                if region and region:IsObjectType("FontString") then
                    region:SetTextColor(1, 1, 1)
                end
            end
        end
    end

    -- Hook the TBC function name (QuestLog_UpdateQuestDetails exists in TBC)
    if _G.QuestLog_UpdateQuestDetails then
        _G.hooksecurefunc("QuestLog_UpdateQuestDetails", RecolorQuestLogText)
    end

    -- Also hook QuestLog_Update if it exists (fallback)
    if _G.QuestLog_Update then
        _G.hooksecurefunc("QuestLog_Update", RecolorQuestLogText)
    end

    -- Set initial colors immediately
    RecolorQuestLogText()
end
