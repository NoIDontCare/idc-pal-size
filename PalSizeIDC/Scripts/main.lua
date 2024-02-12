local PalUtility = nil

local config = require("./config")
local changePartyPals = config["ChangePartyPals"]
local changeBasePals = config["ChangeBasePals"]
local changeWildPals = config["ChangeWildPals"]

---@return UPalUtility
function GetPalUtility()
    if PalUtility == nil or not PalUtility:IsValid() then
        PalUtility = StaticFindObject("/Script/Pal.Default__PalUtility")
    end
    
    return PalUtility
end 

RegisterHook("/Script/Pal.PalCharacterParameterComponent:OnInitialize_AfterSetIndividualParameter", function(Context, Character)
    local PalUtil = GetPalUtility()
    local PalID = PalUtil:GetCharacterIDFromCharacter(Character:get())
    local IsBaseCampPal = PalUtil:IsBaseCampPal(Character:get())
    local IsWildPal = PalUtil:IsWildNPC(Character:get())

    if (changeBasePals == false and changeWildPals == false) then
        return
    end

    if (changeBasePals == true and IsBaseCampPal == true) then
        if (config[PalID:ToString()] ~= nil) then
            local scale = config[PalID:ToString()]
            Character:get():SetActorScale3D({X = scale, Y = scale, Z = scale})
        end
    end

    if (changeWildPals == true and IsWildPal == true) then
        if (config[PalID:ToString()] ~= nil) then
            local scale = config[PalID:ToString()]
            Character:get():SetActorScale3D({X = scale, Y = scale, Z = scale})
        end
    end
end)

-- Modified version of the script found here: https://pwmodding.wiki/docs/lua-modding/hooking-functions
RegisterHook("/Script/Engine.PlayerController:ClientRestart", function (Context)
    local PalID
    NotifyOnNewObject("/Game/Pal/Blueprint/Component/OtomoHolder/BP_OtomoPalHolderComponent.BP_OtomoPalHolderComponent_C", function (Component)
        RegisterHook("/Game/Pal/Blueprint/Component/OtomoHolder/BP_OtomoPalHolderComponent.BP_OtomoPalHolderComponent_C:ActivateOtomo", function (self, SlotId)
            local HolderComponent = self:get()
            local OtomoActor = HolderComponent:TryGetOtomoActorBySlotIndex(SlotId:get())
            if (changePartyPals == true) then
                if (config[PalID:ToString()] ~= nil) then
                    local scale = config[PalID:ToString()]
                    OtomoActor:SetActorScale3D({X = scale, Y = scale, Z = scale})
                end
            end
        end)
    end)
    RegisterHook("/Game/Pal/Blueprint/Component/OtomoHolder/BP_OtomoPalHolderComponent.BP_OtomoPalHolderComponent_C:IncrementActiveOtomoCount", function(IAOCself, PRD, IAOCID)
        PalID = IAOCID:get()
    end)
end)