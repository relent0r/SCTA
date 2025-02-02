--[[
    File    :   /lua/AI/PlattonTemplates/SCTAAITemplates.lua
    Author  :   SoftNoob
    Summary :
        Responsible for defining a mapping from AIBuilders keys -> Plans (Plans === platoon.lua functions)
]]
RAIDAIR = (categories.armfig + categories.corveng + categories.GROUNDATTACK)
RAIDER = (categories.armpw + categories.corak + categories.armflash + categories.corgator)
SPECIAL = (RAIDER + categories.EXPERIMENTAL + categories.ENGINEER + categories.SCOUT + categories.BOMB)
GROUND = (categories.MOBILE * categories.LAND - categories.TRANSPORTFOCUS)
RANGE = (categories.ARTILLERY + categories.SILO + categories.ANTIAIR + categories.SNIPER)

PlatoonTemplate {
    Name = 'T1LandScoutFormSCTA',
    Plan = 'ScoutingAISCTA',
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { GROUND * categories.SCOUT, 1, 1, 'Scout', 'none' },
    }
}

PlatoonTemplate {
    Name = 'StrikeForceSCTATerrain',
    Plan = 'SCTAArtyHuntAI', -- The platoon function to use.
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { ((categories.AMPHIBIOUS * GROUND) - SPECIAL - categories.coramph) + categories.BOMB, 1, 5,  'Attack', 'none' },
    },
}

PlatoonTemplate {
    Name = 'AttackForceSCTALaser',
    Plan = 'TAHunt', -- The platoon function to use.
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { ((GROUND * categories.ANTISHIELD) - categories.AMPHIBIOUS) - SPECIAL + categories.coramph, 2, 10, 'Artillery', 'none' }, 
        { categories.FIELDENGINEER, 0, 2, 'Guard', 'none' },
    },
}

PlatoonTemplate {
    Name = 'LABSCTA',
    Plan = 'HuntAILABSCTA', -- The platoon function to use.
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        {RAIDER + RAIDAIR + ((categories.AMPHIBIOUS + categories.HOVER) - SPECIAL - categories.NAVAL),
          1, -- Min number of units.
          1, -- Max number of units.
          'Attack', -- platoon ---PlatoonTypes: 'support', 'Attack', 'scout',
          'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

----Aggressive Platoons.
----Primary 'Defense' Platoon Protect Bases and Scout Around Mexes


---SCTA "Unique" Formations

PlatoonTemplate {
    Name = 'StrikeForceSCTAHover',
    Plan = 'TAHunt', -- The platoon function to use.
    ---PlatoonType = 'LandForm',
    GlobalSquads = {
        { ((GROUND * (categories.HOVER + categories.AMPHIBIOUS)) - SPECIAL) + categories.BOMB, 2, 10, 'Artillery', 'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

PlatoonTemplate {
    Name = 'LandRocketAttackSCTA',
    Plan = 'HuntSCTAAI',
    GlobalSquads = {
        { (GROUND * RANGE * categories.TECH1) - categories.AMPHIBIOUS, 2, 10, 'Artillery', 'none' },
    },
}




PlatoonTemplate {
    Name = 'StrikeForceSCTA',
    Plan = 'AttackForceSCTAAI',
    GlobalSquads = {
        { GROUND - SPECIAL - RANGE, 2, 20, 'Attack', 'none' },
        { (GROUND * categories.ANTIAIR) - categories.ANTISHIELD, 0, 10, 'Support', 'none' },
        { categories.FIELDENGINEER, 0, 2, 'Guard', 'none' },
    },
}


PlatoonTemplate {
    Name = 'T4ExperimentalSCTA',
    Plan = 'ExperimentalAIHubTA', 
    ---PlatoonType = 'CommandTA',
    GlobalSquads = {
        { (categories.EXPERIMENTAL * categories.MOBILE), 1, 1, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'SCTAExperimental',
    FactionSquads = {
        Arm = {
            { 'armdrake', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'corkrog', 1, 1, 'Attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T1LandScoutSCTA',
    FactionSquads = {
        Arm = {
            { 'armck', 1, 1, 'Support', 'None' },
            { 'armflea', 1, 1, 'Scout', 'none' },
        },
        Core = {
            { 'corcv', 1, 1, 'Support', 'None' },
            { 'corfav', 1, 1, 'Scout', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T3LandHOVERSCTA',
    FactionSquads = {
        Arm = {
            { 'armanac', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'corsnap', 1, 1, 'Attack', 'none' },
        },
    }
}


PlatoonTemplate {
    Name = 'T3HOVERAASCTA',
    FactionSquads = {
        Arm = {
            { 'armah', 1, 1, 'Attack', 'none' }
        },
        Core = {
            { 'corah', 1, 1, 'Attack', 'none' }
        },
    }
}

--[[PlatoonTemplate {
    Name = 'T3HOVERTransportSCTA',
    FactionSquads = {
        Arm = {
            { 'armthovr', 1, 1, 'Support', 'GrowthFormation' }
        },
        Core = {
            { 'corthovr', 1, 1, 'Support', 'GrowthFormation' }
        },
    }
}]]

PlatoonTemplate {
    Name = 'T3HOVERMISSILESCTA',
    FactionSquads = {
        Arm = {
            { 'armmh', 1, 1, 'Attack', 'none' },
            { 'armsh', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'cormh', 1, 1, 'Attack', 'none' },
            { 'corsh', 1, 1, 'Attack', 'none' },
        },
    }
}


