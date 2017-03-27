-------------------------------------------------------------------------------
-- awesome-cal.lua for awesome-cal --
-- Copyright (c) 2017 Tom Hartman (thomas.lees.hartman@gmail.com)            --
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
-- A calendar widget for awesome
-- }}}

--- awesome-cal -- {{{

--- Requires and Locals -- {{{
--- Requires -- {{{
local os          = require("os"       )
local layout      = require("wibox"    ).layout
local textbox     = require("wibox"    ).widget.textbox
local awful       = require("awful"    )
local beautiful   = require("beautiful")
local radical     = require("radical"  )
-- }}}

--- Locals -- {{{
local setmetatable = setmetatable
local tonum = tonumber
local tostr = tostring
local awesome_cal = { day_labels = {"Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"},
                      spacer = "",
                      day_sec = 86400,
                    }
-- }}}
-- }}}

--- awesome_cal:month_info -- {{{
-- 
function awesome_cal:month_info (date)
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

--- awesome_cal:day_list -- {{{
-- 
function awesome_cal:day_list (beg_month_offset, end_month, end_month_offset)
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

--- awesome_cal:build_cal_widget -- {{{
-- 
function awesome_cal:build_cal_widget ()
   -- Calendar header
   local hlayout = layout.flex.horizontal()
   for i,v in ipairs(self.day_labels) do
      hlayout:add(textbox(v))
   end

   local vlayout = layout.flex.vertical()
   vlayout:add(hlayout)

   local date = self.date or os.date("*t",t)
   local beg_offset, end_month, end_offset = self:month_info(date)
   local days_list = self:day_list(beg_offset, end_month, end_offset)

   local hlayout = layout.flex.horizontal()
   
   for i, d in ipairs(days_list) do
      hlayout:add(textbox(d))

      if i % 7 == 0 then
         vlayout:add(hlayout)
         hlayout = layout.flex.horizontal()
      end
   end

   if table.getn(hlayout:children()) ~= 0 then
      vlayout:add(hlayout)
   end

   return vlayout
end
-- }}}

--- awesome_cal:popup -- {{{
-- 
function awesome_cal:popup ()
   local w = self:build_cal_widget()
   local m = radical:context{layout=radical.layout.grid,
                             column=table.getn(self.day_labels)}
   
end
-- }}}

--- Constructors -- {{{

--- new -- {{{
-- 
function awesome_cal.new (date, ...)

end
-- }}}

-- }}}

return awesome_cal

-- }}}
