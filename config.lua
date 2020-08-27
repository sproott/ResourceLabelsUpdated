local ResourceConfig = {}

-- Adds a label for a resource that has an item as mining result
-- params: entity-name, label, item-name
local function addItem(resourceEntity, label, icon)
    ResourceConfig[resourceEntity] = {label=label, type="item", icon=icon, enabled=true}
end

-- Adds a label for a resource that has a fluid as mining result
-- params: entity-name, label, fluid-name
local function addFluid(resourceEntity, label, icon)
    ResourceConfig[resourceEntity] = {label=label, type="fluid", icon=icon, enabled=true}
end

local function addRock(resourceEntity, label, icon)
    ResourceConfig[resourceEntity] = {label=label, type="item", icon=icon, enabled=true}
end

-- Adds an infinite version of an ore, note that the regular ore must be added first using addItem!
-- params: entity-name
local function addInfiniteItem(baseResourceEntity)
    local base = ResourceConfig[baseResourceEntity]
    local infiniteEntity = "infinite-" .. baseResourceEntity
    local infiniteLabel = "Infinite " .. base.label
    local infiniteIcon = base.icon

    ResourceConfig[infiniteEntity] = {label=infiniteLabel, type="item", icon=infiniteIcon, enabled=true}
end

-- Hides a previously defined resource
-- params: entity-name
local function hide(baseResourceEntity)
    ResourceConfig[baseResourceEntity].enabled = false
end

-- examples:
-- 1)
-- addItem("coal", "Coal", "coal")
-- Adds the label "Coal" with the icon of the item "coal" to entities named "coal".
-- 2)
-- hide("coal")
-- Coal will no longer be shown on the map.


--Vanilla
addItem ("coal", "Coal", "coal")
addItem ("iron-ore", "Iron", "iron-ore")
addItem ("copper-ore", "Copper", "copper-ore")
addItem ("stone", "Stone", "stone")
addItem ("uranium-ore", "Uranium", "uranium-ore")
addFluid("crude-oil", "Oil", "crude-oil")

-- Cargo Ships
addFluid ("deep_oil", "Deep Oil", "crude-oil")

-- Alien Wall
addItem ("alien-biomass", "Alien Biomass", "alien-biomass")

-- Angel's Ores
addFluid("angels-fissure", "Fissure", "thermal-water")
addItem ("angels-ore1", "Saphirite", "angels-ore1")
addItem ("angels-ore2", "Jivolite", "angels-ore2")
addItem ("angels-ore3", "Stiratite", "angels-ore3")
addItem ("angels-ore4", "Crotinnium", "angels-ore4")
addItem ("angels-ore5", "Rubyte", "angels-ore5")
addItem ("angels-ore6", "Bobmonium", "angels-ore6")

-- Angel's Petrochem
addFluid("angels-natural-gas", "Natural Gas", "gas-natural-1")

--Bob's Ores
addItem ("gold-ore", "Gold", "gold-ore")
addItem ("lead-ore", "Lead", "lead-ore")
addItem ("silver-ore", "Silver", "silver-ore")
addItem ("tin-ore", "Tin", "tin-ore")
addItem ("tungsten-ore", "Tungsten", "tungsten-ore")
addItem ("zinc-ore", "Zinc", "zinc-ore")
addItem ("bauxite-ore", "Aluminium", "bauxite-ore")
addItem ("rutile-ore", "Titanium", "rutile-ore")
addItem ("nickel-ore", "Nickel", "nickel-ore")
addItem ("cobalt-ore", "Cobaltite", "cobalt-ore")
addItem ("quartz", "Quartz", "quartz")
addItem ("sulfur", "Sulfur", "sulfur")
addItem ("gem-ore", "Gemstones", "gem-ore")
addItem ("thorium-ore", "Thorium", "thorium-ore")
addFluid("ground-water", "Water", "water")
addFluid("lithia-water", "Lithia Water", "lithia-water")

-- Dark Matter Replicators
addItem ("tenemut", "Tenemut", "tenemut")

