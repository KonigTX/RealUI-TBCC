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

function private.FrameXML.GameMenuFrame()
    local GameMenuFrame = _G.GameMenuFrame
    if not GameMenuFrame then return end

    -- Strip textures from the frame
    StripTextures(GameMenuFrame)

    -- Apply Aurora backdrop first
    Base.SetBackdrop(GameMenuFrame, Color.frame)

    -- Also apply native TBC backdrop as insurance
    -- TBC GameMenuFrame needs explicit backdrop definition
    GameMenuFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileEdge = true,
        tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    GameMenuFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
    GameMenuFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    -- Skin buttons by global name (TBC doesn't use buttonPool)
    local buttons = {
        "GameMenuButtonHelp",
        "GameMenuButtonWhatsNew",
        "GameMenuButtonStore",
        "GameMenuButtonOptions",
        "GameMenuButtonUIOptions",
        "GameMenuButtonKeybindings",
        "GameMenuButtonMacros",
        "GameMenuButtonAddons",
        "GameMenuButtonLogout",
        "GameMenuButtonQuit",
        "GameMenuButtonContinue",
    }

    for _, btnName in ipairs(buttons) do
        local btn = _G[btnName]
        if btn then
            Skin.FrameTypeButton(btn)
        end
    end

    -- Skin any buttons found as frame children that weren't in the global list
    for i = 1, GameMenuFrame:GetNumChildren() do
        local child = select(i, GameMenuFrame:GetChildren())
        if child and child:IsObjectType("Button") and not child._auroraSkinned then
            Skin.FrameTypeButton(child)
            child._auroraSkinned = true
        end
    end
end
