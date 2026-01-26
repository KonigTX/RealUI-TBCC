local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.QuickJoin()
    local QuickJoinFrame = _G.QuickJoinFrame
    if not QuickJoinFrame then return end
    if QuickJoinFrame.ScrollBox and Skin.WowScrollBoxList then
        Skin.WowScrollBoxList(QuickJoinFrame.ScrollBox)
    end
    if QuickJoinFrame.ScrollBar and Skin.MinimalScrollBar then
        Skin.MinimalScrollBar(QuickJoinFrame.ScrollBar)
    end
    if QuickJoinFrame.JoinQueueButton and Skin.MagicButtonTemplate then
        Skin.MagicButtonTemplate(QuickJoinFrame.JoinQueueButton)
    end
end
