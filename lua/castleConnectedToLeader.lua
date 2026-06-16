function castle_connected_to_leader(x, y, side)

    -- find the leader on a keep
    local leaders = wesnoth.units.find {
        side = side,
        canrecruit = true,
        { "filter_location", { terrain = "K*" } }
    }

    if #leaders == 0 then
        return false
    end

    local leader = leaders[1]
    local lx, ly = leader.x, leader.y

    -- pathfinder restricted to castle/keep tiles
    local path = wesnoth.paths.find_path(
        x, y,
        lx, ly,
        {
            terrain_costs = function(tile)
                -- allow only castle or keep
                if tile.castle or tile.keep then
                    return 1
                end
                return wesnoth.paths.UNREACHABLE
            end
        }
    )

    return path and #path > 0
end