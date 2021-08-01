local table = require("__stdlib__/stdlib/utils/table")
local ResourceConfig = {}

-- Adds a label for a resource that has an item as mining result
-- params: entity-name, label, item-name, enabled (optional, default true)
local function addItem(resourceEntity, label, icon, enabled)
    ResourceConfig[resourceEntity] = {
        label = label,
        type = "item",
        icon = icon,
        enabled = enabled or true
    }
end

-- Adds a label for a resource that has a fluid as mining result
-- params: entity-name, label, fluid-name, enabled (optional, default true)
local function addFluid(resourceEntity, label, icon, enabled)
    ResourceConfig[resourceEntity] = {
        label = label,
        type = "fluid",
        icon = icon,
        enabled = enabled or true
    }
end

-- Adds a label for a resource that is a rock
-- params: entity-name, label, fluid-name, enabled (optional, default true)
local function addRock(resourceEntity, label, icon, enabled)
    ResourceConfig[resourceEntity] = {
        label = label,
        type = "item",
        icon = icon,
        enabled = enabled or true
    }
end

-- Adds an infinite version of an ore, note that the regular ore must be added first using addItem!
-- params: entity-name, enabled (optional, default true)
local function addInfiniteItem(baseResourceEntity, enabled)
    local base = ResourceConfig[baseResourceEntity]
    if base ~= nil then
        local infiniteEntity = "infinite-" .. baseResourceEntity
        local infiniteLabel = "Infinite " .. base.label
        local infiniteIcon = base.icon
        ResourceConfig[infiniteEntity] = {
            label = infiniteLabel,
            type = "item",
            icon = infiniteIcon,
            enabled = enabled or true
        }
    end
end

-- Hides a previously defined resource
-- params: entity-name
local function hide(baseResourceEntity)
    ResourceConfig[baseResourceEntity].enabled = false
end

local function generateSpaceExplorationFissures()
    local fissures = {}
    for resourceKey, resource in pairs(ResourceConfig) do
        fissures["se-core-fragment-" .. resourceKey] = {
            label = resource.label .. " fissure",
            type = "item",
            icon = "se-core-fragment-" .. resource.icon,
            enabled = resource.enabled
        }
    end
    ResouceConfig = table.merge(ResourceConfig, fissures, false)
end

-- examples:
-- 1)
-- addItem("coal", "Coal", "coal")
-- Adds the label "Coal" with the icon of the item "coal" to entities named "coal".
-- 2)
-- hide("coal")
-- Coal will no longer be shown on the map.

-- Vanilla
addItem("coal", "Coal", "coal")
addItem("iron-ore", "Iron", "iron-ore")
addItem("copper-ore", "Copper", "copper-ore")
addItem("stone", "Stone", "stone")
addItem("uranium-ore", "Uranium", "uranium-ore")
addFluid("crude-oil", "Oil", "crude-oil")

-- Cargo Ships
if script.active_mods["cargo-ships"] then
    addFluid("deep_oil", "Deep Oil", "crude-oil")
end

-- Alien Wall
if script.active_mods["AlienWall"] then
    addItem("alien-biomass", "Alien Biomass", "alien-biomass")
end

-- Angel's Ores
if script.active_mods["angelsrefining"] then
    addFluid("angels-fissure", "Fissure", "thermal-water")
    addItem("angels-ore1", "Saphirite", "angels-ore1")
    addItem("angels-ore2", "Jivolite", "angels-ore2")
    addItem("angels-ore3", "Stiratite", "angels-ore3")
    addItem("angels-ore4", "Crotinnium", "angels-ore4")
    addItem("angels-ore5", "Rubyte", "angels-ore5")
    addItem("angels-ore6", "Bobmonium", "angels-ore6")
end

-- Angel's Petrochem
if script.active_mods["angelspetrochem"] then
    addFluid("angels-natural-gas", "Natural Gas", "gas-natural-1")
end

