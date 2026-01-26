local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\RecruitAFriendFrame.lua ]]
    Hook.RecruitAFriendRewardButtonWithCheckMixin = {}
    function Hook.RecruitAFriendRewardButtonWithCheckMixin:Setup(rewardInfo, tooltipRightAligned)
        if not rewardInfo.claimed and not rewardInfo.canClaim then
            self._auroraBorder:SetColorTexture(_G.SEPIA_COLOR:GetRGBA())
        else
            if rewardInfo.rewardType == _G.Enum.RafRewardType.GameTime then
                self._auroraBorder:SetColorTexture(_G.HEIRLOOM_BLUE_COLOR:GetRGBA())
            else
                self._auroraBorder:SetColorTexture(_G.EPIC_PURPLE_COLOR:GetRGBA())
            end
        end
    end

    Hook.RecruitAFriendRewardButtonWithFanfareMixin = {}
    function Hook.RecruitAFriendRewardButtonWithFanfareMixin:Setup(rewardInfo, tooltipRightAligned)
        if not rewardInfo.claimed and not rewardInfo.canClaim then
            self.IconBorder:SetAtlas("RecruitAFriend_ClaimPane_SepiaRing", true)
        else
            self.IconBorder:SetAtlas("RecruitAFriend_ClaimPane_GoldRing", true)
        end
    end
end

do --[[ FrameXML\RecruitAFriendFrame.xml ]]
    function Skin.RecruitAFriendRewardButtonTemplate(Button)
        Button._auroraBorder = Base.CropIcon(Button.Icon, Button)
        if Button.IconBorder then
            Button.IconBorder:Hide()
            Button._auroraBorder:SetColorTexture(_G.SEPIA_COLOR:GetRGBA())
        end
    end
    function Skin.RecruitAFriendRewardTemplate(Frame)
        Util.Mixin(Frame.Button, Hook.RecruitAFriendRewardButtonWithCheckMixin)
        Skin.RecruitAFriendRewardButtonTemplate(Frame.Button)
        Base.CropIcon(Frame.Button:GetHighlightTexture())
    end
end

