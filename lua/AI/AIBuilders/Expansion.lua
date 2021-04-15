#****************************************************************************
#**
#**  File     :  /lua/AI/AIBuilders/SorianExpansionBuilders.lua
#**
#**  Summary  : Builder definitions for expansion bases
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************


local BBTmplFile = '/lua/basetemplates.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local BuildingTmpl = 'BuildingTemplates'
local BaseTmpl = 'BaseTemplates'
local ExBaseTmpl = 'ExpansionBaseTemplates'
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local PlatoonFile = '/lua/platoon.lua'

local ExtractorToFactoryRatio = 3


BuilderGroup {
    BuilderGroupName = 'SCTAExpansionBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SCTA Start Marker',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 107,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'ExpansionStart', 2},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'ExpansionStart' }},
            { MIBC, 'GreaterThanGameTime', { 180 } },
            { UCBC, 'StartLocationNeedsEngineer', { 'LocationType', 1000, -1000, 1000, 1, 'StructuresNotMex' } },
            { TASlow, 'StartBaseCheck', { } }, -- related to ScenarioInfo.Options.LandExpansionsAllowed
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 0.5 } },
            { EBC, 'GreaterThanEconStorageCurrent', { 100, 500 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                NearMarkerType = 'Start Location',
                ExpansionRadius = 100, -- Defines the radius of the builder managers to avoid them intruding on another base if the expansion marker is too close
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1000,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                BuildStructures = {                    
                    'T1LandFactory',             
                }
            },
        }
    },
    Builder {
        BuilderName = 'SCTA Expansion Starter',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 96,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'ExpansionStart', 2},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'ExpansionStart' }},
            { UCBC, 'ExpansionAreaNeedsEngineer', { 'LocationType', 1000, -1000, 1000, 1, 'StructuresNotMex' } },
            { TASlow, 'ExpansionBaseCheck', { } }, 
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 0.5 } },
            { EBC, 'GreaterThanEconStorageCurrent', { 100, 500 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                NearMarkerType = 'Expansion Area',
                ExpansionRadius = 100, -- Defines the radius of the builder managers to avoid them intruding on another base if the expansion marker is too close
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1000,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                BuildStructures = {   
                    'T1LandFactory2',                 
                    'T1Radar',
                }
            },
        }
    },
    Builder {
        BuilderName = 'SCTA Expansion Starter Late',
        PlatoonTemplate = 'EngineerBuilderSCTA123',
        Priority = 99,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'ExpansionStart', 2},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'ExpansionStart' }},
            { MIBC, 'GreaterThanGameTime', {720} },
            { UCBC, 'ExpansionAreaNeedsEngineer', { 'LocationType', 1000, -1000, 1000, 1, 'StructuresNotMex' } },
            { TASlow, 'ExpansionBaseCheck', { } }, 
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 0.5 } },
            { EBC, 'GreaterThanEconStorageCurrent', { 100, 500 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                    BuildClose = false,
                    BaseTemplate = ExBaseTmpl,
                    ExpansionBase = true,
                    NearMarkerType = 'Expansion Area',
                    ExpansionRadius = 100, -- Defines the radius of the builder managers to avoid them intruding on another base if the expansion marker is too close
                    LocationRadius = 1000,
                    LocationType = 'LocationType',
                    ThreatMin = -1000,
                    ThreatMax = 1000,
                    ThreatRings = 2,
                    ThreatType = 'AntiSurface',
                    BuildStructures = {   
                        'T2LandFactory',                 
                        'T1Radar',
                }
            },
        }
    },
    Builder {
        BuilderName = 'SCTA Start Marker Late',
        PlatoonTemplate = 'EngineerBuilderSCTA123',
        Priority = 104,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'ExpansionStart', 2},
        BuilderConditions = {
            { MIBC, 'GreaterThanGameTime', {720} },
            { UCBC, 'StartLocationNeedsEngineer', { 'LocationType', 1000, -1000, 1000, 1, 'StructuresNotMex' } },
            { UCBC, 'CheckBuildPlattonDelay', { 'ExpansionStart' }},
            { TASlow, 'StartBaseCheck', { } }, -- related to ScenarioInfo.Options.LandExpansionsAllowed
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.2}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                NearMarkerType = 'Start Location',
                ExpansionRadius = 100,-- Defines the radius of the builder managers to avoid them intruding on another base if the expansion marker is too close
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1000,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                BuildStructures = {                    
                    'T2LandFactory2',
                }
            },
        }
    },
    Builder {
        BuilderName = 'SCTA ACU Naval',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 120,
        InstanceCount = 1,
        BuilderConditions = {
            { MIBC, 'GreaterThanGameTime', {180} },
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 1000, -1000, 1000, 1, 'Naval' } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY * categories.NAVAL} },
            { UCBC, 'NavalBaseCheck', { } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BaseTemplateFile = '/mods/SCTA-master/lua/AI/TAMiscBaseTemplates/NavalBaseTemplates.lua',
                BaseTemplate = 'NavalBaseTemplates',
                ExpansionBase = true,
                NearMarkerType = 'Naval Area',
                ExpansionRadius = 25, -- Defines the radius of the builder managers to avoid them intruding on another base if the expansion marker is too close
                LocationRadius = 200,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1000,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                BuildStructures = {                    
                    'T1SeaFactory',
                }
            },
        }
    },
    Builder {
        BuilderName = 'SCTA Naval Expansions',
        PlatoonTemplate = 'EngineerBuilderSCTANaval',
        Priority = 251,
        InstanceCount = 2,
        DelayEqualBuildPlattons = {'NavalStart', 2},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'NavalStart' }},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, categories.NAVAL * categories.FACTORY, 'Enemy'}},
            { UCBC, 'NavalBaseCheck', { } }, -- related to ScenarioInfo.Options.NavalExpansionsAllowed
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 1000, -1000, 1000, 1, 'Naval' } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 0.5 } },
            { EBC, 'GreaterThanEconStorageCurrent', { 100, 500 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BaseTemplateFile = '/mods/SCTA-master/lua/AI/TAMiscBaseTemplates/NavalBaseTemplates.lua',
                BaseTemplate = 'NavalBaseTemplates',
                ExpansionBase = true,
                NearMarkerType = 'Naval Area',
                ExpansionRadius = 25, -- Defines the radius of the builder managers to avoid them intruding on another base if the expansion marker is too close
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1000,
                ThreatRings = 2,
                ThreatType = 'Naval',
                BuildStructures = {                    
                    'T1SeaFactory',
                }
            },
        }
    },
} 