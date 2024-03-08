local UPSPLUS_BOX_SIZE = settings.startup["BigContainersUPSPlus-box-size"].value
local COPY_LOGISTIC_BOXES = settings.startup["BigContainersUPSPlus-copy-logistic"].value
local MOD_SUFFIX = " UPS+"

local items = data.raw["item"]

local copies = {}
local function copy_boxes(boxes)
  for _, v in pairs(boxes) do
    local copy = table.deepcopy(v)
    copy.name = copy.name .. "-UPSPlus"
    copy.inventory_size = UPSPLUS_BOX_SIZE

    -- Avoid an ugly "missing key" error in gui
    local localised = copy.localised_name
    if (not localised)
    then
      copy.localised_name = { "", { "entity-name." .. v.name }, MOD_SUFFIX }
    else
      if (localised[1] == "")
      then
        -- concatenation
        table.insert(copy.localised_name, MOD_SUFFIX)
      else
        -- sorry but you get a generic name. It'll work well enough.
        copy.localised_name = { "", "Container", MOD_SUFFIX }
      end
    end

    -- obviously, we can just use the original's value if this is defined
    -- If an obvious item exists for this building (same exact name)
    -- ... then it can be placeable by that. If not, set a coin (normally unobtainable)
    -- ... just so it can be deconstructed / copied / whatever
    if (not v.placeable_by)
    then
      local item_or_coin = items[v.name] and items[v.name].name or "coin"
      copy.placeable_by = { item = item_or_coin, count = 1 }
    end


    table.insert(copies, copy)
  end
end

-- Copy all containers always
copy_boxes(data.raw["container"])

-- Option for copying logistic boxes (because they are likely used much less?)
if (COPY_LOGISTIC_BOXES)
then
  copy_boxes(data.raw["logistic-container"])
end

-- Fun fact, if you do data:extend while you are iterating over
-- ... one of the above lists, you get an infinite loop!
-- >> You need to extend as a batch, after you've finished iterating.
data:extend(copies)
