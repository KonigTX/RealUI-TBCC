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

function private.FrameXML.FriendsFrame()
    local FriendsFrame = _G.FriendsFrame
    if not FriendsFrame then return end

    -- Hide NineSlice border system
    if FriendsFrame.NineSlice then
        StripTextures(FriendsFrame.NineSlice)
        FriendsFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(FriendsFrame, "portrait")
    HideElement(FriendsFrame, "PortraitFrame")
    HideElement(FriendsFrame, "PortraitContainer")
    HideElement(_G, "FriendsFramePortrait")
    HideElement(_G, "FriendsFramePortraitFrame")

    -- Hide border edges
    HideElement(FriendsFrame, "TopEdge")
    HideElement(FriendsFrame, "BottomEdge")
    HideElement(FriendsFrame, "LeftEdge")
    HideElement(FriendsFrame, "RightEdge")
    HideElement(FriendsFrame, "TopLeftCorner")
    HideElement(FriendsFrame, "TopRightCorner")
    HideElement(FriendsFrame, "BottomLeftCorner")
    HideElement(FriendsFrame, "BottomRightCorner")
    HideElement(FriendsFrame, "Center")

    -- Hide named global textures
    HideElement(_G, "FriendsFrameTopLeftCorner")
    HideElement(_G, "FriendsFrameTopRightCorner")
    HideElement(_G, "FriendsFrameBottomLeftCorner")
    HideElement(_G, "FriendsFrameBottomRightCorner")
    HideElement(_G, "FriendsFrameTopBorder")
    HideElement(_G, "FriendsFrameBottomBorder")
    HideElement(_G, "FriendsFrameLeftBorder")
    HideElement(_G, "FriendsFrameRightBorder")
    HideElement(_G, "FriendsFrameTopTileStreaks")

    -- Hide Bg and TitleBg
    HideElement(FriendsFrame, "Bg")
    HideElement(FriendsFrame, "TitleBg")
    HideElement(_G, "FriendsFrameBg")
    HideElement(_G, "FriendsFrameTitleBg")

    -- Hide inset
    local FriendsFrameInset = FriendsFrame.Inset or _G.FriendsFrameInset
    if FriendsFrameInset then
        StripTextures(FriendsFrameInset)
        if FriendsFrameInset.NineSlice then
            StripTextures(FriendsFrameInset.NineSlice)
            FriendsFrameInset.NineSlice:Hide()
        end
        HideElement(FriendsFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(FriendsFrame)

    -- Apply Aurora backdrop
    Base.SetBackdrop(FriendsFrame, Color.frame)

    -- Skin close button
    local closeButton = FriendsFrame.CloseButton or _G.FriendsFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin tabs (Friends, Who, Guild, Chat, Raid)
    for i = 1, 5 do
        local tab = _G["FriendsFrameTab"..i]
        if tab then
            StripTextures(tab)
            Skin.FrameTypeButton(tab)
        end
    end

    -- Skin scroll frames
    local scrollFrames = {
        "FriendsFrameFriendsScrollFrame",
        "FriendsFrameIgnoreScrollFrame",
        "WhoListScrollFrame",
        "GuildListScrollFrame",
    }
    for _, scrollName in ipairs(scrollFrames) do
        local scrollFrame = _G[scrollName]
        if scrollFrame then
            StripTextures(scrollFrame)
        end
    end

    -- Skin action buttons
    local buttons = {
        "FriendsFrameAddFriendButton",
        "FriendsFrameSendMessageButton",
        "FriendsFrameRemoveFriendButton",
        "FriendsFrameIgnorePlayerButton",
        "FriendsFrameUnsquelchButton",
        "WhoFrameWhoButton",
        "WhoFrameAddFriendButton",
        "WhoFrameGroupInviteButton",
        "GuildFrameGuildInformationButton",
        "GuildFrameAddMemberButton",
        "GuildFrameControlButton",
    }
    for _, btnName in ipairs(buttons) do
        local btn = _G[btnName]
        if btn then
            Skin.FrameTypeButton(btn)
        end
    end
end
