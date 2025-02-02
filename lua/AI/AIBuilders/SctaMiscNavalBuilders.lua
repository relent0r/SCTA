local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MABC = '/lua/editor/MarkerBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
LAB = (categories.FACTORY * categories.TECH2)
TIDAL = (categories.cortide + categories.armtide)
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

BuilderGroup {
    BuilderGroupName = 'SCTAAIEngineerNavalMiscBuilder',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SCTA T1 Naval Factory Builder',
        PlatoonTemplate = 'EngineerBuilderSCTANaval',
        PriorityFunction = TAPrior.NavalProduction,
       ---PriorityFunction = TAPrior.UnitProductionT1,
        Priority = 100,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'FactoryNavy', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'FactoryNavy' }},
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Sea' } },
            { TASlow,   'TAAttackNaval', {true}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.FACTORY * categories.NAVAL} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildStructures = {
                    'T1SeaFactory',
                },
            },
        },
    },
    Builder {
        BuilderName = 'SCTAAI T2NavalEarly Factory',
        PlatoonTemplate = 'EngineerBuilderSCTANaval',
        PriorityFunction = TAPrior.UnitProduction,
        Priority = 125,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory', 1},
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 3, LAB} },
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory' }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, LAB * categories.NAVAL} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, LAB * categories.NAVAL } }, -- Stop after 10 facs have been built.
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                    BuildStructures = {
                    'T2SeaFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T2Naval Factory',
        PlatoonTemplate = 'EngineerBuilderSCTANaval',
        PriorityFunction = TAPrior.NavalProductionT2,
        Priority = 141,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'FactoryNavy', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'FactoryNavy' }},		
            { TASlow,   'TAAttackNaval', {true}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, LAB * categories.NAVAL } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, LAB * categories.NAVAL}},
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                    BuildStructures = {
                    'T2SeaFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T3AirFactory Naval',
        PlatoonTemplate = 'EngineerBuilderSCTANaval2',
        Priority = 135,
        PriorityFunction = TAPrior.ProductionT3Air,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory' }},
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            ---NeedGuard = false,
            ---DesiresAssist = false,
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildStructures = {
                    'T3AirFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T3LAND Hover Factory Naval',
        PlatoonTemplate = 'EngineerBuilderSCTANaval2',
        Priority = 150,
        PriorityFunction = TAPrior.ProductionT3,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory' }},
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            ---NeedGuard = false,
            ---DesiresAssist = false,
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildClose = true,
                BuildStructures = {
                    'T3LandFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Engineer Naval MetalMaker',
        PlatoonTemplate = 'EngineerBuilderSCTANaval',
        Priority = 120,
        PriorityFunction = TAPrior.TechEnergyExist,
        InstanceCount = 2,
        BuilderConditions = {
            { TAutils, 'GreaterThanEconEnergyTAEfficiency', {1.05}},
            { TAutils, 'LessMassStorageMaxTA',  { 0.3}},
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                    BuildClose = true,
                    BuildStructures = {
                    'T2MassCreation',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTATorpedo',
        PlatoonTemplate = 'EngineerBuilderSCTANaval',
        PriorityFunction = TAPrior.NavalProduction,
        Priority = 50,
        InstanceCount = 1,
        BuilderConditions = {
            { TASlow,   'TAAttackNaval', {true}},		
            { TASlow, 'HaveLessThanUnitsWithCategoryTA', { 2, categories.ANTINAVY - categories.MOBILE} },
            { TAutils, 'GreaterTAStorageRatio', { 0.33, 0.5}},
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildClose = false,
                MarkerRadius = 20,
                LocationRadius = 75,
                ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH2 ANTINAVY',
                BuildStructures = {
                    'T1NavalDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI Naval T1Pgen',
        PlatoonTemplate = 'EngineerBuilderSCTANaval',
        PriorityFunction = TAPrior.HighTechEnergyProduction,
        Priority = 135,
        InstanceCount = 2,
        BuilderConditions = {
        { TAutils , 'LessThanEconEnergyTAEfficiency', {1.05}},
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildClose = true,
                BuildStructures = {
                    'T1EnergyProduction3',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAT2Torpedo',
        PlatoonTemplate = 'EngineerBuilderSCTANaval',
        PriorityFunction = TAPrior.NavalProductionT2,
        Priority = 75,
        InstanceCount = 2,
        BuilderConditions = {
            --{ TASlow, 'TAEnemyUnitsGreaterAtLocationRadius', { BaseEnemyArea, 'LocationType', 0, categories.FACTORY * categories.NAVAL}},	
            { TASlow,   'TAAttackNaval', {true}},	
            { TASlow, 'HaveLessThanUnitsWithCategoryTA',  { 4, categories.ANTISUB * categories.TECH2 - categories.MOBILE} }, 
            { TAutils, 'GreaterTAStorageRatio', { 0.33, 0.75}}, 
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildClose = true,
                MarkerRadius = 20,
                LocationRadius = 75,
                ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH2 ANTINAVY',
                BuildStructures = {
                    'T2NavalDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T2 Naval PGen',
        PlatoonTemplate = 'EngineerBuilderSCTANaval2',
        PriorityFunction = TAPrior.StructureProductionT2Energy,
        Priority = 150,
        InstanceCount = 1,
        BuilderConditions = {
            { TAutils , 'LessThanEconEnergyTAEfficiency', {1.05}},
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            ---DesiresAssist = false,
            ---NeedGuard = false,
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildStructures = {
                    'T2EnergyProduction',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Engineer Naval Mex',
        PlatoonTemplate = 'EngineerBuilderSCTANaval',
        Priority = 50,
        InstanceCount = 1, 
        DelayEqualBuildPlattons = {'MexSea', 1},-- The max number concurrent instances of this builder.
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'MexSea' }},
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 500, -500, 1000, 0, 'StructuresNotMex', 1 }},
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            ---NeedGuard = false,
            ---DesiresAssist = false,
            Construction = {
            Location = 'LocationType',
            NearMarkerType = 'Naval Area',
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T2Engineer 300 Mex Naval',
        PlatoonTemplate = 'EngineerBuilderSCTANaval2',
        PriorityFunction = TAPrior.UnitProduction,
        Priority = 75,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'MexSea', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'MexSea' }},
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 500, -500, 1000, 0, 'StructuresNotMex', 1 }},
        },
        BuilderType = 'SeaTA',
        BuilderData = {
            ---NeedGuard = false,
            ---DesiresAssist = false,
            Construction = {
            Location = 'LocationType',
            NearMarkerType = 'Naval Area',
                BuildStructures = {
                    'T2Resource',
                    }
                }
            }
        },
        --[[Builder {
            BuilderName = 'SCTA Engineer Finish Navy',
            PlatoonTemplate = 'EngineerBuilderSCTANaval',
            PlatoonAIPlan = 'ManagerEngineerFindUnfinishedSCTA',
            Priority = 500,
            InstanceCount = 2,
            DelayEqualBuildPlattons = {'Unfinished', 2},
            BuilderConditions = {
                { TASlow, 'CheckBuildPlatoonDelaySCTA', { 'Unfinished' }},
                { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, categories.ENGINEER * categories.NAVAL} },
                { UCBC, 'UnfinishedUnits', { 'LocationType', categories.STRUCTURE}},
            },
            BuilderData = {
                Assist = {
                    NearMarkerType = 'Naval Area',
                    BeingBuiltCategories = {'STRUCTURE'},
                    AssistLocation = 'LocationType',
                    AssistUntilFinished = true,
                    AssisteeType = 'Engineer',
                    Time = 20,
                },
            },
            BuilderType = 'SeaTA',
        },]]
        Builder {
            BuilderName = 'SCTA Engineer Reclaim Energy Naval',
            PlatoonTemplate = 'EngineerBuilderSCTANaval',
            PriorityFunction = TAPrior.TechEnergyExist,
            PlatoonAIPlan = 'ReclaimStructuresAITA',
            Priority = 111,
            InstanceCount = 8,
            BuilderConditions = {
                { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1,  TIDAL}},
                { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1,  categories.ENGINEER * categories.NAVAL} },
                { TAutils, 'LessMassStorageMaxTA',  { 0.3}},
                },
            BuilderData = {
                Location = 'LocationType',
                Reclaim = {'cortide, armtide,'},
                ReclaimTime = 30,
            },
            BuilderType = 'SeaTA',
        },
}