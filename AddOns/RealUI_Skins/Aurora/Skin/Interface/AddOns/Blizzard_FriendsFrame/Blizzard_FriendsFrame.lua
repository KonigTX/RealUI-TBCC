local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ SharedXML\FriendsFrame.lua ]]
    Hook.FriendsBroadcastFrameMixin = {}
    function Hook.FriendsBroadcastFrameMixin:ShowFrame()
        -- self.BroadcastButton:LockHighlight()
    end
    function Hook.FriendsBroadcastFrameMixin:HideFrame()
        -- self.BroadcastButton:UnlockHighlight()
    end

    function Hook.FriendsFrame_UpdateFriendButton(button, elementData)
        local gameIcon = button.gameIcon
        if gameIcon._bg then
            gameIcon._bg:SetShown(gameIcon:IsShown())
        end
    end
    function Hook.WhoList_InitButton(button, elementData)
        local info = elementData.info
        if info.filename then
            button.Class:SetTextColor(_G.CUSTOM_CLASS_COLORS[info.filename]:GetRGB())
        end
    end
    function Hook.WhoList_Update()
        local buttons = _G.WhoListScrollFrame.buttons
        local numButtons = #buttons

        for i = 1, numButtons do
            local button = buttons[i]
            if button.index then
                local info = _G.C_FriendList.GetWhoInfo(button.index)
                if info.filename then
                    button.Class:SetTextColor(_G.CUSTOM_CLASS_COLORS[info.filename]:GetRGB())
                end
            end
        end
    end
end

do --[[ SharedXML\FriendsFrame.xml ]]
    function Skin.FriendsTabTemplate(Button)
        Skin.TabSystemButtonTemplate(Button)
    end
    function Skin.FriendsFrameSlider(Slider)
        Skin.HybridScrollBarTrimTemplate(Slider)
    end
    function Skin.FriendsFrameScrollFrame(ScrollFrame)
        Skin.FriendsFrameSlider(ScrollFrame.scrollBar)
    end
    function Skin.FriendsFrameHeaderTemplate(Frame)
    end
    function Skin.FriendsFrameButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)
    end
    function Skin.FriendsListButtonTemplate(Button)
        local gameIcon = Button.gameIcon
        gameIcon._bg = Base.CropIcon(Button.gameIcon, Button)
        gameIcon:SetSize(22, 22)
        gameIcon:SetTexCoord(0.15625, 0.84375, 0.15625, 0.84375)
        gameIcon:SetPoint("TOPRIGHT", -21, -6)

        local travelPassButton = Button.travelPassButton
        Skin.FrameTypeButton(travelPassButton)
        travelPassButton:SetSize(20, 32)

        local texture = travelPassButton:CreateTexture(nil, "OVERLAY", nil, 7)
        texture:SetTexture([[Interface\FriendsFrame\PlusManz-PlusManz]])
        texture:SetPoint("TOPRIGHT", 1, -4)
        texture:SetSize(22, 22)
        texture:SetAlpha(0.75)
        travelPassButton._auroraTextures = {texture}
    end
    function Skin.WhoFrameColumnHeaderTemplate(Button)
        Button.Left:Hide()
        Button.Right:Hide()
        Button.Middle:Hide()
        Button.HighlightTexture:SetAlpha(0)
    end
    function Skin.FriendsFrameGuildPlayerStatusButtonTemplate(Button)
        Button:GetHighlightTexture():SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
    end
    function Skin.FriendsFrameGuildStatusButtonTemplate(Button)
        Button:GetHighlightTexture():SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
    end
    function Skin.GuildFrameColumnHeaderTemplate(Button)
        local name = Button:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Middle"]:Hide()
        _G[name.."Right"]:Hide()
    end
    function Skin.GuildFrameColumnHeaderTemplate(Button)
        local name = Button:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Middle"]:Hide()
        _G[name.."Right"]:Hide()
        local highlight = Button:GetHighlightTexture()
        if highlight then
            highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, 0.2)
        end
    end
    function Skin.FriendsFrameTabTemplate(Button)
        Skin.PanelTabButtonTemplate(Button)
        Button._auroraTabResize = true
    end
    function Skin.GuildControlPopupFrameCheckboxTemplate(CheckButton)
        Skin.UICheckButtonTemplate(CheckButton)
    end