-- Bob's Ores
if script.active_mods["bobores"] then
    addItem("gold-ore", "Gold", "gold-ore")
    addItem("lead-ore", "Lead", "lead-ore")
    addItem("silver-ore", "Silver", "silver-ore")
    addItem("tin-ore", "Tin", "tin-ore")
    addItem("tungsten-ore", "Tungsten", "tungsten-ore")
    addItem("zinc-ore", "Zinc", "zinc-ore")
    addItem("bauxite-ore", "Aluminium", "bauxite-ore")
    addItem("rutile-ore", "Titanium", "rutile-ore")
    addItem("nickel-ore", "Nickel", "nickel-ore")
    addItem("cobalt-ore", "Cobaltite", "cobalt-ore")
    addItem("quartz", "Quartz", "quartz")
    addItem("sulfur", "Sulfur", "sulfur")
    addItem("gem-ore", "Gemstones", "gem-ore")
    addItem("thorium-ore", "Thorium", "thorium-ore")
    addFluid("ground-water", "Water", "water")
    addFluid("lithia-water", "Lithia Water", "lithia-water")
end

-- brevven mods
if script.active_mods["bztungsten"] then
    addItem("tungsten-ore", "Wolframite", "tungsten-ore")
end

if script.active_mods["bztitanium"] then
    addItem("titanium-ore", "Titanium", "titanium-ore")
end

if script.active_mods["bzlead"] then
    addItem("lead-ore", "Lead", "lead-ore")
end

if script.active_mods["bzzirconium"] then
    addItem("zircon", "Zircon", "zircon")
end

-- Dark Matter Replicators
if script.active_mods["dark-matter-replicators-18"] then
    addItem("tenemut", "Tenemut", "tenemut")
end

-- Deep Core Mining
if script.active_mods["vtk-deep-core-mining"] then
    addItem("copper-ore-patch", "Copper (Deep)", "vtk-deepcore-mining-copper-ore-chunk")
    addItem("iron-ore-patch", "Iron (Deep)", "vtk-deepcore-mining-iron-ore-chunk")
    addItem("coal-patch", "Coal (Deep)", "vtk-deepcore-mining-coal-chunk")
    addItem("stone-patch", "Stone (Deep)", "vtk-deepcore-mining-stone-chunk")
    addItem("uranium-ore-patch", "Uranium (Deep)", "vtk-deepcore-mining-uranium-ore-chunk")
    addItem("vtk-deepcore-mining-crack", "Deep Core Crack", "vtk-deepcore-mining-ore-chunk")
    addItem("angels-ore1-patch", "Saphirite (Deep)", "vtk-deepcore-mining-angels-ore1-chunk")
    addItem("angels-ore2-patch", "Jivolite (Deep)", "vtk-deepcore-mining-angels-ore2-chunk")
    addItem("angels-ore3-patch", "Stiratite (Deep)", "vtk-deepcore-mining-angels-ore3-chunk")
    addItem("angels-ore4-patch", "Crotinnium (Deep)", "vtk-deepcore-mining-angels-ore4-chunk")
    addItem("angels-ore5-patch", "Rubyte (Deep)", "vtk-deepcore-mining-angels-ore5-chunk")
    addItem("angels-ore6-patch", "Bobmonium (Deep)", "vtk-deepcore-mining-angels-ore6-chunk")

    addItem("copper-ore-patch-ore", "Copper (Deep)", "vtk-deepcore-mining-copper-ore-chunk", false)
    addItem("iron-ore-patch-ore", "Iron (Deep)", "vtk-deepcore-mining-iron-ore-chunk", false)
    addItem("coal-patch-ore", "Coal (Deep)", "vtk-deepcore-mining-coal-chunk", false)
    addItem("stone-patch-ore", "Stone (Deep)", "vtk-deepcore-mining-stone-chunk", false)
    addItem("uranium-ore-patch-ore", "Uranium (Deep)", "vtk-deepcore-mining-uranium-ore-chunk", false)
    addItem("vtk-deepcore-mining-crack-ore", "Deep Core Crack", "vtk-deepcore-mining-ore-chunk", false)
    addItem("angels-ore1-patch-ore", "Saphirite (Deep)", "vtk-deepcore-mining-angels-ore1-chunk", false)
    addItem("angels-ore2-patch-ore", "Jivolite (Deep)", "vtk-deepcore-mining-angels-ore2-chunk", false)
    addItem("angels-ore3-patch-ore", "Stiratite (Deep)", "vtk-deepcore-mining-angels-ore3-chunk", false)
    addItem("angels-ore4-patch-ore", "Crotinnium (Deep)", "vtk-deepcore-mining-angels-ore4-chunk", false)
    addItem("angels-ore5-patch-ore", "Rubyte (Deep)", "vtk-deepcore-mining-angels-ore5-chunk", false)
    addItem("angels-ore6-patch-ore", "Bobmonium (Deep)", "vtk-deepcore-mining-angels-ore6-chunk", false)
