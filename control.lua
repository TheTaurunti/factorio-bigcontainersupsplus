local SELECTOR_ITEM_NAME = "bcplus-selector"
local MOD_IDENTIFIER_SUFFIX = "-UPSPlus"
local SPILL_EXCESS_DONT_DELETE =
		settings.global["BigContainersUPSPlus-spill-excess"].value

-- ============================
-- Initialize Conversion Tables
-- ============================

local _NORMAL_TO_UPSPLUS = nil
local _UPSPLUS_TO_NORMAL = nil

local function _add_boxes()
	local suffix_len = string.len(MOD_IDENTIFIER_SUFFIX)
	_NORMAL_TO_UPSPLUS = {}
	_UPSPLUS_TO_NORMAL = {}

	local entity_prototypes = prototypes.entity
	for _, v in pairs(entity_prototypes) do
		if ((v.type == "container") or (v.type == "logistic-container")) then
			if (string.find(v.name, MOD_IDENTIFIER_SUFFIX)) then
				local name = string.sub(v.name, 1, string.len(v.name) - suffix_len)
				local upsplus_name = v.name

				_NORMAL_TO_UPSPLUS[name] = upsplus_name
				_UPSPLUS_TO_NORMAL[upsplus_name] = name
			end
		end
	end
end

-- Need these getters, because I can't access "prototypes.entity" while the script is loading.
-- ... It can only be done after an event occurs during gameplay
local function get_normal_to_ups_table()
	if (not _NORMAL_TO_UPSPLUS) then _add_boxes() end
	return _NORMAL_TO_UPSPLUS
end
local function get_ups_to_normal_table()
	if (not _UPSPLUS_TO_NORMAL) then _add_boxes() end
	return _UPSPLUS_TO_NORMAL
end

-- =================
-- Utility Functions
-- =================

local function is_selection_valid(event)
	if (not event.item) then return false end
	if (event.item ~= SELECTOR_ITEM_NAME) then return false end

	return true
end

local function transfer_inventory(old, new, event, position)
	local new_inventory = new.get_inventory(defines.inventory.chest)
	local old_inventory = old.get_inventory(defines.inventory.chest)
	old_inventory.sort_and_merge()

	local old_empty_stacks = old_inventory.count_empty_stacks()
	local slots_used_old = #old_inventory - old_empty_stacks

	local transfer_end_index_old = math.min(#new_inventory, slots_used_old)

	-- transfer contents
	for i = 1, transfer_end_index_old do
		new_inventory[i].set_stack(old_inventory[i])
	end


	if (SPILL_EXCESS_DONT_DELETE and (transfer_end_index_old < slots_used_old)) then
		for i = transfer_end_index_old + 1, slots_used_old do
			event.surface.spill_item_stack(position, old_inventory[i])
		end
	end
end

local function copy_circuit_connections(old, new)
	-- https://lua-api.factorio.com/stable/classes/LuaEntity.html#get_wire_connectors
	local connections = old.get_wire_connectors()
	--if (not connections) then return end

	for wire_id, luaWireConnector in pairs(connections) do
		local newLuaWireConnector = new.get_wire_connector(wire_id, true)

		for _, connection in ipairs(luaWireConnector.connections) do
			-- https://lua-api.factorio.com/stable/classes/LuaWireConnector.html#connect_to
			newLuaWireConnector.connect_to(connection.target)
		end
	end
end

local function copy_logistic_settings(old, new)
	if (old.type ~= "logistic-container") then return end

	local logistic_mode = old.prototype.logistic_mode
	if (logistic_mode == "storage")
	then
		new.storage_filter = old.storage_filter
		return
	end

	local is_buffer_or_requester = (logistic_mode == "buffer") or (logistic_mode == "requester")
	if (not is_buffer_or_requester) then return end

	-- set same requests
	local highest_request_index = old.request_slot_count
	for i = 1, highest_request_index do
		local request = old.get_request_slot(i)
		if (request)
		then
			new.set_request_slot(request, i)
		end
	end
end

local function replace_container_entities(event, replacement_table)
	if (not is_selection_valid(event)) then return end

	local player_local = game.players[event.player_index]

	for _, entity in ipairs(event.entities) do
		if (replacement_table[entity.name]) then
			-- Create replacement container (returns LuaEntity)
			local created = event.surface.create_entity {
				name = replacement_table[entity.name],
				position = entity.position,
				player = player_local,
				force = player_local.force
			}

			-- Keep as much information as you can.
			transfer_inventory(entity, created, event, entity.position)
			copy_circuit_connections(entity, created)
			copy_logistic_settings(entity, created)

			-- Clean up the old one.
			entity.destroy()
		end
	end
end

-- =================
-- Event Definitions
-- =================

script.on_event(defines.events.on_player_selected_area, function(event)
	replace_container_entities(event, get_normal_to_ups_table())
end)

script.on_event(defines.events.on_player_reverse_selected_area, function(event)
	replace_container_entities(event, get_ups_to_normal_table())
end)
