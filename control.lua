local Game = require('__stdlib__/stdlib/game')
local Area = require('__stdlib__/stdlib/area/area')
local Position = require('__stdlib__/stdlib/area/position')
local Resource = require('__stdlib__/stdlib/entity/resource')
local Chunk = require('__stdlib__/stdlib/area/chunk')
local Event = require("__stdlib__/stdlib/event/event")
local table = require("__stdlib__/stdlib/utils/table")

local ResourceConfig = require('config')

local MOD = {}
MOD.title = "Resource Labels"
MOD.name = "ResourceLabelsUpdated"

local SIunits =
    {
        [0] = "",
        [1] = "k",
        [2] = "M",
        [3] = "G",
        [4] = "T",
        [5] = "P",
        [6] = "E"
    }
function reinitialize()
    global.chunksToLabel = {}
    global.knownPositions = {}
    global.isLabeling = {}
    global.settings = {}
    removeLabelsAfterChange()
end
Event.register(Event.core_events.init,
    function()
        global.chunksToLabel = {}
        global.knownPositions = {}
        global.labeledResourcePatches = {}
        global.isLabeling = {}
        global.settings = {}
    end
)
Event.register(defines.events.on_runtime_mod_setting_changed,
    function(event)
        if event.setting == "resource-labels-use-old-algorithm" then
            reinitialize()
        end
    end
)
Event.register(Event.core_events.configuration_changed,
    function(event)
        if event.mod_changes[MOD.name] and event.mod_changes[MOD.name].old_version and event.mod_changes[MOD.name].new_version then
            local changes = event.mod_changes[MOD.name]
            
            game.print{"resource-labels-update-msg", MOD.title, changes.old_version, changes.new_version}
            
            for forceName, _ in pairs(global.labeledResourcePatches) do
                game.forces[forceName].print{"resource-labels-update-deleted-labels-msg"}
            end
            
            -- if the mod is updated while the labeling process was running, cancel the process by clearing the schedule table
            reinitialize()
        end
    end
)
Event.register("resource-labels-add",
    function(event)
        --cache settings so the settings file is not accessed every tick while resource patches are being labeled
        cacheSettings()
        
        local player = Game.get_player(event.player_index)
        local force = player.force
        local cooldown = global.settings["resource-labels-cooldown"]
        if not global.isLabeling[force.name] then
            global.isLabeling[force.name] = {}
            global.isLabeling[force.name]["stop"] = -cooldown
            global.isLabeling[force.name]["initiator"] = ""
        end
        local stop = global.isLabeling[force.name].stop
        if stop + cooldown <= event.tick then
            local surface = player.surface
            local force = player.force
            local scheduledTick = game.tick
            local scheduleInterval = global.settings["resource-labels-schedule-interval"]
            for chunk in surface.get_chunks() do
                if force.is_chunk_charted(surface, chunk) and surface.count_entities_filtered{area = Chunk.to_area(chunk), type = "resource"} > 0 then
                    scheduledTick = scheduledTick + scheduleInterval
                    scheduleLabelingForChunk(scheduledTick, player, surface, chunk)
                end
            end
            global.isLabeling[force.name].stop = scheduledTick
            global.isLabeling[force.name].initiator = player.name
        elseif stop <= event.tick then
            player.print{"resource-labels-cooldown-msg", stop + cooldown - event.tick}
        else
            local initiator = global.isLabeling[force.name].initiator
            player.print{"resource-labels-already-running-msg", initiator, stop - event.tick}
        end
    end
)
function scheduleLabelingForChunk(scheduledTick, player, surface, chunk)
    if not global.chunksToLabel[scheduledTick] then
        global.chunksToLabel[scheduledTick] = {}
    end
    global.knownPositions[player.force.name] = {}
    table.insert(global.chunksToLabel[scheduledTick], {player = player, surface = surface, area = stdlibAreaToFactorioArea(Chunk.to_area(chunk))})
end

Event.register(defines.events.on_tick,
    function(event)
        if global.chunksToLabel[event.tick] ~= nil then
            if global.settings["resource-labels-use-old-algorithm"] then
                table.each(global.chunksToLabel[event.tick], function(data)
                    labelResourcesInAreaOld(data.player, data.surface, data.area)
                end)
            else
                table.each(global.chunksToLabel[event.tick], function(data)
                    local knownPositions = global.knownPositions[data.player.force.name]
                    labelResourcesInArea(data.player, data.surface, data.area, knownPositions)
                end)
            end
            
            global.chunksToLabel[event.tick] = nil
        end
    end
)
function labelResourcesInAreaOld(player, surface, area)
    local resources = surface.find_entities_filtered{area = area, type = "resource"}
    if #resources > 0 then
        local resourceTypes = Resource.get_resource_types(resources)
        for _, type in pairs(resourceTypes) do
            local resourcesFiltered = Resource.filter_resources(resources, {type})
            local entity = table.first(resourcesFiltered)
            if labelIsEnabled(entity) then
                local patch = Resource.get_resource_patch_at(surface, entity.position, type)
                createLabelForResourcePatch(player, surface, patch)
            end
        end
    end
