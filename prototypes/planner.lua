data:extend({
  {
    type = "selection-tool",
    name = "bcplus-selector",
    icon = "__BigContainersUPSPlus__/prototypes/tool.png",
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

    selection_mode = { "buildable-type" },
    selection_color = { r = 0.7, g = 0.7, b = 0 },
    selection_cursor_box_type = "entity",

    -- Not actually using alt mode, so give it same settings?
    alt_selection_mode = { "buildable-type" },
    alt_selection_color = { r = 0.7, g = 0.7, b = 0 },
    alt_selection_cursor_box_type = "entity",

    --
    reverse_selection_mode = { "buildable-type" },
    reverse_selection_color = { r = 0.9, g = 0.5, b = 0.1 },
    reverse_selection_cursor_box_type = "entity"
  },
  {
    type = "shortcut",
    name = "bcplus-planner",
    icon = {
      filename = "__BigContainersUPSPlus__/prototypes/tool.png",
      size = 64,
      flags = {
        "mipmap"
      },
      mipmaps = 4,
    },
    order = "o[bcplus]",
    action = "spawn-item",
    localised_name = { "item-name.bcplus-selector" },
    item_to_spawn = "bcplus-selector",
    style = "blue",
  }
})