end

-- DyWorld
if script.active_mods["DyWorld"] then
    addItem("gold-ore", "Gold", "gold-ore")
    addItem("tin-ore", "Tin", "tin-ore")
    addItem("silver-ore", "Silver", "silver-ore")
    addItem("chromium-ore", "Chromium", "chromium-ore")
    addItem("lead-ore", "Lead", "lead-ore")
    addItem("tungsten-ore", "Tungsten", "tungsten-ore")
    addItem("zinc-ore", "Zinc", "zinc-ore")
    addItem("aluminium-ore", "Aluminium", "aluminium-ore")
    addItem("nickel-ore", "Nickel", "nickel-ore")
end

-- DrugLab
if script.active_mods["druglab"] then
    addItem("manganese-ore-dl", "Manganese", "manganese-ore-dl")
    addItem("tarsands-dl", "Tar Sand", "tarsands-dl")
    addFluid("fracking-sludge-dl", "Fracking Sludge", "fracking-sludge-dl")
end

-- Geothermal
if script.active_mods["Geothermal"] then
    addFluid("geothermal", "Geothermal Water", "geothermal-water")
end

-- Ice Ore
if script.active_mods["IceOre"] then
    addItem("ice-ore", "Ice", "ice-ore")
end

-- Krastorio 2
if script.active_mods["Krastorio2"] then
    addItem("rare-metals", "Rare Metals", "rare-metals")
    addItem("imersite", "Imersite", "raw-imersite")
    addFluid("mineral-water", "Mineral Water", "mineral-water")
end

-- MadClown01's Extended AngelBob Minerals
if script.active_mods["Clowns-Extended-Minerals"] then
    addItem("clowns-ore1", "Adamantite", "clowns-ore1")
    addItem("clowns-ore2", "Antitate", "clowns-ore2")
    addItem("clowns-ore3", "Pro-Galena", "clowns-ore3")
    addItem("clowns-ore4", "Orichalcite", "clowns-ore4")
    addItem("clowns-ore5", "Phosphorite", "clowns-ore5")
    addItem("clowns-ore6", "Sanguinate", "clowns-ore6")
    addItem("clowns-ore7", "Elionagate", "clowns-ore7")
    addItem("clowns-ore8", "Meta-Garnierite", "clowns-ore8")
    addItem("clowns-ore9", "Meta-Garnierite", "clowns-ore9")
    addItem("clowns-ore10", "Meta-Garnierite", "clowns-ore10")
    addItem("clowns-resource1", "Alluvium", "clowns-resource1")
    addItem("clowns-resource2", "Oil Sand", "clowns-resource2")
    addItem("clowns-resource3", "Crystal", "gem-ore")

    addInfiniteItem("clowns-ore1")
    addInfiniteItem("clowns-ore2")
    addInfiniteItem("clowns-ore3")
    addInfiniteItem("clowns-ore4")
    addInfiniteItem("clowns-ore5")
    addInfiniteItem("clowns-ore6")
    addInfiniteItem("clowns-ore7")
    addInfiniteItem("clowns-ore8")
    addInfiniteItem("clowns-ore9")
    addInfiniteItem("clowns-ore10")
    addInfiniteItem("clowns-resource1")
    addInfiniteItem("clowns-resource2")
end

-- Omnimatter
if script.active_mods["omnimatter"] then
    addItem("omnite", "Omnite", "omnite")
    addItem("infinite-omnite", "Infinite Omnite", "omnite")
