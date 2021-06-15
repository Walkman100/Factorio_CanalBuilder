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
local waterfill_placer = {
    type = "offshore-pump",
    name = "waterfill-placer",
    icon = "__CanalBuilderWLK__/graphics/icons/waterfill_small.png",
    icon_size = 32,
    picture = emptyPic(),
    collision_mask = {},
    collision_box = {{-0.2, -0.6}, {0.2, 0.3}},
    center_collision_mask = {"water-tile", "object-layer", "player-layer"},
    flags = {"placeable-neutral", "player-creation", "filter-directions"},
    fluid = "water",
    fluid_box = {
        filter = "water",
        pipe_connections = {
            {
                position = {0, 1},
                type = "output"
            }
        },
        production_type = "output"
    },
    placeable_position_visualization = {
        priority = "extra-high-no-scale",
        filename = "__core__/graphics/cursor-boxes-32x32.png",
        x = 192,
        height = 64,
        width = 64,
        scale = 0.5
    },
    pumping_speed = 20,
}

data:extend({
    waterfill_tech,
    waterfill_recipe,
    waterfill_item,
    waterfill_placer
})
