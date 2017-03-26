-------------------------------------------------------------------------------
-- wibox.lua for awesome-cal --
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
-- Mocks and stubs for wibox widgets
-- }}}

--- layout stubs -- {{{

local layout = { flex = { } }
--- layout:add stub -- {{{
--

function layout.flex:add(t)
   table.insert(self,t)
end

function layout.flex:children()
   local c = {}

   for i, v in ipairs(self) do
      if type(v) ~= "function" then
         table.insert(c,v)
      end
   end

   return c
end

function make_layout()
   local ret = {}

   ret["add"] = layout.flex.add
   ret["children"] = layout.flex.children

   return ret
end

function layout.flex.horizontal()
   return make_layout()   
end

function layout.flex.vertical()
   return make_layout()
end

-- }}}

-- }}}

--- textbox stubs -- {{{
local textbox = {}

--- textbox:new -- {{{
-- 
function textbox.new (t, text)
   return text
end

setmetatable(textbox, {__call=function (...) return textbox.new(...) end})
-- }}}

-- }}}

return { layout = layout,
         widget = {textbox = textbox}}

