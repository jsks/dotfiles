-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local scratch = require("scratch")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "ehm.",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Abandon ship!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/cloud/.config/awesome/theme/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "termite"
browser = "chromium"
editor = os.getenv("EDITOR") or "emacsclient -nw"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,
    awful.layout.suit.max
}
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("<span color='" .. beautiful.fg_textclock .. "'>%H:%M</span>")

function createtags(layouts)
   for i, l in ipairs(layouts) do
      awful.tag.add(i, { screen = 1, layout = l, idx = i })
   end

   return screen[1].tags
end

local sharedtags = createtags({
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[2],
      awful.layout.layouts[3],
      awful.layout.layouts[4],
      awful.layout.layouts[1],
      awful.layout.layouts[3],
      awful.layout.layouts[1],
      awful.layout.layouts[1]
})

awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 15 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
            s.mypromptbox,
        },
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () awful.spawn(terminal) end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              { description = "show help", group = "awesome" }),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              { description = "view previous", group = "tag" }),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              { description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              { description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              { description = "quit awesome", group = "awesome" }),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              { description = "run prompt", group = "launcher" }),

    awful.key({ modkey }, "F2",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              { description = "lua execute prompt", group = "awesome" }),

    -- Personal Keybindings
    awful.key({ modkey, "Control" }, "f", function () awful.spawn("chromium") end,
        { description = "run chromium" }),
    awful.key({ modkey,           }, "x", function()
        scratch.drop("termite", "top", "center", 0.65, 0.20, true) end,
        { description = "dropdown terminal" }),
    awful.key({ modkey,           }, "e", function() awful.spawn("emacsclient -c") end,
        { description = "spawn emacs" })
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              { description = "move to master", group = "client" }),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              { description = "move to screen", group = "client" }),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        { description = "minimize", group = "client" }),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        { description = "maximize", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local tag = sharedtags[i]
                        local tagscreen = tag.screen
                        local screen = awful.screen.focused()
                        
                        if tag then
                           local prevtag = tagscreen.selected_tag
                           awful.tag.setscreen(screen, tag)
                           awful.tag.history.update(tagscreen)

                           
                           if tagscreen ~= screen and prevtag then
                              if prevtag == tag then
                                 if not tagscreen.selected_tag then
                                    local filteredtags = { }
                                    for _, t in ipairs(tagscreen.tags) do
                                        if t ~= tag and #t:clients() == 0 then
                                           table.insert(filteredtags, t)
                                        end
                                    end

                                    local fallback = awful.tag.find_fallback(tagscreen, filteredtags)
                                    if fallback then fallback:view_only() end
                                 end
                              else
                                 prevtag.selected = true
                              end
                           end


                           tag:view_only()

                           for _, s in ipairs({ screen, tagscreen }) do
                              for _, t in ipairs(s.tags) do
                                 awful.tag.setproperty(t, "index", awful.tag.getproperty(t, "idx"))
                              end
                           end
                        end
                  end,
                  { description = "view tag #" .. i, group = "tag" }),

        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local tag = sharedtags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  { description = "toggle tag #" .. i, group = "tag" }),

        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = sharedtags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  { description = "move focused client to tag #"..i, group = "tag" }),

        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = sharedtags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    { rule = { class = "chromium" },
      properties = { floating = false, tag = sharedtags[3], switchtotag = true } },
    { rule = { class = "Xstata-se" },
      properties = { floating = false, tag = sharedtags[5], switchtotag = true } },
    { rule = { class = "Emacs" },
      properties = { floating = false, tag = sharedtags[2], switchtotag = true } },
    { rule = { class = "Gnumeric" },
      properties = { floating = false, maximized_vertical = true, maximized_horizontal = true,
                     sharedtag = sharedtags[4], switchtotag = true } },
    { rule = { class = "Zathura" },
      properties = { floating = false, tag = sharedtags[6], switchtotag = true } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
