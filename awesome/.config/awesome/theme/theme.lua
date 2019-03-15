---------------------------
-------------------
-- Awesome theme --
-------------------

local theme = {}

theme.font          = "EnvyCodeR 9"

theme.fg_black          = "#443236"
theme.fg_red            = "#BE7765"
theme.fg_green          = "#96BE65"
theme.fg_yellow         = "#FCD384"
theme.fg_blue           = "#9FB5C2"
theme.fg_magenta        = "#9B7E9B"
theme.fg_cyan           = "#76AF92"
theme.fg_white          = "#F8F5E2"

theme.bg_normal     = "#514C4C"
theme.bg_focus      = "#00000000"
theme.bg_urgent     = "#FFFFFF"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal
theme.bg_statusbar  = "png:/home/cloud/.config/awesome/theme/bg.png"

theme.fg_normal     = theme.fg_white
theme.fg_focus      = theme.fg_blue
theme.fg_urgent     = theme.fg_red
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = 0
theme.border_width  = 5
theme.border_normal = theme.fg_white
theme.border_focus  = theme.fg_blue
theme.border_marked = theme.fg_red

theme.fg_textclock      = theme.fg_blue

theme.layout_tile       = "<span color='" .. theme.fg_blue.. "'>[=]</span>"
theme.layout_tilebottom = "<span color='" .. theme.fg_blue.. "'>[_]</span>"
theme.layout_floating   = "<span color='"..theme.fg_blue.."'>[*]</span>"
theme.layout_max        =  "<span color='"..theme.fg_blue.."'>[X]</span>"


-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
