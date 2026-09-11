function wesnoth.wml_actions.knockback(cfg)
	local knocker = wesnoth.units.find(wml.get_child(cfg, "filter_second"))[1]
	local all_knocked = wesnoth.units.find(wml.get_child(cfg, "filter"))
	local max_distance = cfg.distance or 1
	for i = 1,#all_knocked do
		local knocked = all_knocked[i]
		if knocked ~= nil then
			local direction = knocked.facing
			if knocker ~= nil then
				direction = wesnoth.map.get_relative_dir(knocker, knocked)
			end
			local target = wesnoth.map.get(knocked)
			local last_acceptable_target = target
			for distance = 1, max_distance do --luacheck: no unused
				local adj = {};
				adj["n"], adj["ne"], adj["se"], adj["s"], adj["sw"], adj["nw"] = wesnoth.map.get_adjacent_hexes(target)
				local potential_target = adj[direction]
				if wesnoth.current.map:on_board(potential_target) then
					local terrain = wesnoth.map.get(potential_target).terrain
					if knocked:movement_on(terrain) > knocked.max_moves then
						break -- Impassable, can't be knocked through
					end
				else
					break -- Can't be knocked out of the map
				end
				target = potential_target
				local occupier = wesnoth.units.find_on_map{x = potential_target.x, y = potential_target.y}
				if #occupier == 0 then
					last_acceptable_target = potential_target
				end
			end
			knocked:to_map(last_acceptable_target.x, last_acceptable_target.y)
		end
	end
end
