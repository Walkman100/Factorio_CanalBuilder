-- CanalBuilder
-- abilities.swimming

local swimSpeed = 0.5

-- Remove collision mask
local mask = data.raw.tile["water"].collision_mask
for i=#mask,1,-1 do
	if mask[i] == "player-layer" then
		table.remove(mask, i)
	end
end

-- adjust player and vehicle speed
data.raw.tile["water"].vehicle_friction_modifier = 6 / swimSpeed
data.raw.tile["water"].walking_speed_modifier    = swimSpeed
data.raw.sticker["water-slowdown"].target_movement_modifier = swimSpeed