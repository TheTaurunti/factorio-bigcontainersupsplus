local UPSPLUS_BOX_SIZE = settings.startup["BigContainersUPSPlus-box-size"].value
local COPY_LOGISTIC_BOXES = settings.startup["BigContainersUPSPlus-copy-logistic"].value
local LOCALIZATION_SUFFIX = " UPS+"

local items = data.raw["item"]

local function make_copy(prototype)
  local copy = table.deepcopy(prototype)
  copy.name = copy.name .. "-UPSPlus"

  -- Avoid an ugly "missing key" error in gui
  local localised = copy.localised_name
  if (not localised)
  then
    copy.localised_name = { "", { "entity-name." .. prototype.name }, LOCALIZATION_SUFFIX }
  else
    if (localised[1] == "")
    then
      -- concatenation
      table.insert(copy.localised_name, LOCALIZATION_SUFFIX)
    else
      -- sorry but you get a generic name. It'll work well enough.
      copy.localised_name = { "", "Container", LOCALIZATION_SUFFIX }
    end
  end

  -- obviously, we can just use the original's value if this is defined
  -- If an obvious item exists for this building (same exact name)
  -- ... then it can be placeable by that. If not, set a coin (normally unobtainable)
  -- ... just so it can be deconstructed / copied / whatever
  if (not copy.placeable_by)
  then
    local item_or_coin = items[prototype.name] and items[prototype.name].name or "coin"
    copy.placeable_by = { item = item_or_coin, count = 1 }
  end

  return copy
end

local copies = {}
local function copy_boxes(boxes)
  for _, v in pairs(boxes) do
    local copy = make_copy(v)
    copy.inventory_size = UPSPLUS_BOX_SIZE

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

data:extend(copies)


-- space age cargo bay compat inline
-- > Not using UPSPLUS_BOX_SIZE here intentionally.
if mods["space-age"] then
  local cargo_bay = data.raw["cargo-bay"]["cargo-bay"]
  if (cargo_bay)
  then
    local cargo_bay_copy = make_copy(cargo_bay)
    cargo_bay_copy.inventory_size_bonus = 1

    data:extend({ cargo_bay_copy })
  end
end