-- Deep Core Mining
addItem ("copper-ore-patch", "Copper (Deep)", "vtk-deepcore-mining-copper-ore-chunk")
addItem ("iron-ore-patch", "Iron (Deep)", "vtk-deepcore-mining-iron-ore-chunk")
addItem ("coal-patch", "Coal (Deep)", "vtk-deepcore-mining-coal-chunk")
addItem ("stone-patch", "Stone (Deep)", "vtk-deepcore-mining-stone-chunk")
addItem ("uranium-ore-patch", "Uranium (Deep)", "vtk-deepcore-mining-uranium-ore-chunk")
addItem ("vtk-deepcore-mining-crack", "Deep Core Crack", "vtk-deepcore-mining-ore-chunk")
addItem ("angels-ore1-patch", "Saphirite (Deep)", "vtk-deepcore-mining-angels-ore1-chunk")
addItem ("angels-ore2-patch", "Jivolite (Deep)", "vtk-deepcore-mining-angels-ore2-chunk")
addItem ("angels-ore3-patch", "Stiratite (Deep)", "vtk-deepcore-mining-angels-ore3-chunk")
addItem ("angels-ore4-patch", "Crotinnium (Deep)", "vtk-deepcore-mining-angels-ore4-chunk")
addItem ("angels-ore5-patch", "Rubyte (Deep)", "vtk-deepcore-mining-angels-ore5-chunk")
addItem ("angels-ore6-patch", "Bobmonium (Deep)", "vtk-deepcore-mining-angels-ore6-chunk")

-- DyWorld
-- addItem ("gold-ore", "Gold", "gold-ore") <- covered by Bobs
-- addItem ("tin-ore", "Tin", "tin-ore") <- covered by Bobs
-- addItem ("silver-ore", "Silver", "silver-ore") <- covered by Bobs
addItem ("chromium-ore", "Chromium", "chromium-ore")
-- addItem ("lead-ore", "Lead", "lead-ore") <- covered by Bobs
-- addItem ("tungsten-ore", "Tungsten", "tungsten-ore") <- covered by Bobs
-- addItem ("zinc-ore", "Zinc", "zinc-ore") <- covered by Bobs
addItem ("aluminium-ore", "Aluminium", "aluminium-ore")
-- addItem ("nickel-ore", "Nickel", "nickel-ore") <- covered by Bobs

-- DrugLab
addItem ("manganese-ore-dl", "Manganese", "manganese-ore-dl")
addItem ("tarsands-dl", "Tar Sand", "tarsands-dl")
addFluid("fracking-sludge-dl", "Fracking Sludge", "fracking-sludge-dl")

-- Geothermal
addFluid("geothermal", "Geothermal Water", "geothermal-water")

-- Ice Ore
addItem ("ice-ore", "Ice", "ice-ore")

-- MadClown01's Extended AngelBob Minerals
addItem ("clowns-ore1", "Adamantite", "clowns-ore1")
addItem ("clowns-ore2", "Antitate", "clowns-ore2")
addItem ("clowns-ore3", "Pro-Galena", "clowns-ore3")
addItem ("clowns-ore4", "Orichalcite", "clowns-ore4")
addItem ("clowns-ore5", "Phosphorite", "clowns-ore5")
addItem ("clowns-ore6", "Sanguinate", "clowns-ore6")
addItem ("clowns-ore7", "Elionagate", "clowns-ore7")
addItem ("clowns-ore8", "Meta-Garnierite", "clowns-ore8")
addItem ("clowns-ore9", "Meta-Garnierite", "clowns-ore9")
addItem ("clowns-ore10", "Meta-Garnierite", "clowns-ore10")
addItem ("clowns-resource1", "Alluvium", "clowns-resource1")
addItem ("clowns-resource2", "Oil Sand", "clowns-resource2")
addItem ("clowns-resource3", "Crystal", "gem-ore")

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

-- Omnimatter
addItem ("omnite", "Omnite", "omnite")
addItem ("infinite-omnite", "Infinite Omnite", "omnite")

-- Portal Research
addItem ("factorium-ore", "Factorium", "factorium-ore")

-- Pyanodon's Coal Processing
addItem ("raw-borax", "Borax", "raw-borax")
addItem ("borax", "Borax", "raw-borax")
addItem ("niobium", "Niobium", "niobium-ore")

-- Py Alien Life
addItem ("ore-bioreserve", "Bioreserve", "bio-sample")

-- Pyanodon's Petroleum Handling
addItem ("natural-gas", "Natural Gas", "natural-gas")
addFluid ("oil-mk01", "Small Oil Patch", "crude-oil")
addFluid ("oil-mk02", "Medium Oil Patch", "crude-oil")
addFluid ("oil-mk03", "Big Oil Patch", "crude-oil")
addFluid ("oil-mk04", "Massive Oil Patch", "crude-oil")
addItem ("oil-sand", "Oil Sand", "oil-sand")
addItem ("sulfur-patch", "Sulfur", "sulfur")
addFluid ("tar-patch", "Tar", "tar")


