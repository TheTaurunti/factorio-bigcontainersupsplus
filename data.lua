data:extend({
  {
    type = "selection-tool",
    name = "bcplus-selector",
    icon = "__BigContainersUPSPlus__/planner-tool.png",
    icon_size = 64,
    icon_mipmaps = 6,
    flags = {
      "only-in-cursor",
      "spawnable",
      "not-stackable"
    },
    subgroup = "tool",
    order = "c[automated-construction]-a[bcplus]",
    stack_size = 1,
    stackable = false,

    select = {
      mode = { "buildable-type" },
      border_color = { r = 0.7, g = 0.7, b = 0 },
      cursor_box_type = "entity"
    },
    reverse_select = {
      mode = { "buildable-type" },
      border_color = { r = 0.9, g = 0.5, b = 0.1 },
      cursor_box_type = "entity"
    },


    -- alt_select is not used by mod, but still must be defined
    -- I am just giving it same settings as normal select.
    alt_select = {
      mode = { "buildable-type" },
      border_color = { r = 0.7, g = 0.7, b = 0 },
      cursor_box_type = "entity"
    }
  },
  {
    type = "shortcut",
    name = "bcplus-planner",
    icon = "__BigContainersUPSPlus__/planner-tool.png",
    small_icon = "__BigContainersUPSPlus__/planner-tool.png",
    order = "o[bcplus]",
    action = "spawn-item",
    localised_name = { "item-name.bcplus-selector" },
    item_to_spawn = "bcplus-selector",
    style = "blue",
  }
})
