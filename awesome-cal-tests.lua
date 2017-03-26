-------------------------------------------------------------------------------
-- awesome-cal-tests.lua for awesome-cal --
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
-- Tests for awesome calendar
-- }}}

--- awesome-cal-tests -- {{{
describe("awesome_cal tests", function ()
  package.path = 'mocks/?.lua;../' .. package.path

  --- awesome_cal:month_info tests -- {{{
  describe("awesome_cal:month_info tests", function ()
    local ac = require('awesome-cal')

    -- Test where the first day of the week is also a sunday and there
    -- are 31 days in the month
    it("should return thursday (offset 4) and 1/31/1970 for unix epoch", function ()
      local x,y,z = ac:month_info(os.date("*t",os.time({day =1, month=1, year=1970})))

      assert.are.same(4, x)
      assert.are.same(y.day,31)
      assert.are.same(y.month, 1)
      assert.are.same(y.year, 1970)
      assert.are.same(0, z)
    end)

    it("should return 3 and 3/31/2017 and 1 for t=1490456483", function ()
      local x,y,z = ac:month_info(os.date("*t", 1490456483))

      assert.are.same(3,x)
      assert.are.same(y.day, 31)
      assert.are.same(y.month, 3)
      assert.are.same(y.year, 2017)
      assert.are.same(1, z)
    end)
  end)
  -- }}}

  --- awesome_cal:day_list tests -- {{{
  describe("awesome:cal:day_list", function ()
    local ac = require('awesome-cal')

    it("should return 4 blanks and then 31 days for unix epoch", function ()
      local days = ac:day_list(4, os.date("*t", os.time({day =31, month=1, year=1970})), 0)

      -- square test (should be evenly divisible by 7
      assert.are.equal(0, table.getn(days) % 7)
      for x = 1,4 do
         assert.are.equal("  ", days[x])
      end

      for x = 1,31 do
         assert.are.equal(tostring(x), days[x+4])
      end
    end)

    it("should return 3 blanks, then 31 days, then 1 blank for 3/31/2017", function ()
      local beg_offset = 3
      local end_offset = 1
      local end_month = os.date("*t", os.time({day =31, month=3, year=2017}))
      
      local days = ac:day_list(beg_offset, end_month, end_offset)
      
      -- square test (should be evenly divisible by 7
      assert.are.equal(0, table.getn(days) % 7)
      for x = 1,beg_offset do
         assert.are.equal("  ", days[x])
      end

      for x = 1,end_month.day do
         assert.are.equal(tostring(x), days[x+3])
      end

      for x = 1, end_offset do
         assert.are.equal("  ", days[table.getn(days)])
      end
    end)
  end)
  -- }}}  

  --- awesome_cal:build_cal_widget tests -- {{{
  describe("awesome_cal:build_cal_widget tests", function()
    local ac = require("awesome-cal")

    it("should return a 6 row table with seven cols for unix epoch", function ()
      ac.date = os.date("*t", os.time({day=1, month=1, year=1970}))

      local w = ac:build_cal_widget()
      assert.are.equal(6, table.getn(w:children()))
      
      for i,v in ipairs(w) do
         assert.are.equal(7, table.getn(v:children()))
      end      
    end)
  end)
  -- }}}
  
end)

-- }}}