end

-- Portal Research
if script.active_mods["portal-research"] then
    addItem("factorium-ore", "Factorium", "factorium-ore")
end

-- Pyanodon's Coal Processing
if script.active_mods["pycoalprocessing"] then
    addItem("raw-borax", "Borax", "raw-borax")
    addItem("borax", "Borax", "raw-borax")
    addItem("niobium", "Niobium", "niobium-ore")
end

-- Pyanodon's Alien Life
if script.active_mods["pyalienlife"] then
    addItem("ore-bioreserve", "Bioreserve", "bio-sample")
end

-- Pyanodon's Petroleum Handling
if script.active_mods["pypetroleumhandling"] then
    addFluid("natural-gas-1", "Small Natural Gas", "natural-gas")
    addFluid("natural-gas-2", "Medium Natural Gas", "natural-gas")
    addFluid("natural-gas-3", "Big Natural Gas", "natural-gas")
    addFluid("natural-gas-4", "Massive Natural Gas", "natural-gas")
    addFluid("oil-mk01", "Small Oil Patch", "crude-oil")
    addFluid("oil-mk02", "Medium Oil Patch", "crude-oil")
    addFluid("oil-mk03", "Big Oil Patch", "crude-oil")
    addFluid("oil-mk04", "Massive Oil Patch", "crude-oil")
    addItem("oil-sand", "Oil Sand", "oil-sand")
    addItem("sulfur-patch", "Sulfur", "sulfur")
    addFluid("tar-patch", "Tar", "tar")
    addFluid("bitumen-seep", "Bitumen Seep", "drilling-waste")
end

-- Pyanodon's Raw Ores - Ores
if script.active_mods["pyrawores"] then
    addItem("ore-aluminium", "Aluminium", "ore-aluminium")
    addItem("ore-chromium", "Chromium", "ore-chromium")
    addItem("ore-lead", "Lead", "ore-lead")
    addItem("ore-nickel", "Nickel", "ore-nickel")
    addItem("ore-quartz", "Quartz", "ore-quartz")
    addItem("raw-coal", "Coal", "raw-coal")
    addItem("ore-tin", "Tin", "ore-tin")
    addItem("ore-titanium", "Titanium", "ore-titanium")
    addItem("ore-zinc", "Zinc", "ore-zinc")

    -- Pyanodon's Raw Ores - Rocks
    addRock("aluminium-rock", "Aluminium Rock", "ore-aluminium")
    addRock("chromium-rock", "Chromium Rock", "ore-chromium")
    addRock("coal-rock", "Coal Rock", "coal")
    addRock("copper-rock", "Copper Rock", "copper-ore")
    addRock("iron-rock", "Iron Rock", "iron-ore")
    addRock("lead-rock", "Lead Rock", "ore-lead")
    addRock("nexelit-rock", "Nexelit Rock", "nexelit-ore")
    addRock("nickel-rock", "Nickel Rock", "ore-nickel")
    addRock("phosphate-rock-02", "Phosphate Rock", "phosphate-rock")
    addRock("quartz-rock", "Quartz Rock", "ore-quartz")
    addRock("salt-rock", "Salt Rock", "salt")
    addRock("tin-rock", "Tin Rock", "ore-tin")
    addRock("titanium-rock", "Titanium Rock", "ore-titanium")
    addRock("uranium-rock", "Uranium Rock", "uranium-ore")
    addRock("zinc-rock", "Zinc Rock", "ore-zinc")
end

-- Pyanodon's Fusion Energy
if script.active_mods["pyfusionenergy"] then
    addItem("molybdenum-ore", "Molybdenum", "molybdenum-ore")
    addItem("volcanic-pipe", "Kimberlite", "kimberlite-rock")
    addItem("kimberlite-rock", "Kimberlite", "kimberlite-rock")
    addItem("regolites", "Regolite", "regolite-rock")
end

-- Pyanodon's High Tech
if script.active_mods["pyhightech"] then
    addItem("phosphate-rock", "Phosphate", "phosphate-rock")
    addItem("rare-earth-bolide", "Rare Earth", "rare-earth-ore")
end

