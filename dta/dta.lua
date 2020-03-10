local dta = {}

----------------------------------------------------------------------
-- MODULE PROPERTIES
----------------------------------------------------------------------

dta.animation_groups      = {}
dta.animation_groups_loop = {}
dta.animation_groups_once = {}

dta.tilemap_relative_path = nil
dta.tilemap_layer_ids     = {}
dta.tilemap_start_x       = 0
dta.tilemap_start_y       = 0
dta.tilemap_width         = 0
dta.tilemap_height        = 0
dta.tilemap_tiles         = {}

----------------------------------------------------------------------
-- MODULE PLAYBACKS
----------------------------------------------------------------------

function dta.loop_forward(data)
	data["frame"] = data["frame"] + 1
	if data["frame"] > data["end_tile"] then
		data["frame"] = data["start_tile"]
	end
end

function dta.loop_backward(data)
	data["frame"] = data["frame"] - 1
	if data["frame"] < data["start_tile"] then
		data["frame"] = data["end_tile"]
	end
end

function dta.loop_pingpong(data)
	if data["extra"] == 0 then
		data["frame"] = data["frame"] + 1
		if data["frame"] > data["end_tile"] then
			data["frame"] = data["end_tile"] - 1
			data["extra"] = 1
		end
	else
		data["frame"] = data["frame"] - 1
		if data["frame"] < data["start_tile"] then
			data["frame"] = data["start_tile"] + 1
			data["extra"] = 0
		end
	end
end

function dta.loop_corolla(data)
	if data["extra"] > 0 then
		data["extra"] = -data["extra"]
		data["frame"] = data["start_tile"]
	else
		data["extra"] = -data["extra"] + 1
		data["frame"] = data["start_tile"] + data["extra"]
		if data["frame"] > data["end_tile"] then
			data["frame"] = data["start_tile"] + 1
			data["extra"] = 1
		end
	end
end

function dta.once_forward(data)

end

function dta.once_backward(data)

end

function dta.once_pingpong(data)

end

function dta.once_corolla(data)

end

dta.playbacks_loop = {
	loop_forward  = dta.loop_forward,
	loop_backward = dta.loop_backward,
	loop_pingpong = dta.loop_pingpong,
	loop_corolla  = dta.loop_corolla
}

dta.playbacks_once = {
	once_forward  = dta.once_forward,
	once_backward = dta.once_backward,
	once_pingpong = dta.once_pingpong,
	once_corolla  = dta.once_corolla
}

----------------------------------------------------------------------
-- MODULE FUNCTIONS
----------------------------------------------------------------------

function dta.ternary(condition, ret_true, ret_false)
	return condition and ret_true or ret_false
end

function dta.set_tile_once()
	
end

function dta.timer_callback_once()
	
end

function dta.configure_animation_groups_once()
	
end

function dta.set_tile_loop(start_tile, frame)
	for position, data in pairs(dta.tilemap_tiles[start_tile]) do
		tilemap.set_tile(dta.tilemap_relative_path, data["layer_id"], data["x"], data["y"], frame)
	end
end

function dta.timer_callback_loop(self, handle, time_elapsed)
	for start_tile, data in pairs(dta.animation_groups_loop) do
		if data["handle"] == handle then
			data["elapsed"] = data["elapsed"] + time_elapsed
			if data["elapsed"] >= data["step"] then
				data["elapsed"] = 0
				dta.playbacks_loop[data["playback"]](data)
				dta.set_tile_loop(start_tile, data["frame"])
			end
		end
	end
end

function dta.configure_animation_groups_loop()
	for start_tile, data in pairs(dta.animation_groups) do
		if dta.playbacks_loop[data["playback"]] ~= nil then
			local handle = timer.delay(data["step"], true, dta.timer_callback_loop)
			local frame = dta.ternary(data["playback"] == "loop_backward", dta["end_tile"], start_tile)
			dta.animation_groups_loop[start_tile] = { start_tile = start_tile, end_tile = data["end_tile"], playback = data["playback"], step = data["step"], handle = handle, frame = frame, elapsed = 0, extra = 0 }
		end
	end
end

function dta.configure_animation_groups()
	dta.configure_animation_groups_loop()
	dta.configure_animation_groups_once()
end

function dta.configure_tilemap_tiles()
	local map_length_x = dta.tilemap_start_x + dta.tilemap_width - 1
	local map_length_y = dta.tilemap_start_y + dta.tilemap_height - 1
	for i = 1, #dta.tilemap_layer_ids do
		for j = dta.tilemap_start_y, map_length_y do
			for k = dta.tilemap_start_x, map_length_x do
				local start_tile = tilemap.get_tile(dta.tilemap_relative_path, dta.tilemap_layer_ids[i], k, j)
				if dta.animation_groups[start_tile] ~= nil then
					local data = { start_tile = start_tile, layer_id = dta.tilemap_layer_ids[i], x = k, y = j }
					if dta.tilemap_tiles[start_tile] == nil then
						dta.tilemap_tiles[start_tile] = {}
					end
					dta.tilemap_tiles[start_tile][k + (j - 1) * dta.tilemap_width] = data
				end
			end
		end
	end
end

----------------------------------------------------------------------
-- USER FUNCTIONS
----------------------------------------------------------------------

function dta.init(animation_groups, tilemap_relative_path, tilemap_layer_ids)
	dta.animation_groups = animation_groups
	dta.configure_animation_groups()
	local x, y, w, h = tilemap.get_bounds(tilemap_relative_path)
	dta.tilemap_relative_path = tilemap_relative_path
	dta.tilemap_layer_ids = tilemap_layer_ids
	dta.tilemap_start_x = x
	dta.tilemap_start_y = y
	dta.tilemap_width = w
	dta.tilemap_height = h
	dta.configure_tilemap_tiles()
end

return dta