end

function private.FrameXML.FriendsFrame()
    _G.hooksecurefunc("FriendsFrame_UpdateFriendButton", Hook.FriendsFrame_UpdateFriendButton)
    if _G.WhoList_InitButton and type(_G.WhoList_InitButton) == "function" then
        _G.hooksecurefunc("WhoList_InitButton", Hook.WhoList_InitButton)
    end

    local FriendsFrame = _G.FriendsFrame
    Skin.ButtonFrameTemplate(FriendsFrame)
    _G.FriendsFrameIcon:Hide()

    ----------------------
    -- FriendsTabHeader --
    ----------------------
    local BNetFrame = _G.FriendsFrameBattlenetFrame
    if BNetFrame then
        BNetFrame:GetRegions():Hide() -- BattleTag background
        BNetFrame:SetWidth(250)
        BNetFrame:SetPoint("TOP", 0, -26)
        Base.SetBackdrop(BNetFrame, _G.FRIENDS_BNET_BACKGROUND_COLOR, Color.frame.a)
    end

    do -- BNetFrame.BroadcastButton
        local Button = BNetFrame and BNetFrame.ContactsMenuButton
        if Button then
            Skin.FrameTypeButton(Button)
            Button:GetNormalTexture():SetAlpha(0)
            Button:GetPushedTexture():SetAlpha(0)
            Button:SetBackdropOption("offsets", {
                left = 5,
                right = 5,
                top = 5,
                bottom = 5,
            })

            local icon = Button:CreateTexture(nil, "ARTWORK")
            icon:SetTexture([[Interface\FriendsFrame\MenuIcon]])
            icon:SetSize(16, 16)
            icon:SetPoint("CENTER")
        end
    end

    if BNetFrame and BNetFrame.UnavailableInfoButton then
        Skin.UIPanelInfoButton(BNetFrame.UnavailableInfoButton)
    end

    local BroadcastFrame = BNetFrame and BNetFrame.BroadcastFrame
    if BroadcastFrame then
        BroadcastFrame:SetPoint("TOPLEFT", -55, -24)
    end

    -- Util.Mixin(BroadcastFrame, Hook.FriendsBroadcastFrameMixin)
    if BroadcastFrame and BroadcastFrame.Border then
        Skin.DialogBorderOpaqueTemplate(BroadcastFrame.Border)
    end

    local EditBox = BroadcastFrame and BroadcastFrame.EditBox
    if EditBox then
        Base.CreateBackdrop(EditBox, private.backdrop, {
            tl = EditBox.TopLeftBorder,
            tr = EditBox.TopRightBorder,
            t = EditBox.TopBorder,

            bl = EditBox.BottomLeftBorder,
            br = EditBox.BottomRightBorder,
            b = EditBox.BottomBorder,

            l = EditBox.LeftBorder,
            r = EditBox.RightBorder,

            bg = EditBox.MiddleBorder
        })
        Skin.FrameTypeEditBox(EditBox)
        EditBox:SetBackdropOption("offsets", {
            left = -7,
            right = -5,
            top = 0,
            bottom = 0,
        })
    end

    if BroadcastFrame and BroadcastFrame.UpdateButton then
        Skin.FriendsFrameButtonTemplate(BroadcastFrame.UpdateButton)
    end
    if BroadcastFrame and BroadcastFrame.CancelButton then
        Skin.FriendsFrameButtonTemplate(BroadcastFrame.CancelButton)
    end

    Skin.DialogBorderTemplate(BNetFrame.UnavailableInfoFrame)
    local _, blizzIcon = select(11, BNetFrame.UnavailableInfoFrame:GetRegions())
    blizzIcon:SetTexture([[Interface\Glues\MainMenu\Glues-BlizzardLogo]])

    local FriendsFrameStatusDropdown = _G.FriendsFrameStatusDropdown
    FriendsFrameStatusDropdown:ClearAllPoints()
    Skin.DropdownButton(FriendsFrameStatusDropdown)
    FriendsFrameStatusDropdown:SetPoint("TOPLEFT", 5, -27)
    FriendsFrameStatusDropdown:SetWidth(50)

    local FriendsTabHeader = _G.FriendsTabHeader
    if FriendsTabHeader and FriendsTabHeader.TabSystem then
        for _, tab in next, {FriendsTabHeader.TabSystem:GetChildren()} do
            if not tab._auroraSkinned then
                Skin.FriendsTabTemplate(tab)
                tab._auroraSkinned = true
            end
        end
    end

    ----------------------
    -- FriendsListFrame --
    ----------------------
    local FriendsListFrame = _G.FriendsListFrame
    if _G.FriendsFrameAddFriendButton then
        Skin.FriendsFrameButtonTemplate(_G.FriendsFrameAddFriendButton)
    end
    if _G.FriendsFrameSendMessageButton then
        Skin.FriendsFrameButtonTemplate(_G.FriendsFrameSendMessageButton)
    end
    -- FIXLATER
    --- Skin.WowStyle1FilterDropdownTemplate(FriendsListFrame.FilterDropdown)
    if FriendsListFrame and FriendsListFrame.RIDWarning then
        Skin.UIPanelButtonTemplate(FriendsListFrame.RIDWarning:GetChildren()) -- ContinueButton
    end
    if FriendsListFrame and FriendsListFrame.ScrollBox then
        Skin.WowScrollBoxList(FriendsListFrame.ScrollBox)
    end
    if FriendsListFrame and FriendsListFrame.ScrollBar then
        Skin.MinimalScrollBar(FriendsListFrame.ScrollBar)
    end


    ----------------------
    -- IgnoreListWindow --
    ----------------------
    local IgnoreListWindow = FriendsFrame.IgnoreListWindow
    if IgnoreListWindow then
        if IgnoreListWindow.NineSlice then
            Skin.NineSlicePanelTemplate(IgnoreListWindow.NineSlice)
        end
        if IgnoreListWindow.ScrollBox then
            Skin.WowScrollBoxList(IgnoreListWindow.ScrollBox)
        end
        if IgnoreListWindow.ScrollBar then
            Skin.MinimalScrollBar(IgnoreListWindow.ScrollBar)
        end
        if IgnoreListWindow.CloseButton then
            Skin.UIPanelCloseButton(IgnoreListWindow.CloseButton)
        end
        if IgnoreListWindow.UnignorePlayerButton then
            Skin.MagicButtonTemplate(IgnoreListWindow.UnignorePlayerButton)
        end
    end
    -- FIXLATER - it is a bit dark,....

    -----------------------
    -- RecentAlliesFrame --
    -----------------------
    local RecentAlliesFrame = _G.RecentAlliesFrame
    if RecentAlliesFrame and RecentAlliesFrame.List then
        local ScrollBox = RecentAlliesFrame.List.ScrollBox
        local ScrollBar = RecentAlliesFrame.List.ScrollBar
        if ScrollBox then
            Skin.WowScrollBoxList(ScrollBox)
        end
        if ScrollBar then
            Skin.MinimalScrollBar(ScrollBar)
        end
    end

    --------------
    -- WhoFrame --
    --------------
    local WhoFrame = _G.WhoFrame
    if _G.WhoFrameListInset then
        Skin.InsetFrameTemplate(_G.WhoFrameListInset)
    end
    if _G.WhoFrameColumnHeader1 then
        Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader1)
    end
    if _G.WhoFrameColumnHeader2 then
        Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader2)
    end

    -- FIXLATER
    if _G.WhoFrameDropdown then
        Skin.DropdownButton(_G.WhoFrameDropdown)
    end
    -- _G.WhoFrameDropdownHighlightTexture:SetAlpha(0)
    if _G.WhoFrameColumnHeader3 then
        Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader3)
    end
    if _G.WhoFrameColumnHeader4 then
        Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader4)
    end

    if _G.WhoFrameGroupInviteButton then
        Skin.FriendsFrameButtonTemplate(_G.WhoFrameGroupInviteButton)
        _G.WhoFrameGroupInviteButton:SetPoint("BOTTOMRIGHT", -5, 5)
    end
    if _G.WhoFrameAddFriendButton then
        Skin.MagicButtonTemplate(_G.WhoFrameAddFriendButton)
        _G.WhoFrameAddFriendButton:ClearAllPoints()
    end
    if _G.WhoFrameWhoButton then
        Skin.MagicButtonTemplate(_G.WhoFrameWhoButton)
        _G.WhoFrameWhoButton:ClearAllPoints()
        _G.WhoFrameWhoButton:SetPoint("BOTTOMLEFT", 5, 5)
    end
    if _G.WhoFrameAddFriendButton and _G.WhoFrameWhoButton then
        _G.WhoFrameAddFriendButton:SetPoint("BOTTOMLEFT", _G.WhoFrameWhoButton, "BOTTOMRIGHT", 1, 0)
    end
    if _G.WhoFrameAddFriendButton and _G.WhoFrameGroupInviteButton then
        _G.WhoFrameAddFriendButton:SetPoint("BOTTOMRIGHT", _G.WhoFrameGroupInviteButton, "BOTTOMLEFT", -1, 0)
    end

    if _G.WhoFrameEditBox and _G.WhoFrameWhoButton and _G.WhoFrameGroupInviteButton then
        Skin.FrameTypeEditBox(_G.WhoFrameEditBox)
        _G.WhoFrameEditBox:ClearAllPoints()
        _G.WhoFrameEditBox:SetPoint("BOTTOMLEFT", _G.WhoFrameWhoButton, "TOPLEFT", 2, -2)
        _G.WhoFrameEditBox:SetPoint("BOTTOMRIGHT", _G.WhoFrameGroupInviteButton, "TOPRIGHT", -2, -2)
        _G.WhoFrameEditBox:SetBackdropOption("offsets", {
            left = -2,
            right = -2,
            top = 7,
            bottom = 7,
        })
    end

    if WhoFrame and WhoFrame.ScrollBox then
        Skin.WowScrollBoxList(WhoFrame.ScrollBox)
    end
    if WhoFrame and WhoFrame.ScrollBar then
        Skin.MinimalScrollBar(WhoFrame.ScrollBar)
    end

    -----------------
    -- Guild Frame --
    -----------------
    local GuildFrame = _G.GuildFrame
    if GuildFrame then
        -- Skin tabs
        if _G.GuildFrameTab1 then Skin.FriendsFrameTabTemplate(_G.GuildFrameTab1) end
        if _G.GuildFrameTab2 then Skin.FriendsFrameTabTemplate(_G.GuildFrameTab2) end

        -- Skin Buttons
        if _G.GuildFrameAddMemberButton then Skin.FriendsFrameButtonTemplate(_G.GuildFrameAddMemberButton) end
        if _G.GuildFrameGuildControlButton then Skin.FriendsFrameButtonTemplate(_G.GuildFrameGuildControlButton) end
        if _G.GuildRosterViewOfflineButton then Skin.UICheckButtonTemplate(_G.GuildRosterViewOfflineButton) end

        -- Skin Dropdown for filtering
        if _G.GuildRosterDropdown then Skin.DropdownButton(_G.GuildRosterDropdown) end

        -- Skin Column Headers
        if _G.GuildFrameColumnHeader1 then Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameColumnHeader1) end
        if _G.GuildFrameColumnHeader2 then Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameColumnHeader2) end
        if _G.GuildFrameColumnHeader3 then Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameColumnHeader3) end
        if _G.GuildFrameColumnHeader4 then Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameColumnHeader4) end
        if _G.GuildFrameColumnHeader5 then Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameColumnHeader5) end
    end

    ----------------------
    -- FriendsFrameMisc --
    ----------------------
    if _G.FriendsFrameTab1 then Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab1) end
    if _G.FriendsFrameTab2 then Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab2) end
    if _G.FriendsFrameTab3 then Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab3) end
    if _G.FriendsFrameTab4 then Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab4) end
    Util.PositionRelative("TOPLEFT", FriendsFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.FriendsFrameTab1,
        _G.FriendsFrameTab2,
        _G.FriendsFrameTab3,
        _G.FriendsFrameTab4,
    })

    if not private.disabled.tooltips then
        Skin.FrameTypeFrame(_G.FriendsTooltip)
    end

    --------------------
    -- AddFriendFrame --
    --------------------
    local AddFriendFrame = _G.AddFriendFrame
    if AddFriendFrame and AddFriendFrame.Border then
        Skin.DialogBorderTemplate(AddFriendFrame.Border)
    end
    if _G.AddFriendInfoFrame and _G.AddFriendInfoFrame.ContinueButton then
        Skin.FrameTypeButton(_G.AddFriendInfoFrame.ContinueButton)
    end
    if _G.AddFriendEntryFrameInfoButton then
        Skin.UIPanelInfoButton(_G.AddFriendEntryFrameInfoButton)
    end
    do -- AddFriendNameEditBox
        if _G.AddFriendNameEditBox then
            Skin.FrameTypeEditBox(_G.AddFriendNameEditBox)
            if _G.AddFriendNameEditBoxLeft then _G.AddFriendNameEditBoxLeft:Hide() end
            if _G.AddFriendNameEditBoxRight then _G.AddFriendNameEditBoxRight:Hide() end
            if _G.AddFriendNameEditBoxMiddle then _G.AddFriendNameEditBoxMiddle:Hide() end
        end
    end
    if AddFriendFrame and AddFriendFrame.CloseButton then
        Skin.UIPanelCloseButton(AddFriendFrame.CloseButton)
    end
    Skin.UIPanelButtonTemplate(_G.AddFriendEntryFrameAcceptButton)
    Skin.UIPanelButtonTemplate(_G.AddFriendEntryFrameCancelButton)
    -------------------------
    -- FriendsFriendsFrame --
    -------------------------
    local FriendsFriendsFrame = _G.FriendsFriendsFrame
    Skin.DialogBorderTemplate(FriendsFriendsFrame.Border)
    -- FIXLATER
    -- FriendsFriendsFrameDropdown:Enable(); FriendsFriendsFrameDropdown:GenerateMenu();
    -- Skin.DropdownButton(_G.FriendsFriendsFrameDropdown)
    Util.HideNineSlice(FriendsFriendsFrame.ScrollFrameBorder)
    Skin.WowScrollBoxList(FriendsFriendsFrame.ScrollBox)
    Skin.MinimalScrollBar(FriendsFriendsFrame.ScrollBar)
    Skin.UIPanelButtonTemplate(FriendsFriendsFrame.SendRequestButton)
    Skin.UIPanelButtonTemplate(FriendsFriendsFrame.CloseButton)

    --------------------------
    -- BattleTagInviteFrame --
    --------------------------
    Skin.DialogBorderTemplate(_G.BattleTagInviteFrame.Border)

    local _, send, cancel = _G.BattleTagInviteFrame:GetChildren()
    Skin.UIPanelButtonTemplate(send)
    Skin.UIPanelButtonTemplate(cancel)
end
