local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local LAB = (categories.FACTORY * categories.TECH2)
local Factory = import('/lua/editor/UnitCountBuildConditions.lua').HaveGreaterThanUnitsWithCategory

local EngineerProductionT3 = function(self, aiBrain, builderManager)
    if Factory(aiBrain,  12, LAB)  then 
        return 130
    elseif Factory(aiBrain,  0, categories.GATE) then
        return 135
    else
        return 0
    end
end


BuilderGroup {
    BuilderGroupName = 'SCTAAIT3Builder',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SCTAAi FactoryT3 HoverTank',
        PlatoonTemplate = 'T3LandHOVERSCTA',
        Priority = 138,
        BuilderConditions = {
            { UCBC, 'HaveUnitRatio', { 0.6, categories.LAND * categories.DIRECTFIRE * categories.TECH3 - categories.SCOUT,
            '<=', categories.LAND * categories.MOBILE * categories.TECH3 - categories.ENGINEER } }, -- Don't make tanks if we have lots of them.
            { TAutils, 'EcoManagementTA', { 0.9, 0.5, 0.5, 0.5, } },
        },
        BuilderType = 'Hover',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT3 Artillery',
        PlatoonTemplate = 'T3HOVERMISSILESCTA', 
        Priority = 126,
        InstanceCount = 1,
        BuilderConditions = {
        { UCBC, 'HaveUnitRatio', { 0.2, categories.LAND * categories.TECH3 * categories.SILO * categories.MOBILE - categories.ANTIAIR,
        '<=', categories.MOBILE * categories.LAND * categories.TECH3 - categories.ENGINEER } }, -- Don't make tanks if we have lots of them. },
        { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.25}},
    },
        BuilderType = 'Hover',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT3 AntiAir',
        PlatoonTemplate = 'T3HOVERAASCTA',
        Priority = 133,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'HaveUnitRatio', { 0.2, categories.LAND * categories.ANTIAIR * categories.MOBILE * categories.TECH3,
                                       '<', categories.LAND  * categories.MOBILE * categories.TECH3 - categories.ENGINEER } },
         { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.25}},
        },
        BuilderType = 'Hover',
    },
    Builder {
        BuilderName = 'SCTAAI Factory Seaplane Fighter',
        PlatoonTemplate = 'T3AirFighterSCTA',
        Priority = 140,
        BuilderConditions = { -- Only make inties if the enemy air is strong.
        { TAutils, 'EcoManagementTA', { 0.5, 0.9, 0.5, 0.5, } },
        },
        BuilderType = 'Seaplane',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT3 Engineer',
        PlatoonTemplate = 'T3BuildEngineerSCTA',
        Priority = 120, -- Top factory priority
        PriorityFunction = EngineerProductionT3,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENGINEER * categories.TECH3 * categories.HOVER} }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'SpecHover',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT3 Engineer Air',
        PlatoonTemplate = 'T3BuildEngineerAirSCTA',
        Priority = 125, -- Top factory priority
        PriorityFunction = EngineerProductionT3,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENGINEER * categories.TECH3 * categories.AIR} }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'SpecAir',
    },
}