local UPSPLUS_BOX_SIZE = settings.startup["BigContainersUPSPlus-box-size"].value
local MOD_SUFFIX = " UPS+"

local copies = {}
local function copy_boxes(boxes)
  for k, v in pairs(boxes) do
    local copy = table.deepcopy(v)
    copy.name = copy.name .. "-UPSPlus"
    copy.inventory_size = UPSPLUS_BOX_SIZE
    
    -- Avoid an ugly "missing key" error in gui
    local localised = copy.localised_name
    if (not localised)
    then
      copy.localised_name = {"", {"entity-name." .. v.name}, MOD_SUFFIX}
    else
      if (localised[1] == "")
      then
        -- concatenation
        table.insert(copy.localised_name, MOD_SUFFIX)
      else
        -- sorry but you get a generic name. It'll work well enough.
        copy.localised_name = {"", "Container", MOD_SUFFIX}
      end
    end
  
    table.insert(copies, copy)
  end
end

-- Copy all containers & logistic containers
copy_boxes(data.raw["container"])
copy_boxes(data.raw["logistic-container"])

-- Fun fact, if you do data:extend while you are iterating over
-- ... one of the above lists, you get an infinite loop!
-- >> You need to extend as a batch, after you've finished iterating.
data:extend(copies)