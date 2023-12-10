data:extend({
  {
    type = "bool-setting",
    name = "BigContainersUPSPlus-spill-excess",
    setting_type = "runtime-global",
    default_value = true
  },
  {
    type = "int-setting",
    name = "BigContainersUPSPlus-box-size",
    setting_type = "startup",
    default_value = 10,
    minimum_value = 1
  }
})