--------------------------------------------------------------------------------
-- Supreme Commander mod automatic unit wiki generation script for Github wikis
-- Copyright 2021 Sean 'Balthazar' Wheeldon                           Lua 5.4.2
--------------------------------------------------------------------------------
local Language = 'US'-- These are not ISO_639-1. As an Englishman I am offended.
--[{ ---------------------------------------------------------------------- ]]--
--[[ Inputs -- NOTE: Mod input files must be valid lua                      ]]--
--[[ ---------------------------------------------------------------------- ]]--

OutputDirectory = "C:/Users/poyos/mods/SCTA-master/wiki/"

local WikiGeneratorDirectory = "C:/Users/poyos/OneDrive/Documents/Desktop/ModProject/BrewWikiGen/"

local ModDirectories = { -- In order
    'C:/Users/poyos/mods/SCTA-master/'
}

-- Optional, reduces scope of file search, which is the slowest part.
UnitBlueprintsFolder = 'units'

BlueprintFolderExclusions = {'^[zZ]'}

BlueprintFileExclusions = {'^[zZ]'}

BlueprintIdExclusions = { -- Excludes blueprints with any of these IDs (case insensitive)
    'mas0001',
    'mss0001',
    'mss0002',
    'mss0003',
    'mss0004',
    'mss0005',
    'mss0006',
    'mss0007',
}

-- Web path for img src. Could be relative, but would break on edit previews.
ImageRepo = "images/"
IconRepo = "icons/"
unitIconRepo = IconRepo.."units/" --[unit blueprintID]_icon.png, case sensitive.

FooterCategories = { -- In order
    'UEF',          'AEON',         'CYBRAN',       'SERAPHIM',     'ARM',      'CORE',
    'TECH1',        'TECH2',        'TECH3',        'EXPERIMENTAL',
    'MOBILE',
    'ANTIAIR',      'ANTINAVY',     'DIRECTFIRE',
    'AIR',          'LAND',         'NAVAL',
    'HOVER',
    'ECONOMIC',
    'SHIELD',       'PERSONALSHIELD',
    'BOMBER',       'TORPEDOBOMBER',
    'MINE',
    'COMMAND',      'SUBCOMMANDER', 'ENGINEER',     'FIELDENGINEER',
    'TRANSPORTATION',               'AIRSTAGINGPLATFORM',
    'SILO',
    'FACTORY',
    'ARTILLERY',
    'STRUCTURE',
}

Logging = {
    ModHooksLoaded     = false,
    LuaFileLoadIssues  = true,
    SCMLoadIssues      = false,
    ExcludedBlueprints = true,
    BlueprintTotals    = true,
}
Sanity = {
    BlueprintChecks         = false,
    BlueprintPedanticChecks = false,
}

--[[ ---------------------------------------------------------------------- ]]--
--[[ Run                                                                    ]]--
--[[ ---------------------------------------------------------------------- ]]--

local function safecall(...)
    local pass, msg = pcall(...)
    if not pass then print(msg) end
end

print("Starting BrewWikiGen")

for i, file in ipairs{
    'Environment/Localization.lua',
    'Environment/Game.lua',
    'Utilities/Blueprint.lua',
    'Utilities/Builders.lua',
    'Utilities/File.lua',
    'Utilities/Mesh.lua',
    'Utilities/Sanity.lua',
    'Utilities/String.lua',
    'Utilities/Table.lua',
    'Components/Bodytext.lua',
    'Components/Categories.lua',
    'Components/Infobox.lua',
    'Components/Navigation.lua',
    'Components/Unit.lua',
    'Components/Weapon.lua',
} do
    safecall(dofile, WikiGeneratorDirectory..file)
end

safecall(SetWikiLocalization, WikiGeneratorDirectory, Language)

for i, dir in ipairs(ModDirectories) do
    safecall(LoadModLocalization, dir) -- Load all localisation first.
    safecall(LoadModHooks, dir)
    safecall(LoadModUnitBlueprints, dir, i)
end
for i, dir in ipairs(ModDirectories) do
    safecall(LoadModSystemBlueprintsFile, dir)
end

safecall(GenerateUnitPages)
safecall(GenerateSidebar)
safecall(GenerateModPages)
safecall(GenerateCategoryPages)
safecall(GenerateHomePage)

safecall(printTotalBlueprintValues)
