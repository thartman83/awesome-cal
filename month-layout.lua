-------------------------------------------------------------------------------
-- month-layout.lua for awesome-cal                                          --
-- Copyright (c) 2017 Tom Hartman (thartman@hudco.com)                       --
--                                                                           --
-- This program is free software; you can redistribute it and/or             --
-- modify it under the terms of the GNU General Public License               --
-- as published by the Free Software Foundation; either version 2            --
-- of the License, or the License, or (at your option) any later             --
-- version.                                                                  --
--                                                                           --
-- This program is distributed in the hope that it will be useful,           --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of            --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             --
-- GNU General Public License for more details.                              --
-------------------------------------------------------------------------------

--- Commentary -- {{{
-- 
-- }}}

--- month-layout -- {{{

--- Locals and Constants -- {{{
local wibox = require("wibox")
local os    = require("os")

local day_names    = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
                       "Friday", "Saturday" }
local day_labels   = {"Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"}
local month_labels = {"January", "Febuary", "March", "April", "May", "June",
                      "July", "August", "September", "October", "November",
                      "Decemeber"}
local day_sec      = 86400

local month_layout = {}
-- }}}

--- month_layout:month_info -- {{{
-- 
function month_layout:month_info (date)
   local d = date
   local beg_month = os.date("*t", os.time({ day = 1, month = d.month,
                                             year = d.year }))
   local end_month = os.date("*t", os.time({ day = 1, month = d.month + 1,
                                             year = d.year}) - self.day_sec)
   local beg_offset = beg_month.wday-1
   local end_offset = 7 - end_month.wday
   if end_offset == 7 then
      end_offset = 0
   end
   
   return beg_offset, end_month, end_offset
end
-- }}}

--- month_layout:day_list -- {{{
-- 
function month_layout:day_list (beg_month_offset, end_month, end_month_offset)
   local days = {}
   for i=1, beg_month_offset do
      table.insert(days, "  ")
   end

   for i=1, end_month.day do
      table.insert(days, tostring(i))
   end

   for i=1, end_month_offset do
      table.insert(days, tostring("  "))
   end

   return days
end
-- }}}

--- month_layout:populate_layout -- {{{
-- 
function month_layout:populate_layout (display_args)
   local display_args = {}
   local day          = display_args.day   or self.display_day
   local month        = display_args.month or self.display_month
   local year         = display_args.year  or self.display_year

   -- clear the layout of existing widgets
   self:clear()

   local beg_mo, end_mo, end_off = month_info(os.date("*t", os.time({day = 1,
                                                                     month = month,
                                                                     year = year})))

   local dl = self:day_list(beg_mo, end_mo, end_off)
   for i,v in dl do
      self.add_widget(wibox.widget.textbox(v))
   end
   
   self.display_day   = day
   self.display_month = month
   self.display_year  = year
end
-- }}}

--- new -- {{{
-- Returns a new layout widget with the month information populated
local function new (args)
   local args  = args or {}

   local retval = wibox.widget {
      forced_num_cols = #day_labels,
      orientation = 'vertical',
      horizontal_homogeneous = true,
      vertical_homogeneous = true,
      layout=wibox.layout.grid
   }
   setmetatable(retval, month_layout)
   
   retval.year  = args.year  or os.date("*t",t).year
   retval.month = args.month or os.date("*t",t).month
   retval.day   = args.day   or os.date("*t",t).day

   retval.display_year  = retval.year
   retval.display_month = retval.month
   retval.display_day   = retval.day
   
   
   return retval
end
-- }}}

return setmetatable(month_layout, {__call=function(_,...) return new(...) end})
-- }}}
