hl.window_rule({
	match = {
		class = "Flebop",
	},
	workspace = 3,
})

hl.window_rule({
	match = {
		class = "vesktop",
	},
	workspace = 4,
})

hl.window_rule({
	match = {
		class = "Spotify",
	},
	workspace = 5,
})

hl.window_rule({
	name = "steam",
	match = {
		class = "steam",
	},
	workspace = 1,
	no_initial_focus = true,
	center = true,
})

hl.window_rule({
	name = "pavu",
	match = {
		class = "org.pulseaudio.pavucontrol",
	},
	float = true,
	center = true,
	size = { "(monitor_w*0.35)", "(monitor_h*0.5)" },
})

hl.window_rule({
	name = "blueman-manager",
	match = {
		class = "blueman-manager",
	},
	size = { "(monitor_w*0.45)", "(monitor_h*0.75)" },
	float = true,
	center = true,
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "suppress-maximize-events",
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

-- ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
-- ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣤⣤⡄⠀⠀⠀⠀⢠⣤⣤⣤⡄⠀⠀⠀⠀⢠⣤⣤⣤⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
-- ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⣀⣀⣀⣀⣿⣿⣿⣿⣀⣀⣀⣀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
-- ⣿⠀⠿⠿⠀⣿⡇⠀⠤⠤⣼⣿⡇⠀⣿⣿⣿⡇⠀⢸⣿⣿⡇⠀⣤⣤⠀⢹⣿⠀⣿⡀⠹⡿⠁⣰⣿⠀⠀⠤⠤⣼⣿⠀⢠⣤⡄⢸⡟⠀⠤⠤⣽⣿
-- ⣿⠀⣤⣤⠀⣿⡇⠀⠒⠒⢻⣿⡇⠀⠛⠛⣿⡇⠀⠘⠛⢻⡇⠀⠛⠛⠀⣸⣿⠀⣿⣿⡀⠀⣰⣿⣿⠀⠀⠒⠒⢻⣿⠀⢠⣤⡄⢹⣟⠒⠒⠂⢈⣿
-- ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
-- ⣿⣷⣄⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣸⢀⡀⢀⡀⣧⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣠⣾⣿
-- ⣿⣿⣿⣷⣶⣶⣶⣶⣶⣶⣖⣒⣒⣒⣒⣒⣲⣖⣒⣒⣒⣒⣒⣯⣜⢡⡌⣃⣼⣒⣒⣒⣒⣒⣲⣖⣒⣒⣒⣒⣒⣲⣶⣶⣶⣶⣶⣶⣾⣿⣿⣿
-- ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⢸⣷⣤⣾⡇⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
-- ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⠛⠛⠃⠀⠀⠀⠀⠘⠛⠛⠛⠃⠀⠀⠀⠀⠘⠛⠛⠛⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
-- ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿

hl.window_rule({
	name = "helljivers",
	match = {
		class = "^(steam_app_553850)$",
		title = "^(HELLDIVERS™ 2)$",
	},
	workspace = 1,
	border_size = 0,
	float = true,
	size = { 2560, 1440 },
})
