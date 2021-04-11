--[[
    File    :   /lua/AI/PlattonTemplates/SCTAAITemplates.lua
    Author  :   SoftNoob
    Summary :
        Responsible for defining a mapping from AIBuilders keys -> Plans (Plans === platoon.lua functions)
]]
local RAIDER = categories.armfig + categories.corveng + categories.armpw + categories.corak + categories.armflash + categories.corgator
local SPECIAL = RAIDER + categories.EXPERIMENTAL + categories.ENGINEER + categories.SCOUT
local GROUND = categories.MOBILE * categories.LAND
local TACATS = categories.ANTISHIELD + categories.AMPHIBIOUS

PlatoonTemplate {
    Name = 'AntiAirSCTA',
    Plan = 'SCTAAntiAirAI', -- The platoon function to use.
    GlobalSquads = {
        { GROUND * categories.ANTIAIR, 2, 10, 'attack', 'none' },
    },
}

PlatoonTemplate {
    Name = 'T1LandScoutFormSCTA',
    Plan = 'ScoutingAI',
    GlobalSquads = {
        { GROUND * categories.SCOUT * categories.TECH1 * categories.OVERLAYRADAR, 1, 1, 'scout', 'None' },
    }
}

PlatoonTemplate {
    Name = 'StrikeForceSCTA',
    Plan = 'SCTAStrikeForceAI', -- The platoon function to use.
    GlobalSquads = {
        { GROUND - SPECIAL - TACATS - categories.ARTILLERY - categories.ANTIAIR, 5, 20, 'attack', 'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

PlatoonTemplate {
    Name = 'StrikeForceSCTAEndgame',
    Plan = 'SCTAStrikeForceAI', -- The platoon function to use.
    GlobalSquads = {
        { GROUND - SPECIAL, 25, 50, 'attack', 'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

PlatoonTemplate {
    Name = 'LandAttackSCTAEndGame',
    Plan = 'AttackSCTAForceAI',
    GlobalSquads = {
        { GROUND - SPECIAL, 25, 50, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'StrikeForceSCTAMissiles',
    Plan = 'SCTAStrikeForceAI', -- The platoon function to use.
    GlobalSquads = {
        { GROUND * ( categories.SILO + categories.ARTILLERY) - TACATS, 5, 20, 'attack', 'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

PlatoonTemplate {
    Name = 'StrikeForceSCTALaser',
    Plan = 'SCTAStrikeForceAI', -- The platoon function to use.
    GlobalSquads = {
        { GROUND * categories.ANTISHIELD - categories.AMPHIBIOUS, -- Type of units.
          2, -- Min number of units.
          10, -- Max number of units.
          'attack', -- platoon types: 'support', 'attack', 'scout',
          'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

PlatoonTemplate {
    Name = 'StrikeForceSCTATerrain',
    Plan = 'AllTerrainAISCTA', -- The platoon function to use.
    GlobalSquads = {
        { categories.AMPHIBIOUS * categories.LAND - SPECIAL, -- Type of units.
          2, -- Min number of units.
          10, -- Max number of units.
          'attack', -- platoon types: 'support', 'attack', 'scout',
          'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

PlatoonTemplate {
    Name = 'LABSCTA',
    Plan = 'HuntAILABSCTA', -- The platoon function to use.
    GlobalSquads = {
        {RAIDER, -- Type of units.
          1, -- Min number of units.
          1, -- Max number of units.
          'attack', -- platoon types: 'support', 'attack', 'scout',
          'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}


PlatoonTemplate {
    Name = 'LandAttackSCTA',
    Plan = 'AttackSCTAForceAI',
    GlobalSquads = {
        { GROUND - SPECIAL - TACATS, 2, 20, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'GuardSCTA',
    Plan = 'None',
    GlobalSquads = {
        { GROUND - SPECIAL, 1, 2, 'guard', 'none' }
    },
}

PlatoonTemplate {
    Name = 'LandAttackSCTAEarly',
    Plan = 'SCTAStrikeForceAIEarly',
    GlobalSquads = {
        { GROUND * categories.TECH1 - SPECIAL, 2, 10, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'LandAttackSCTAMid',
    Plan = 'SCTAStrikeForceAI',
    GlobalSquads = {
        { GROUND - SPECIAL, 10, 20, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'LandRocketAttackSCTA',
    Plan = 'AttackSCTAForceAI',
    GlobalSquads = {
        { GROUND * (categories.SILO + categories.ARTILLERY) - SPECIAL, 2, 20, 'Attack', 'none' }
    },
}


PlatoonTemplate {
    Name = 'T4ExperimentalSCTA',
    Plan = 'ExperimentalAIHubSorian', 
    GlobalSquads = {
        { categories.EXPERIMENTAL * categories.MOBILE - categories.SUBCOMMANDER, 1, 1, 'attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'FabricationSCTA',
    Plan = 'PauseAI',
    GlobalSquads = {
        { categories.STRUCTURE * categories.MASSFABRICATION, 1, 1, 'support', 'none' },
    }
}

PlatoonTemplate {
    Name = 'SCTAIntel',
    Plan = 'PauseAI',
    GlobalSquads = {
        { categories.STRUCTURE * categories.OPTICS, 1, 1, 'support', 'none' },
    }
}

PlatoonTemplate {
    Name = 'SCTAExperimental',
    FactionSquads = {
        Arm = {
            { 'armdrake', 1, 1, 'attack', 'none' },
        },
        Core = {
            { 'corkrog', 1, 1, 'attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T3LandHOVERSCTA',
    FactionSquads = {
        Arm = {
            { 'armanac', 1, 2, 'attack', 'none' },
            { 'armah', 1, 1, 'attack', 'none' },
        },
        Core = {
            { 'corsnap', 1, 2, 'attack', 'none' },
            { 'corah', 1, 1, 'attack', 'none' },
        },
    }
}


PlatoonTemplate {
    Name = 'THOVERAASCTA',
    FactionSquads = {
        Arm = {
            { 'armah', 1, 1, 'attack', 'none' }
        },
        Core = {
            { 'corah', 1, 1, 'attack', 'none' }
        },
    }
}

PlatoonTemplate {
    Name = 'T3HOVERMISSILESCTA',
    FactionSquads = {
        Arm = {
            { 'armmh', 1, 2, 'attack', 'none' }
        },
        Core = {
            { 'cormh', 1, 2, 'attack', 'none' }
        },
    }
}


