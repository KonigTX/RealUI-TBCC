local _, private = ...

-- RealUI --
local RealUI = private.RealUI
local db

local MODNAME = "Objectives Adv."
local ObjectivesAdv = RealUI:NewModule(MODNAME, "AceEvent-3.0")
local CombatFader = RealUI:GetModule("CombatFader")

---------------------
-- Collapse / Hide --
---------------------
local function ResetState()
    -- TBCC: ObjectiveTrackerFrame may not exist in TBCC, use QuestWatchFrame instead
    local trackerFrame = _G.ObjectiveTrackerFrame or _G.QuestWatchFrame
    if not trackerFrame then return end

    if ObjectivesAdv.hidden and trackerFrame.realUIHidden then
        ObjectivesAdv.hidden = false
        trackerFrame.realUIHidden = false
        trackerFrame:Show()
        -- Refresh fade, since fade won't update while hidden
        if RealUI:GetModuleEnabled("CombatFader") then
            CombatFader:UpdateStatus(true)
        end
    end

    -- TBCC: These tracker frames don't exist in TBCC, wrap with existence checks
    if ObjectivesAdv.collapsed then
        ObjectivesAdv.collapsed = false
        if _G.QuestObjectiveTracker and _G.QuestObjectiveTracker.userCollapsed then
            _G.QuestObjectiveTracker:SetCollapsed(false)
        end
        if _G.CampaignQuestObjectiveTracker and _G.CampaignQuestObjectiveTracker.userCollapsed then
            _G.CampaignQuestObjectiveTracker:SetCollapsed(false)
        end
        if _G.AdventureObjectiveTracker and _G.AdventureObjectiveTracker.userCollapsed then
            _G.AdventureObjectiveTracker:SetCollapsed(false)
        end
        if _G.ProfessionsRecipeTracker and _G.ProfessionsRecipeTracker.userCollapsed then
            _G.ProfessionsRecipeTracker:SetCollapsed(false)
        end
        if _G.BonusObjectiveTracker and _G.BonusObjectiveTracker.userCollapsed then
            _G.BonusObjectiveTracker:SetCollapsed(false)
        end
        if _G.WorldQuestObjectiveTracker and _G.WorldQuestObjectiveTracker.userCollapsed then
            _G.WorldQuestObjectiveTracker:SetCollapsed(false)
        end
    end
end
function ObjectivesAdv:UpdateState()
    ResetState()

    local _, instanceType = _G.GetInstanceInfo()
    if not db.hidden.enabled or instanceType == "none" then return end
    -- TBCC: C_Garrison doesn't exist in TBCC
    if _G.C_Garrison and _G.C_Garrison.IsOnGarrisonMap and _G.C_Garrison.IsOnGarrisonMap() then return end

    -- TBCC: Use QuestWatchFrame as fallback for ObjectiveTrackerFrame
    local trackerFrame = _G.ObjectiveTrackerFrame or _G.QuestWatchFrame
    if not trackerFrame then return end

    local hide = db.hidden.hide[instanceType] or false
    local collapse = db.hidden.collapse[instanceType] or false
    if hide then
        self.hidden = true
        trackerFrame.realUIHidden = true
        trackerFrame:Hide()
    elseif collapse then
        self.collapsed = true
        -- TBCC: Only collapse trackers that exist
        if db.hidden.collapseframe["quest"] == true and _G.QuestObjectiveTracker then
            _G.QuestObjectiveTracker.userCollapsed = true
            _G.QuestObjectiveTracker:SetCollapsed(true)
        end
        if db.hidden.collapseframe["campaign"] == true and _G.CampaignQuestObjectiveTracker then
            _G.CampaignQuestObjectiveTracker.userCollapsed = true
            _G.CampaignQuestObjectiveTracker:SetCollapsed(true)
        end
        if db.hidden.collapseframe["adventure"] == true and _G.AdventureObjectiveTracker then
            _G.AdventureObjectiveTracker.userCollapsed = true
            _G.AdventureObjectiveTracker:SetCollapsed(true)
        end
        if db.hidden.collapseframe["proffesion"] == true and _G.ProfessionsRecipeTracker then
            _G.ProfessionsRecipeTracker.userCollapsed = true
            _G.ProfessionsRecipeTracker:SetCollapsed(true)
        end
        if db.hidden.collapseframe["bonus"] == true and _G.BonusObjectiveTracker then
            _G.BonusObjectiveTracker.userCollapsed = true
            _G.BonusObjectiveTracker:SetCollapsed(true)
        end
        if db.hidden.collapseframe["world"] == true and _G.WorldQuestObjectiveTracker then
            _G.WorldQuestObjectiveTracker.userCollapsed = true
            _G.WorldQuestObjectiveTracker:SetCollapsed(true)
        end
    end
