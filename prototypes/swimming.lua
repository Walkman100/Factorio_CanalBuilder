-- CanalBuilder
-- prototypes.swimming

-- sounds
data.raw.tile["water"].walking_sound = {
    {
        filename = "__CanalBuilderWLK__/sounds/water-1.ogg",
        volume = 0.8
    },
    {
        filename = "__CanalBuilderWLK__/sounds/water-2.ogg",
        volume = 0.8
    },
    {
        filename = "__CanalBuilderWLK__/sounds/water-3.ogg",
        volume = 0.8
    }
}

-- water splash animations
data:extend({
    {
        type = "smoke-with-trigger",
        name = "water-splash-smoke",
        flags = {"not-on-map", "placeable-off-grid"},
        render_layer = "water-tile",
        show_when_smoke_off = true,
        deviation = {0, 0},
        start_scale = 1,
        end_scale = 1,
        animation = {
            filename = "__base__/graphics/entity/water-splash/water-splash.png",
            priority = "extra-high",
            width = 92,
            height = 66,
            frame_count = 15,
            line_length = 5,
            shift = {-0.437, 0.5},
            animation_speed = 0.35
        },
        slow_down_factor = 0,
        affected_by_wind = false,
        cyclic = false,
        duration = 43,
        fade_away_duration = 0,
        spread_duration = 0,
        color = {
            r = 0.8,
            g = 0.8,
            b = 0.8
        },
        action = nil,
        action_cooldown = 0
    }
})

-- ripple animations
for i=1,4 do
    data:extend({
        {
            type = "smoke-with-trigger",
            name = "water-ripple" .. i .. "-smoke",
            flags = {"not-on-map", "placeable-off-grid"},
            render_layer = "water-tile",
            show_when_smoke_off = true,
            deviation = {0, 0},
            animation = {
                filename = "__CanalBuilderWLK__/graphics/ripple" .. i .. ".png",
                priority = "extra-high",
                width = 192,
                height = 128,
                frame_count = 48,
                line_length = 8,
                shift = {0, 0.5},
                animation_speed = 0.25
            },
            slow_down_factor = 0,
            affected_by_wind = false,
            cyclic = false,
            duration = 192,
            fade_away_duration = 0,
            spread_duration = 0,
            color = {
                r = 0.3,
                g = 0.8,
                b = 0.9
            },
            action = nil,
            action_cooldown = 0
        }
    })
end

-- water splash and slowdown for biters
data:extend({
    {
        animation = {
            filename = "__base__/graphics/entity/water-splash/water-splash.png",
            priority = "extra-high",
            width = 92,
            height = 66,
            frame_count = 15,
            line_length = 5,
            shift = {-0.437, 0.5},
            animation_speed = 0.35
        },
        duration_in_ticks = 60,
        flags = {},
        name = "water-slowdown",
        target_movement_modifier = 0.5,
        type = "sticker"
    }
})
