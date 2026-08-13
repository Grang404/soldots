hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 1,

		col = {
			active_border = { colors = { "rgba(6c394b00)", "rgba(28151c00)" }, angle = 45 },
			inactive_border = "rgba(3f4043cc)",
		},

		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 1,
		inactive_opacity = 1,

		shadow = {
			enabled = false,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			ignore_opacity = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},
})