end

------------------
---- Position ----
------------------
-- Position
local movingTracker = false
local function UpdatePosition()
    if movingTracker then return end

    -- TBCC: Use QuestWatchFrame as fallback for ObjectiveTrackerFrame
    local trackerFrame = _G.ObjectiveTrackerFrame or _G.QuestWatchFrame
    if not trackerFrame then return end

    movingTracker = true
    trackerFrame:ClearAllPoints()
    trackerFrame:SetPoint(db.position.anchorfrom, "UIParent", db.position.anchorto, db.position.x, db.position.y)
    trackerFrame:SetHeight(_G.UIParent:GetHeight() - db.position.negheightofs)
    movingTracker = false
end


-----------------------
function ObjectivesAdv:UI_SCALE_CHANGED()
    UpdatePosition()
end

function ObjectivesAdv:PLAYER_ENTERING_WORLD()
    if not RealUI:GetModuleEnabled(MODNAME) then return end
    self:UpdateState()
end

function ObjectivesAdv:ADDON_LOADED()
    -- TBCC: Use QuestWatchFrame as fallback for ObjectiveTrackerFrame
    local trackerFrame = _G.ObjectiveTrackerFrame or _G.QuestWatchFrame
    if trackerFrame then
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        self:RegisterEvent("UI_SCALE_CHANGED")
        self:UnregisterEvent("ADDON_LOADED")

        _G.hooksecurefunc(trackerFrame, "SetPoint", UpdatePosition)
        CombatFader:RegisterFrameForFade(MODNAME, trackerFrame)

        self:RefreshMod()
    end
end

function ObjectivesAdv:RefreshMod()
    if not RealUI:GetModuleEnabled(MODNAME) then return end
    db = self.db.profile
    UpdatePosition()
end

function ObjectivesAdv:OnInitialize()
    self.db = RealUI.db:RegisterNamespace(MODNAME)
    self.db:RegisterDefaults({
        profile = {
            position = {
                enabled = true,
                anchorto = "TOPRIGHT",
                anchorfrom = "TOPRIGHT",
                x = -32,
                y = -200,
                negheightofs = 300,
            },
            hidden = {
                enabled = true,
                collapse = {
                    pvp = true,
                    arena = false,
                    scenario = false,
                    party = true,
                    raid = false,
                    dvelve = false,
                },
                collapseframe = {
                    quest = true,
                    campaign = true,
                    adventure = true,
                    proffesion = true,
                    bonus = true,
                    world = true,
                },
                hide = {
                    pvp = false,
                    arena = true,
                    scenario = false,
                    party = false,
                    raid = true,
                },
                combatfade = {
                    enabled = true,
                    opacity = {
                        incombat = 0.25,
                        hurt = .75,
                        target = .75,
                        harmtarget = 0.85,
                        outofcombat = 1,
                    },
                },
            },
        },
    })
    db = self.db.profile

    self:SetEnabledState(RealUI:GetModuleEnabled(MODNAME))
end

function ObjectivesAdv:OnEnable()
    CombatFader:RegisterModForFade(MODNAME, "profile", "hidden", "combatfade")

    -- TBCC: Use QuestWatchFrame as fallback for ObjectiveTrackerFrame
    local trackerFrame = _G.ObjectiveTrackerFrame or _G.QuestWatchFrame
    if not trackerFrame then
        self:RegisterEvent("ADDON_LOADED")
    else
        self:ADDON_LOADED()
    end
end

function ObjectivesAdv:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("UI_SCALE_CHANGED")
end