function private.FrameXML.RecruitAFriendFrame()
    --------------------------------
    -- RecruitAFriendRewardsFrame --
    --------------------------------
    local RecruitAFriendRewardsFrame = _G.RecruitAFriendRewardsFrame
    if RecruitAFriendRewardsFrame then
        if RecruitAFriendRewardsFrame.Bracket_TopLeft then
            RecruitAFriendRewardsFrame.Bracket_TopLeft:Hide()
        end
        if RecruitAFriendRewardsFrame.Bracket_TopRight then
            RecruitAFriendRewardsFrame.Bracket_TopRight:Hide()
        end
        if RecruitAFriendRewardsFrame.Bracket_BottomRight then
            RecruitAFriendRewardsFrame.Bracket_BottomRight:Hide()
        end
        if RecruitAFriendRewardsFrame.Bracket_BottomLeft then
            RecruitAFriendRewardsFrame.Bracket_BottomLeft:Hide()
        end
        if RecruitAFriendRewardsFrame.Background then
            RecruitAFriendRewardsFrame.Background:SetTexture(nil)
            RecruitAFriendRewardsFrame.Background:SetColorTexture(Color.black.r, Color.black.g, Color.black.b, 0.75)
        end

        if RecruitAFriendRewardsFrame.rewardPool then
            Util.Mixin(RecruitAFriendRewardsFrame.rewardPool, Hook.ObjectPoolMixin)
            Hook.ObjectPoolMixin.Acquire(RecruitAFriendRewardsFrame.rewardPool)
        end

        if RecruitAFriendRewardsFrame.Border then
            Skin.DialogBorderNoCenterTemplate(RecruitAFriendRewardsFrame.Border)
            RecruitAFriendRewardsFrame.Border:SetBackdropOption("offsets", {
                left = 10,
                right = 10,
                top = 10,
                bottom = 10,
            })
        end
        if RecruitAFriendRewardsFrame.CloseButton then
            Skin.UIPanelCloseButton(RecruitAFriendRewardsFrame.CloseButton)
        end
    end


    ------------------------------------
    -- RecruitAFriendRecruitmentFrame --
    ------------------------------------
    local RecruitAFriendRecruitmentFrame = _G.RecruitAFriendRecruitmentFrame
    if RecruitAFriendRecruitmentFrame then
        if RecruitAFriendRecruitmentFrame.Border then
            Skin.DialogBorderTranslucentTemplate(RecruitAFriendRecruitmentFrame.Border)
        end
        if RecruitAFriendRecruitmentFrame.CloseButton then
            Skin.UIPanelCloseButton(RecruitAFriendRecruitmentFrame.CloseButton)
        end
        if RecruitAFriendRecruitmentFrame.GenerateOrCopyLinkButton then
            Skin.FriendsFrameButtonTemplate(RecruitAFriendRecruitmentFrame.GenerateOrCopyLinkButton)
        end
        if RecruitAFriendRecruitmentFrame.EditBox then
            Skin.InputBoxTemplate(RecruitAFriendRecruitmentFrame.EditBox)
        end
    end


    -------------------------
    -- RecruitAFriendFrame --
    -------------------------
    local RecruitAFriendFrame =_G.RecruitAFriendFrame
    if not RecruitAFriendFrame then return end

    local RewardClaiming = RecruitAFriendFrame.RewardClaiming
    if RewardClaiming then
        if RewardClaiming.Background then
            RewardClaiming.Background:Hide()
        end
        if RewardClaiming.Bracket_TopLeft then
            RewardClaiming.Bracket_TopLeft:Hide()
        end
        if RewardClaiming.Bracket_TopRight then
            RewardClaiming.Bracket_TopRight:Hide()
        end
        if RewardClaiming.Bracket_BottomRight then
            RewardClaiming.Bracket_BottomRight:Hide()
        end
        if RewardClaiming.Bracket_BottomLeft then
            RewardClaiming.Bracket_BottomLeft:Hide()
        end
    end

    local NextRewardButton = RewardClaiming and RewardClaiming.NextRewardButton
    if NextRewardButton then
        Skin.RecruitAFriendRewardButtonTemplate(NextRewardButton)
        Util.Mixin(NextRewardButton, Hook.RecruitAFriendRewardButtonWithFanfareMixin)
        NextRewardButton:ClearAllPoints()
        NextRewardButton:SetPoint("TOPLEFT", 21, -25)
        if NextRewardButton.CircleMask then
            NextRewardButton.CircleMask:Hide()
        end
        if NextRewardButton.IconBorder then
            NextRewardButton.IconBorder:Hide()
        end
    end

    if RewardClaiming and RewardClaiming.Inset then
        Skin.InsetFrameTemplate(RewardClaiming.Inset)
    end
    if RewardClaiming and RewardClaiming.ClaimOrViewRewardButton then
        Skin.FriendsFrameButtonTemplate(RewardClaiming.ClaimOrViewRewardButton)
    end

    if RecruitAFriendFrame.RecruitmentButton then
        Skin.FriendsFrameButtonTemplate(RecruitAFriendFrame.RecruitmentButton)
    end
    local RecruitList = RecruitAFriendFrame.RecruitList
    if RecruitList then
        if RecruitList.Header and RecruitList.Header.Background then
            RecruitList.Header.Background:Hide()
        end
        if RecruitList.ScrollFrameInset then
            Skin.InsetFrameTemplate(RecruitList.ScrollFrameInset)
        end
        if RecruitList.ScrollBox and Skin.WowScrollBoxList then
            Skin.WowScrollBoxList(RecruitList.ScrollBox)
        end
        if RecruitList.ScrollBar and Skin.MinimalScrollBar then
            Skin.MinimalScrollBar(RecruitList.ScrollBar)
        end
    end

    -- /run RecruitAFriendFrame:ShowSplashScreen()
    local SplashFrame = RecruitAFriendFrame.SplashFrame
    if SplashFrame then
        if SplashFrame.OKButton then
            Skin.FriendsFrameButtonTemplate(SplashFrame.OKButton)
        end
        if SplashFrame.Background then
            SplashFrame.Background:SetColorTexture(Color.frame.r, Color.frame.g, Color.frame.b, 0.9)
        end
        if SplashFrame.PictureFrame then
            SplashFrame.PictureFrame:Hide()
        end

        if SplashFrame.Bracket_TopLeft then
            SplashFrame.Bracket_TopLeft:Hide()
        end
        if SplashFrame.Bracket_TopRight then
            SplashFrame.Bracket_TopRight:Hide()
        end
        if SplashFrame.Bracket_BottomRight then
            SplashFrame.Bracket_BottomRight:Hide()
        end
        if SplashFrame.Bracket_BottomLeft then
            SplashFrame.Bracket_BottomLeft:Hide()
        end
        if SplashFrame.PictureFrame_Bracket_TopLeft then
            SplashFrame.PictureFrame_Bracket_TopLeft:Hide()
        end
        if SplashFrame.PictureFrame_Bracket_TopRight then
            SplashFrame.PictureFrame_Bracket_TopRight:Hide()
        end
        if SplashFrame.PictureFrame_Bracket_BottomRight then
            SplashFrame.PictureFrame_Bracket_BottomRight:Hide()
        end
        if SplashFrame.PictureFrame_Bracket_BottomLeft then
            SplashFrame.PictureFrame_Bracket_BottomLeft:Hide()
        end
    end
end
