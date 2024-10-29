data:extend({
	{
		type = "bool-setting",
		name = "BigContainersUPSPlus-copy-logistic",
		setting_type = "startup",
		default_value = true,
		order = "1"
	},
	{
		type = "bool-setting",
		name = "BigContainersUPSPlus-spill-excess",
		setting_type = "runtime-global",
		default_value = true,
		order = "2"
	},
	{
		type = "int-setting",
		name = "BigContainersUPSPlus-box-size",
		setting_type = "startup",
		default_value = 10,
		minimum_value = 1,
		order = "3"
	}
})
