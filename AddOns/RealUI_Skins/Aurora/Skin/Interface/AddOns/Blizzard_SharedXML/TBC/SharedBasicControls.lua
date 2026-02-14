local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select tinsert

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

-- =============================================================================
-- TBC-Compatible Close Button Skin (creates X using textures)
-- =============================================================================
function Skin.UIPanelCloseButton(Button)
    if not Button then return end

    -- Apply base button skin
    Skin.FrameTypeButton(Button)

    -- Hide default textures
    local name = Button:GetName()
    if name then
        local normalTex = _G[name .. "NormalTexture"] or Button:GetNormalTexture()
        local pushedTex = _G[name .. "PushedTexture"] or Button:GetPushedTexture()
        local highlightTex = _G[name .. "HighlightTexture"] or Button:GetHighlightTexture()
        local disabledTex = _G[name .. "DisabledTexture"] or Button:GetDisabledTexture()

        if normalTex then normalTex:SetAlpha(0) end
        if pushedTex then pushedTex:SetAlpha(0) end
        if highlightTex then highlightTex:SetAlpha(0) end
        if disabledTex then disabledTex:SetAlpha(0) end
    end

    -- Create X using two diagonal textures
    if not Button._auroraCloseX then
        local size = Button:GetWidth() or 24
        local inset = 6

        -- Create container for X lines
        local x1 = Button:CreateTexture(nil, "OVERLAY")
        x1:SetColorTexture(1, 1, 1)
        x1:SetSize(size - inset * 2, 1.5)
        x1:SetPoint("CENTER")
        x1:SetRotation(math.rad(45))

        local x2 = Button:CreateTexture(nil, "OVERLAY")
        x2:SetColorTexture(1, 1, 1)
        x2:SetSize(size - inset * 2, 1.5)
        x2:SetPoint("CENTER")
        x2:SetRotation(math.rad(-45))

        Button._auroraCloseX = {x1, x2}

        -- Color on hover
        Button:HookScript("OnEnter", function()
            x1:SetColorTexture(1, 0.2, 0.2)
            x2:SetColorTexture(1, 0.2, 0.2)
        end)
        Button:HookScript("OnLeave", function()
            x1:SetColorTexture(1, 1, 1)
            x2:SetColorTexture(1, 1, 1)
        end)
    end
end

-- =============================================================================
-- TBC-Compatible Scrollbar Skin
-- =============================================================================
function Skin.UIPanelScrollBarTBC(scrollBar)
    if not scrollBar then return end

    local name = scrollBar:GetName()

    -- Hide default textures
    if name then
        local top = _G[name .. "Top"]
        local bottom = _G[name .. "Bottom"]
        local middle = _G[name .. "Middle"]
        local track = _G[name .. "Track"]

        if top then top:SetAlpha(0) end
        if bottom then bottom:SetAlpha(0) end
        if middle then middle:SetAlpha(0) end
        if track then track:SetAlpha(0) end
    end

    -- Style up button
    local upBtn = _G[name .. "ScrollUpButton"] or scrollBar.ScrollUpButton
    if upBtn then
        Skin.FrameTypeButton(upBtn)
    end

    -- Style down button
    local downBtn = _G[name .. "ScrollDownButton"] or scrollBar.ScrollDownButton
    if downBtn then
        Skin.FrameTypeButton(downBtn)
    end

    -- Style thumb
    local thumbTex = scrollBar.ThumbTexture or _G[name .. "ThumbTexture"]
    if thumbTex then
        thumbTex:SetColorTexture(0.5, 0.5, 0.5)
        thumbTex:SetSize(8, 20)
    end
end

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

do -- UIPanelDialog template for TBC
    function Skin.UIPanelDialogTemplate(Frame)
        if not Frame then return end
        local name = Frame:GetName()

        -- Hide border textures (TBC naming convention)
        local borderTextures = {
            "TopLeft", "TopRight", "Top",
            "BottomLeft", "BottomRight", "Bottom",
            "Left", "Right"
        }
        for _, texName in ipairs(borderTextures) do
            local tex = _G[name .. texName]
            if tex then tex:Hide() end
        end

        -- Strip all textures
        StripTextures(Frame)

        -- Apply Aurora backdrop
        Base.SetBackdrop(Frame, Color.frame)

        -- Position title (TBC doesn't use FRAME_TITLE_HEIGHT constant)
        local title = Frame.Title or _G[name .. "Title"]
        if title then
            title:ClearAllPoints()
            title:SetPoint("TOPLEFT")
            title:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", 0, -20) -- TBC: hardcode title height
        end

        -- Hide title background
        local titleBG = _G[name .. "TitleBG"]
        if titleBG then titleBG:Hide() end

        -- Hide dialog background
        local dialogBG = _G[name .. "DialogBG"]
        if dialogBG then dialogBG:Hide() end

        -- Skin close button
        local close = _G[name .. "Close"]
        if close then
            Skin.FrameTypeButton(close)
        end
    end
end

function private.SharedXML.SharedBasicControls()
    local ScriptErrorsFrame = _G.ScriptErrorsFrame
    if not ScriptErrorsFrame then return end

    -- Skin the frame
    Skin.UIPanelDialogTemplate(ScriptErrorsFrame)
    ScriptErrorsFrame:SetSize(600, 400)
    ScriptErrorsFrame:SetScale(_G.UIParent:GetScale())

    -- Skin scroll frame (TBC uses legacy ScrollFrameTemplate, not modern ScrollFrame)
    local scrollFrame = ScriptErrorsFrame.ScrollFrame or _G.ScriptErrorsFrameScrollFrame
    if scrollFrame then
        StripTextures(scrollFrame)
        scrollFrame:SetPoint("BOTTOMRIGHT", -26, 34)
    end

    -- Reposition text if available
    local scrollText = ScriptErrorsFrame.ScrollFrame and ScriptErrorsFrame.ScrollFrame.Text
    if scrollText then
        scrollText:SetPoint("BOTTOMRIGHT", -26, 34)
    end

    -- Skin Reload button
    local reloadBtn = ScriptErrorsFrame.Reload or _G.ScriptErrorsFrameReload
    if reloadBtn then
        Skin.FrameTypeButton(reloadBtn)
        reloadBtn:SetPoint("BOTTOMLEFT", 5, 5)
    end

    -- Skin navigation buttons (TBC has simple buttons, not NavButton template)
    local prevBtn = ScriptErrorsFrame.PreviousError or _G.ScriptErrorsFramePreviousError
    local nextBtn = ScriptErrorsFrame.NextError or _G.ScriptErrorsFrameNextError

    if prevBtn then
        if Skin.NavButtonPrevious then
            Skin.NavButtonPrevious(prevBtn)
        else
            Skin.FrameTypeButton(prevBtn)
        end
    end

    if nextBtn then
        if Skin.NavButtonNext then
            Skin.NavButtonNext(nextBtn)
        else
            Skin.FrameTypeButton(nextBtn)
        end
    end

    -- Skin close button
    local closeBtn = ScriptErrorsFrame.Close or _G.ScriptErrorsFrameClose
    if closeBtn then
        Skin.FrameTypeButton(closeBtn)
    end

    -- Adjust scroll frame position
    if scrollFrame then
        scrollFrame:SetPoint("BOTTOMRIGHT", -5, 5)
    end
end
