-- CanalBuilderWLK
-- prototypes.waterfill

local function emptyPic()
    return {
        filename = "__core__/graphics/empty.png",
        priority = "high",
        width = 1,
        height = 1,
        shift = {0, 0}
    }
end

local function emptySprites()
    return {
        north = emptyPic(),
        east = emptyPic(),
        south = emptyPic(),
        west = emptyPic()
    }
end

-- technology
local waterfill_tech = {
    type = "technology",
    name = "waterfill-tech",
    icon = "__CanalBuilderWLK__/graphics/icons/waterfill_large.png",
    icon_size = 128,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "waterfill-recipe"
        }
    },
    prerequisites = {
        "landfill",
        "explosives"
    },
    unit = {
        count = 100,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 30
    },
    order = "a"
}

-- recipe
local waterfill_recipe = {
    type = "recipe",
    name = "waterfill-recipe",
    energy_required = 0.5,
    enabled = false,
    category = "crafting",
    ingredients = {
        {
            type = "item",
            name = "explosives",
            amount = 1
        },
    },
    result = "waterfill-item",
    result_count = 1
}

-- item
local waterfill_item = {
    type = "item",
    name = "waterfill-item",
    icon = "__CanalBuilderWLK__/graphics/icons/waterfill_small.png",
    icon_size = 32,
    flags = {},
    subgroup = "terrain",
    order = "c[landfill]-z-a[water]",
    stack_size = 100,
    place_result = "waterfill-placer"
}

-- entity (placer)
local waterfill_placer = table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
local updates = {
    name = "waterfill-placer",
    icon = "__CanalBuilderWLK__/graphics/icons/waterfill_small.png",
    icon_size = 32,
    picture = emptyPic(),
    collision_mask = {},
    collision_box = {{-.2, -.6}, {0.2, 0.3}}
}

for k, v in pairs(updates) do
    waterfill_placer[k] = updates[k]
end
waterfill_placer.fluid_box.pipe_covers = emptySprites()
waterfill_placer.graphics_set = nil -- otherwise picture is ignored
waterfill_placer.water_reflection = nil

data:extend({
    waterfill_tech,
    waterfill_recipe,
    waterfill_item,
    waterfill_placer,
    waterfill_actual
})