-- Pyanodon's Raw Ores - Ores
addItem ("ore-aluminium", "Aluminium", "ore-aluminium")
addItem ("ore-chromium", "Chromium", "ore-chromium")
addItem ("ore-lead", "Lead", "ore-lead")
addItem ("ore-nickel", "Nickel", "ore-nickel")
addItem ("ore-quartz", "Quartz", "ore-quartz")
addItem ("raw-coal", "Coal", "raw-coal")
addItem ("ore-tin", "Tin", "ore-tin")
addItem ("ore-titanium", "Titanium", "ore-titanium")
addItem ("ore-zinc", "Zinc", "ore-zinc")

-- Pyanodon's Raw Ores - Rocks
addRock ("aluminium-rock", "Aluminium Rock", "ore-aluminium")
addRock ("chromium-rock", "Chromium Rock", "ore-chromium")
addRock ("coal-rock", "Coal Rock", "coal")
addRock ("copper-rock", "Copper Rock", "copper-ore")
addRock ("iron-rock", "Iron Rock", "iron-ore")
addRock ("lead-rock", "Lead Rock", "ore-lead")
addRock ("nexelit-rock", "Nexelit Rock", "nexelit-ore")
addRock ("nickel-rock", "Nickel Rock", "ore-nickel")
addRock ("phosphate-rock-02", "Phosphate Rock", "phosphate-rock")
addRock ("quartz-rock", "Quartz Rock", "ore-quartz")
addRock ("salt-rock", "Salt Rock", "salt")
addRock ("tin-rock", "Tin Rock", "ore-tin")
addRock ("titanium-rock", "Titanium Rock", "ore-titanium")
addRock ("uranium-rock", "Uranium Rock", "uranium-ore")
addRock ("zinc-rock", "Zinc Rock", "ore-zinc")

-- Pyanodon's Fusion Energy
addItem ("molybdenum-ore", "Molybdenum", "molybdenum-ore")
addItem ("volcanic-pipe", "Kimberlite", "kimberlite-rock")
addItem ("kimberlite-rock", "Kimberlite", "kimberlite-rock")
addItem ("regolites", "Regolite", "regolite-rock")

-- Pyanodon's High Tech
addItem ("phosphate-rock", "Phosphate", "phosphate-rock")
addItem ("rare-earth-bolide", "Rare Earth", "rare-earth-ore")

-- PyCoal touched by an Angel
addInfiniteItem("molybdenum-ore")

-- Xander
addItem ("apatite", "Apatite", "apatite")
addItem ("bauxite", "Bauxite", "bauxite")
addItem ("garnierite", "Garnierite", "garnierite")
addItem ("granitic", "Granite", "granitic-ore")
addItem ("heavy-sand", "Heavy Sand", "heavy-sand")
--addItem ("lead-ore", "Lead", "lead-ore") <- covered by Bobs
addFluid("mineral-water", "Mineral Water", "mineral-water")
addFluid("natural-gas", "Natural Gas", "natural-gas")
addItem ("sulfidic-ore", "Sulfidic", "sulfidic-ore")
--addItem ("copper-ore", "Copper", "copper-ore") <- covered by Vanilla
--addFluid("crude-oil", "Oil", "crude-oil") <- covered by Vanilla
--addItem ("iron-ore", "Iron", "iron-ore") <- covered by Vanilla
--addItem ("uranium-ore", "Pitchblende", "uranium-ore") <- covered by Vanilla under different name

-- Yuoki Industries
addItem ("y-res1", "N4-Material", "y-res1")
addItem ("y-res2", "F7-Material", "y-res2")

-- Angel's Infinite Ores
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
addInfiniteItem("y-res1")
addInfiniteItem("y-res2")
addInfiniteItem("tenemut")
addInfiniteItem("angels-ore1")
addInfiniteItem("angels-ore2")
addInfiniteItem("angels-ore3")
addInfiniteItem("angels-ore4")
addInfiniteItem("angels-ore5")
addInfiniteItem("angels-ore6")


-- Hide resources here
-- hide("coal")

return ResourceConfig