-- PyCoal touched by an Angel
if script.active_mods["PyCoalTBaA"] or script.active_mods["PyCoalTBaA-Temp-Dark"] then
    addInfiniteItem("molybdenum-ore")
end

-- Xander
if script.active_mods["xander-mod"] then
    addItem("apatite", "Apatite", "apatite")
    addItem("bauxite", "Bauxite", "bauxite")
    addItem("garnierite", "Garnierite", "garnierite")
    addItem("granitic", "Granite", "granitic-ore")
    addItem("heavy-sand", "Heavy Sand", "heavy-sand")
    -- addItem ("lead-ore", "Lead", "lead-ore") <- covered by Bobs
    addFluid("mineral-water", "Mineral Water", "mineral-water")
    addFluid("natural-gas", "Natural Gas", "natural-gas")
    addItem("sulfidic-ore", "Sulfidic", "sulfidic-ore")
    -- addItem ("copper-ore", "Copper", "copper-ore") <- covered by Vanilla
    -- addFluid("crude-oil", "Oil", "crude-oil") <- covered by Vanilla
    -- addItem ("iron-ore", "Iron", "iron-ore") <- covered by Vanilla
    -- addItem ("uranium-ore", "Pitchblende", "uranium-ore") <- covered by Vanilla under different name
end

-- Yuoki Industries
if script.active_mods["Yuoki"] then
    addItem("y-res1", "N4-Material", "y-res1")
    addItem("y-res2", "F7-Material", "y-res2")
end

-- Angel's Infinite Ores
if script.active_mods["angelsinfiniteores"] then
    addInfiniteItem("coal")
    addInfiniteItem("iron-ore")
    addInfiniteItem("copper-ore")
    addInfiniteItem("stone")
    addInfiniteItem("uranium-ore")
    addInfiniteItem("bauxite-ore")
    addInfiniteItem("cobalt-ore")
    addInfiniteItem("zinc-ore")
    addInfiniteItem("tin-ore")
    addInfiniteItem("quartz")
    addInfiniteItem("gem-ore")
    addInfiniteItem("gold-ore")
    addInfiniteItem("lead-ore")
    addInfiniteItem("nickel-ore")
    addInfiniteItem("rutile-ore")
    addInfiniteItem("silver-ore")
    addInfiniteItem("sulfur")
    addInfiniteItem("tungsten-ore")
    addInfiniteItem("angels-ore1")
    addInfiniteItem("angels-ore2")
    addInfiniteItem("angels-ore3")
    addInfiniteItem("angels-ore4")
    addInfiniteItem("angels-ore5")
    addInfiniteItem("angels-ore6")

    if script.active_mods["Yuoki"] then
        addInfiniteItem("y-res1")
        addInfiniteItem("y-res2")
    end
    if script.active_mods["dark-matter-replicators-18"] then
        addInfiniteItem("tenemut")
    end
end

-- Hide resources here
-- hide("coal")
-- Add all resources BEFORE this, if you want to generate SE fissures for them (you generally do)
if script.active_mods["space-exploration"] then

    -- Space Exploration
    addItem("se-water-ice", "Water Ice", "se-water-ice")
    addItem("se-methane-ice", "Methane Ice", "se-methane-ice")
    addItem("se-beryllium-ore", "Beryllium", "se-beryllium-ore")
    addItem("se-vitamelange", "Vitamelange", "se-vitamelange")
    addItem("se-naquium-ore", "Naquium", "se-naquium-ore")
    addItem("se-iridium-ore", "Iridium", "se-iridium-ore")
    addItem("se-cryonite", "Cryonite", "se-cryonite")
    addItem("se-holmium-ore", "Holmium", "se-holmium-ore")
    addItem("se-vulcanite", "Vulcanite", "se-vulcanite")

    -- Space Exploration fissures
    generateSpaceExplorationFissures()
end

-- for resourceKey, resource in pairs(ResourceConfig) do
--     log("Resource key=" .. resourceKey .. ", label=" .. resource.label .. ", icon=" .. resource.icon .. ", enabled=" .. tostring(resource.enabled))
-- end
return ResourceConfig
