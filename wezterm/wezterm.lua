-- Import the wezterm module
local wezterm = require("wezterm")

-- Creates the object which we will be adding our config to
local config = wezterm.config_builder()

local projects = require("projects")

-- Tab formatting
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane

	-- Get current working directory more reliably
	local cwd = pane.current_working_dir
	local project = "terminal"

	if cwd then
		if type(cwd) == "userdata" then
			-- For newer versions of WezTerm
			project = cwd.file_path:match("[/\\]([^/\\]+)$") or "terminal"
		elseif type(cwd) == "string" then
			-- For older versions of WezTerm
			project = cwd:match("[/\\]([^/\\]+)$") or "terminal"
		end
	end

	-- Add indicators for pane count and zoom status
	local pane_count = #tab.panes > 1 and string.format(" [%d]", #tab.panes) or ""
	local zoom_indicator = pane.is_zoomed and " 🔍" or ""

	-- Format title (without icon)
	local title = string.format("%s%s%s", project, pane_count, zoom_indicator)

	-- Apply formatting
	if tab.is_active then
		return {
			{ Background = { Color = "#3012a1" } },
			{ Foreground = { Color = "#ffffff" } },
			{ Text = " " .. title .. " " },
		}
	else
		return {
			{ Background = { Color = "#333333" } },
			{ Foreground = { Color = "#bbbbbb" } },
			{ Text = " " .. title .. " " },
		}
	end
end)

-- This is where the config will go

config.color_scheme = "Tokyo Night"

config.font = wezterm.font({ family = "SpaceMono Nerd Font" })
config.font_size = 15

config.window_background_opacity = 0.7
config.macos_window_background_blur = 40
config.window_decorations = "RESIZE"

config.window_frame = {
	font = wezterm.font({ family = "SpaceMono Nerd Font", weight = "Bold" }),
	font_size = 11,
}

local function segments_for_right_status(window)
	return {
		window:active_workspace(),
		wezterm.strftime("%a %b %-d %H:%M"),
		wezterm.hostname(),
	}
end

wezterm.on("update-status", function(window, _)
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	local segments = segments_for_right_status(window)

	local color_scheme = window:effective_config().resolved_palette
	-- Note the use of wezterm.color.parse here, this returns
	-- a Color object, which comes with functionality for lightening
	-- or darkening the colour (amongst other things).
	local bg = wezterm.color.parse("#3012a1")
	local fg = color_scheme.foreground

	-- Each powerline segment is going to be coloured progressively
	-- darker/lighter depending on whether we're on a dark/light colour
	-- scheme. Let's establish the "from" and "to" bounds of our gradient.
	local gradient_to = bg
	local gradient_from = gradient_to:darken(0.6)

	-- Yes, WezTerm supports creating gradients, because why not?! Although
	-- they'd usually be used for setting high fidelity gradients on your terminal's
	-- background, we'll use them here to give us a sample of the powerline segment
	-- colours we need.
	local gradient = wezterm.color.gradient(
		{
			orientation = "Horizontal",
			colors = { gradient_from, gradient_to },
		},
		#segments -- only gives us as many colours as we have segments.
	)

	-- We'll build up the elements to send to wezterm.format in this table.
	local elements = {}

	for i, seg in ipairs(segments) do
		local is_first = i == 1

		if is_first then
			table.insert(elements, { Background = { Color = "none" } })
		end
		table.insert(elements, { Foreground = { Color = gradient[i] } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })

		table.insert(elements, { Foreground = { Color = fg } })
		table.insert(elements, { Background = { Color = gradient[i] } })
		table.insert(elements, { Text = " " .. seg .. " " })
	end

	window:set_right_status(wezterm.format(elements))
end)

config.set_environment_variables = {
	PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
}

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

local function move_pane(key, direction)
	return {
		key = key,
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection(direction),
	}
end

local function resize_pane(key, direction)
	return {
		key = key,
		action = wezterm.action.AdjustPaneSize({ direction, 3 }),
	}
end

config.keys = {
	{
		key = ",",
		mods = "SUPER",
		action = wezterm.action.SpawnCommandInNewTab({
			cwd = wezterm.home_dir,
			args = { "nvim", wezterm.config_file },
		}),
	},
	{
		-- I'm used to tmux bindings, so am using the quotes (") key to
		-- split horizontally, and the percent (%) key to split vertically.
		key = '"',
		-- Note that instead of a key modifier mapped to a key on your keyboard
		-- like CTRL or ALT, we can use the LEADER modifier instead.
		-- This means that this binding will be invoked when you press the leader
		-- (CTRL + A), quickly followed by quotes (").
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "%",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "a",
		-- When we're in leader mode _and_ CTRL + A is pressed...
		mods = "LEADER|CTRL",
		-- Actually send CTRL + A key to the terminal
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	{
		-- When we push LEADER + R...
		key = "r",
		mods = "LEADER",
		-- Activate the `resize_panes` keytable
		action = wezterm.action.ActivateKeyTable({
			name = "resize_panes",
			-- Ensures the keytable stays active after it handles its
			-- first keypress.
			one_shot = false,
			-- Deactivate the keytable after a timeout.
			timeout_milliseconds = 1000,
		}),
	},
	move_pane("j", "Down"),
	move_pane("k", "Up"),
	move_pane("h", "Left"),
	move_pane("l", "Right"),
	{
		key = "p",
		mods = "LEADER",
		-- Present in to our project picker
		action = projects.choose_project(),
	},
	{
		key = "f",
		mods = "LEADER",
		-- Present a list of existing workspaces
		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
}

config.key_tables = {
	resize_panes = {
		resize_pane("j", "Down"),
		resize_pane("k", "Up"),
		resize_pane("h", "Left"),
		resize_pane("l", "Right"),
	},
}

return config
