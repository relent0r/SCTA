local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')
local BOMBER = (categories.MOBILE * categories.AIR - categories.SCOUT - categories.BOMBER)

BuilderGroup {
    BuilderGroupName = 'SCTAAIAirBuilder',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SCTAAI Factory Stealth',
        PlatoonTemplate = 'T2AirFighterSCTA',
        Priority = 115,
        PriorityFunction = TAPrior.TechEnergyExist,
        BuilderConditions = { -- Only make inties if the enemy air is strong.
        { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAI Factory Gunship',
        PlatoonTemplate = 'T2GunshipSCTA',
        Priority = 115,
        PriorityFunction = TAPrior.TechEnergyExist,
        BuilderConditions = {
            { TASlow, 'TAHaveUnitsWithCategoryAndAllianceFalse', {0, BOMBER, 'Enemy'}},
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAI Factory Intie',
        PlatoonTemplate = 'T1AirFighterSCTA',
        PriorityFunction = TAPrior.AirProduction,
        Priority = 90,
        BuilderConditions = { -- Only make inties if the enemy air is strong
        { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Air',
    },  
    Builder {
        BuilderName = 'SCTAAI Factory Strategic',
        PlatoonTemplate = 'T3AirBomberSCTA',
        Priority = 150,
        InstanceCount = 1,
        PriorityFunction = TAPrior.ProductionT3Air,
        BuilderConditions = {
            { TASlow, 'TAHaveUnitsWithCategoryAndAllianceFalse', {0, BOMBER, 'Enemy'}},
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAI Factory Bomber',
        PlatoonTemplate = 'T1AirBomberSCTA',
        Priority = 90,
        PriorityFunction = TAPrior.AirProduction,
        BuilderConditions = {
            { TASlow, 'TAHaveUnitsWithCategoryAndAllianceFalse', {0, BOMBER, 'Enemy'}},
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAirTransport',
        PlatoonTemplate = 'SCTATransport',
        Priority = 50,
        InstanceCount = 2,
        BuilderConditions = {
            { MIBC, 'ArmyNeedsTransports', {} },
            { TASlow, 'HaveLessThanUnitsWithCategoryTA', { 2, categories.TRANSPORTFOCUS} },
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Air',
    },     
    Builder {
        BuilderName = 'SCTA Torpedos Bomber T2',
        PlatoonTemplate = 'SCTATorpedosBomber',
        PriorityFunction = TAPrior.NavalProduction,
        Priority = 50,
        InstanceCount = 2,
        BuilderConditions = {
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Air',
    },     
}