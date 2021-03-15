local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local SBC = '/lua/editor/SorianBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'SCTAAIEngineerBuilder',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SCTAAi Factory Engineer Early',
        PlatoonTemplate = 'T1BuildEngineerSCTAEarly',
        Priority = 150, -- Top factory priority
        BuilderConditions = {
            { MIBC, 'LessThanGameTime', {180} }, -- Don't make tanks if we have lots of them.
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT2 Engineer',
        PlatoonTemplate = 'T2BuildEngineerSCTA',
        Priority = 110, -- Top factory priority
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENGINEER * categories.LEVEL2 - categories.FIELDENGINEER } }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SCTAAi AirFactory Engineer',
        PlatoonTemplate = 'T1BuildEngineerAirSCTA',
        Priority = 105,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.ENGINEER * categories.AIR * categories.LEVEL1} }, -- Build engies until we have 4 of them.
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.5}}, 
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAi AirFactory Engineer2',
        PlatoonTemplate = 'T2BuildEngineerAirSCTA',
        Priority = 115,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.FUSION} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENGINEER * categories.AIR * categories.LEVEL2} }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'Air',
    }, 
    Builder {
        BuilderName = 'SCTAAi Factory Naval Engineer',
        PlatoonTemplate = 'T1EngineerSCTANaval',
        Priority = 120, -- Top factory priority
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENGINEER * categories.OCEAN - categories.COMMAND } }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi Factory Engineer',
        PlatoonTemplate = 'T1BuildEngineerSCTA',
        Priority = 100, -- Top factory priority
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, categories.ENGINEER * categories.LAND * categories.LEVEL1 - categories.COMMAND } }, -- Don't make tanks if we have lots of them.
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SCTAAi Field Engineer',
        PlatoonTemplate = 'T2BuildFieldEngineerSCTA',
        Priority = 95, -- Top factory priority
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.FIELDENGINEER * categories.LEVEL2} }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT3 Engineer',
        PlatoonTemplate = 'T3BuildEngineerSCTA',
        Priority = 120, -- Top factory priority
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENGINEER * categories.LEVEL3 - categories.FIELDENGINEER } }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'All',
    },
}

----needFigureOutMassEco and KnowingHowPauseFactoriesForAi