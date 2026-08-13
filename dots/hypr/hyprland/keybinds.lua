local home = os.getenv("HOME")

local terminal = "kitty"
local browser = "firefox"
local menu = home .. "/.config/rofi/scripts/groobofi"
local keybinds = home .. "/.config/rofi/scripts/keybinds"
local powermenu = home .. "/.config/rofi/scripts/power"
local process = home .. "/.config/rofi/scripts/process"
local wallpaper = home .. "/.config/rofi/scripts/wallpaper"
local random = home .. "/.config/hypr/scripts/random"

hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal)) -- Terminal
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser)) -- Browser
hl.bind("SUPER + R", hl.dsp.exec_cmd(menu)) -- App Menu
hl.bind("SUPER + X", hl.dsp.exec_cmd(keybinds)) -- Keybinds
hl.bind("SUPER + P", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only")) -- Screenshot Region
hl.bind("SUPER + CONTROL + P", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only")) -- Screenshot Output
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock")) -- Lock Screen
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd(powermenu)) -- Power Menu
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd(process)) -- Process Menu
hl.bind("SUPER + I", hl.dsp.exec_cmd(wallpaper)) -- Wallpaper Picker
hl.bind("SUPER + ALT + I", hl.dsp.exec_cmd(random)) -- Random Wallpaper
hl.bind("SUPER + CONTROL + ALT + P", hl.dsp.exec_cmd("hyprpicker -a")) -- Color Picker

-- Window Manipulation

hl.bind("SUPER + C", hl.dsp.window.close()) -- Close Window
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" })) -- Toggle Floating
hl.bind("SUPER + D", hl.dsp.layout("togglesplit")) -- Toggle Split
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = 0, action = "toggle" })) -- Toggle Fullscreen
hl.bind("SUPER + M", hl.dsp.window.fullscreen({ mode = 1, action = "toggle" })) -- Maximise Window
hl.bind("SUPER + T", hl.dsp.window.alter_zorder({ mode = "top" })) -- Move Floating Window to Top

-- Workspaces

hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic")) -- Spoopy magic workspace
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" })) -- Move to Spoopyspace

-- Navigate Windows

hl.bind("SUPER + J", hl.dsp.focus({ direction = "left" })) -- Move Focus Left
hl.bind("SUPER + K", hl.dsp.focus({ direction = "right" })) -- Move Focus Right
hl.bind("SUPER + H", hl.dsp.focus({ direction = "up" })) -- Move Focus Up
hl.bind("SUPER + L", hl.dsp.focus({ direction = "down" })) -- Move Focus Down

-- Switching Workspaces / Move Window to Workspace

for i = 1, 9 do
	local key = i % 10
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mouse

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- Drag Window
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Resize Window

-- Media Keys (playerctl)

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
