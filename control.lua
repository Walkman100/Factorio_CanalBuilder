-- CanalBuilderWLK
-- control

local isWaterTile = {
    ["water"] = true,
    ["deepwater"] = true
}
local isTrain = {
    ["locomotive"] = true,
    ["artillery-wagon"] = true,
    ["cargo-wagon"] = true,
    ["fluid-wagon"] = true
}
local placement = "waterfill-placer"
local replacement = "water"

-- announce self to other mods
remote.add_interface("CanalBuilder", {
    exists = function() return true end
})

-- aesthetic ripple
local function make_ripple(player)
    local p = player.position
    local surface = player.surface
    if isWaterTile[surface.get_tile(p).name] then
        local r = 2.5
        local area = {{p.x - r, p.y - r}, {p.x + r, p.y + r}}
        if surface.count_tiles_filtered({area = area, name = {"water", "deepwater"}, limit = 25}) >= 25 then
            -- only ripple if in large water patch
            if player.driving then
                surface.create_entity({name = "water-ripple" .. math.random(1, 4) .. "-smoke", position = {p.x,p.y+.75}})
            else
                surface.create_entity({name = "water-ripple" .. math.random(1, 4) .. "-smoke", position = {p.x,p.y}})
            end
        end
    end
end

-- aesthetic splash
local function make_splash(player)
    if isWaterTile[player.surface.get_tile(player.position).name] then
        local driving = player.driving
        if not driving or (driving and not isTrain[player.vehicle.name]) then
            player.surface.create_entity({name = "water-splash-smoke", position = player.position})
        end
    end
end

-- waterfill placer handler
local function replaceDummy(placed)
    local dir     = placed.direction
    local pos     = placed.position
    local surface = placed.surface

    placed.destroy()
    local tileArray = {}
    local i = 1

    if dir == defines.direction.north or dir == defines.direction.south then
        for x = -1, 1, 1 do
            tileArray[i] = {
                name = replacement,
                position = {pos.x + x, pos.y}
            }
            i = i + 1
        end
    elseif dir == defines.direction.east or dir == defines.direction.west then
        for y = -1, 1, 1 do
            tileArray[i] = {
                name = replacement,
                position = {pos.x, pos.y + y}
            }
            i = i + 1
        end
    end

    surface.set_tiles(tileArray)
end

-- check if biter is on water tile and slow down
local function waterSlowdown(entity)
    local isOnWater = isWaterTile[entity.surface.get_tile(entity.position).name]
    local isSlowed = false
    local stickers = entity.stickers
    if stickers ~= nil then
        for m = 1, #stickers, 1 do
            if stickers[m].name == "water-slowdown" then
                isSlowed = true
            end
        end
    end
    if isOnWater and not isSlowed then -- in water, slow down
        entity.surface.create_entity({
            name = "water-slowdown",
            position = entity.position,
            target = entity
        })
    end
end

-- biter slowdown handler
local function damageHandler(event)
    local entity = event.entity
    if entity.type == "unit" then
        if entity.force.name == "enemy" and entity.valid then -- if a biter..
            if entity.unit_group ~= nil then -- if in group, slow down all
                local attackGroup = entity.unit_group.members
                for i = 1, #attackGroup, 1 do
                    waterSlowdown(attackGroup[i])
                end
            else -- if ungrouped, slow down any surrounding
                local p = entity.position
                local r = 10
                local area = {{p.x - r, p.y - r}, {p.x + r, p.y + r}}
                local attackGroup = game.surfaces[1].find_entities_filtered({area=area, type="unit"})
                for i = 1, #attackGroup, 1 do
                    waterSlowdown(attackGroup[i]) -- if in group, slow down all
                end
            end
        end
    end
end

-- when player moves, ripple + splash
script.on_event(
    defines.events.on_player_changed_position,
    function(e)
        local player = game.players[e.player_index]
        if player.character then
            make_ripple(player)
            make_splash(player)
        end
    end
)

-- every now and then, ripple
script.on_event(
    defines.events.on_tick,
    function(event)
        local eTick = event.tick
        if eTick % 120 == 4 then
            for _, player in pairs(game.connected_players) do
                if player.character then
                    make_ripple(player)
                end
            end
        end
    end
)

-- when the waterfill placer is built
script.on_event(
    {defines.events.on_built_entity, defines.events.on_robot_built_entity},
    function(event)
        if event.created_entity.name == placement then replaceDummy(event.created_entity) end
    end
)

-- when something is damaged
script.on_event(
    defines.events.on_entity_damaged,
    damageHandler
)