end

function labelResourcesInArea(player, surface, area, knownPositions)
    local resources = surface.find_entities_filtered{area = area, type = "resource"}
    table.each(resources, function(resource)
        if not knownPositions[Position.to_string_xy(resource.position)] then
            labelResourcesOnPosition(player, surface, resource.position, knownPositions)
        end
    end)
end

function labelResourcesOnPosition(player, surface, position, knownPositions)
    local resources = Resource.get_resource_patches_at(surface, position)
    local collapsedResources = collapseMultitileResources(resources)
    table.each(collapsedResources, function(resource)
        table.each(resource, function(entity)knownPositions[Position.to_string_xy(entity.position)] = true end)
        createLabelForResourcePatch(player, surface, resource)
    end)
end

function collapseMultitileResources(resources)
    local filteredResources = {}
    for key, patch in pairs(resources) do
        local filteredPatch = {}
        local knownPositions = {}
        for _, entity in pairs(patch) do
            if not knownPositions[entity.position] then
                table.insert(filteredPatch, entity)
                knownPositions[Position.to_string_xy(entity.position)] = true
            end
        end
        filteredResources[key] = filteredPatch
    end
    return filteredResources
end

function labelIsEnabled(entity)
    local isEnabled = true
    
    local configEntry = ResourceConfig[entity.name]
    if configEntry then
        isEnabled = configEntry.enabled
    end
    
    return isEnabled
end

function createLabelForResourcePatch(player, surface, patch)
    local force = player.force
    
    if not isAlreadyLabeled(force, surface, patch) then
        local bounds = Resource.get_resource_patch_bounds(patch)
        local centerPosition = Area.center(bounds)
        local entity = table.first(patch)
        local signalID = getSignalID(entity)
        
        if ResourceConfig[entity.name] == nil then
            if global.settings["resource-labels-show-unknown-entity-msg"] then
                player.print{"resource-labels-unknown-resource-entity-msg", entity.name, MOD.title}
            end
            return
        end
        
        --no label for resource patches with these entities disabled
        if getLabel(entity) == "Stone" and global.settings["resource-labels-hide-stone"] then
            return
        end
        if getLabel(entity) == "Coal" and global.settings["resource-labels-hide-coal"] then
            return
        end
        if getLabel(entity) == "Iron" and global.settings["resource-labels-hide-iron"] then
            return
        end
        if getLabel(entity) == "Copper" and global.settings["resource-labels-hide-copper"] then
            return
        end
        if getLabel(entity) == "Uranium" and global.settings["resource-labels-hide-uranium"] then
            return
        end
        if getLabel(entity) == "Oil" and global.settings["resource-labels-hide-oil"] then
            return
        end
        
        --no label for resource patches with less than specified amount of entities
        if signalID and signalID.type == "item" and #patch <= global.settings["resource-labels-minimum-resource-entity-count"] then
            return
        end
        
        if isInfiniteResource(entity) then
            --no label if the player does not want to see infinite ores
            if signalID and signalID.type == "item" and not global.settings["resource-labels-show-infinite-ores"] then
                return
            end
        else
            --no label if the resource count is less than specified minimum in the mod settings
            if getResourceCount(patch) <= global.settings["resource-labels-minimum-resource-count"] then
                return
            end
            --no label if the resource count is more than specified maximum in the mod settings
            if getResourceCount(patch) >= global.settings["resource-labels-maximum-resource-count"] then
                return
            end
        end
        
        local label = ""
        if global.settings["resource-labels-show-resource-count"] then
            --show yield only for non fluid infinite ores
            if isInfiniteResource(entity) then
                if ResourceConfig[entity.name].type ~= "fluid" then
                    label = label .. getResourceCount(patch) .. "% "
                else
                    label = ""
                end
            else
                if getLabel(entity):find("Rock") then
                    label = label .. numberToSiString(entity.amount) .. " "
                else
                    label = label .. numberToSiString(getResourceCount(patch)) .. " "
                end
            end
        end
        if global.settings["resource-labels-show-labels"] then
            label = label .. getLabel(entity)
        end
        if not global.settings["resource-labels-show-icons"] then
            signalID = nil
        end
        local chartTag = {}
        chartTag = {position = centerPosition, icon = signalID, text = label}
        
        
        local addedChartTag = nil
        local success = false
        
        success, addedChartTag = pcall(function()
            return force.add_chart_tag(surface, chartTag)
        end)
        
        if success and addedChartTag and type(addedChartTag) ~= "string" then
            addedChartTag.last_user = player
            
            local labeledResourceData = {
                    --entities = patch,
                    type = entity.name,
                    surface = surface,
                    bounds = stdlibAreaToFactorioArea(bounds),
                    label = addedChartTag
            }
            
            addLabeledResourceData(force, labeledResourceData)
        end
    end
end

function isAlreadyLabeled(force, surface, patch)
    local labelData = global.labeledResourcePatches[force.name]
    if not labelData then
        return false
    end
    if not global.settings["resource-labels-use-old-algorithm"] then
        return false
    end
    
    local bounds = Resource.get_resource_patch_bounds(patch)
    local centerPosition = Area.center(bounds)
    local type = table.first(patch).name
    return table.find(labelData, function(labeledResourceData)
        return labeledResourceData.surface.name == surface.name and labeledResourceData.type == type and Position.inside(centerPosition, labeledResourceData.bounds)
    end)
end

function getSignalID(entity)
    local signalID = nil
    
    local configEntry = ResourceConfig[entity.name]
    if configEntry then
        signalID = {type = configEntry.type, name = configEntry.icon}
    end
    
    return signalID
end

function getResourceCount(patch)
    local count = 0
    
    table.each(patch, function(entity)
        local amount
        if isInfiniteResource(entity) then
            amount = 100 * entity.amount / entity.prototype.normal_resource_amount
        else
            amount = entity.amount
        end
        count = count + amount
    end)
    
    return math.floor(count)
end

function numberToSiString(number)
    local result = number
    local thousands = 0
    
    while result >= 1000 do
        result = result / 1000
        thousands = thousands + 1
    end
    
    return string.format("%3d", result) .. SIunits[thousands]
end

function isInfiniteResource(entity)
    prototype = game.entity_prototypes[entity.name]
    return prototype and prototype.infinite_resource
end

function getLabel(entity)
    local label = ""
    
    local configEntry = ResourceConfig[entity.name]
    if configEntry then
        label = configEntry.label
    end
    
    return label
end

function addLabeledResourceData(force, labeledResourceData)
    if not global.labeledResourcePatches[force.name] then
        global.labeledResourcePatches[force.name] = {}
    end
    
    table.insert(global.labeledResourcePatches[force.name], labeledResourceData)
end

Event.register("resource-labels-remove",
    function(event)
        local player = Game.get_player(event.player_index)
        local force = player.force
        local currentTick = event.tick
        
        removeLabels(currentTick, player)
    end
)
function removeLabels(currentTick, player)
    local force = player.force
    
    if global.isLabeling[force.name] then
        local isLabeling = global.isLabeling[force.name]
        
        if currentTick <= isLabeling.stop then
            local initiator = isLabeling.initiator
            player.print{"resource-labels-remove-but-not-finished-msg", initiator, isLabeling.stop - currentTick}
        else
            removeLabelsUnconditionally(force)
        end
    end
end

function removeLabelsUnconditionally(force)
    local labelData = global.labeledResourcePatches[force.name]
    if labelData then
        table.each(labelData, function(labeledResourceData)
            local label = labeledResourceData.label
            if label.valid then
                label.destroy()
            end
        end)
        
        global.labeledResourcePatches[force.name] = nil
    end
end

function removeLabelsAfterChange()
    for forceName, _ in pairs(global.labeledResourcePatches) do
        removeLabelsUnconditionally(game.forces[forceName])
    end
end

--workaround for a bug with serpent, because the stdlib Area is converted to a string when loading
function stdlibAreaToFactorioArea(area)
    return {left_top = {x = area.left_top.x, y = area.left_top.y}, right_bottom = {x = area.right_bottom.x, y = area.right_bottom.y}}
end

function cacheSettings()
    local settings = {}
    cacheSetting(settings, "resource-labels-schedule-interval")
    cacheSetting(settings, "resource-labels-show-labels")
    cacheSetting(settings, "resource-labels-show-icons")
    cacheSetting(settings, "resource-labels-cooldown")
    cacheSetting(settings, "resource-labels-show-resource-count")
    cacheSetting(settings, "resource-labels-show-infinite-ores")
    cacheSetting(settings, "resource-labels-minimum-resource-count")
    cacheSetting(settings, "resource-labels-minimum-resource-entity-count")
    cacheSetting(settings, "resource-labels-maximum-resource-count")
    cacheSetting(settings, "resource-labels-show-unknown-entity-msg")
    cacheSetting(settings, "resource-labels-hide-coal")
    cacheSetting(settings, "resource-labels-hide-stone")
    cacheSetting(settings, "resource-labels-hide-oil")
    cacheSetting(settings, "resource-labels-hide-iron")
    cacheSetting(settings, "resource-labels-hide-copper")
    cacheSetting(settings, "resource-labels-hide-uranium")
    cacheSetting(settings, "resource-labels-use-old-algorithm")
    global.settings = settings
end

function cacheSetting(settingsTable, settingName)
    settingsTable[settingName] = settings.global[settingName].value
end
