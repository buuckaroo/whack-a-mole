--win.lua
local ui = require('ui')
local sys = require('sys')

--objects
local hole = Object {}
function hole:constructor(parent, x, y)
  self.actived = false
  self.empty = 'textures\\hole.png'
  self.active = 'textures\\mole.png'
  self.picture = ui.Picture(parent, self.empty, x, y)
  self.picture.cursor = 'hand'
end
function hole:fetch_picture()
  return self.picture
end
function hole:activiate()
  self.actived = true
  self.picture:load(self.active)
end
function hole:deactiviate()
  self.actived = false
  self.picture:load(self.empty)
end

local debounce = false
local moles_whacked = 0
local moles_missed = 0

--user interface
local win = ui.Window('Whack-a-mole', 'fixed', 250, 250)

--status labels--
local moles_whacked_dis = ui.Label(win, string.format('Moles whacked: %s', moles_whacked), 45, 10); moles_whacked_dis.fontsize = 16

local objs = {hole_obj1 = hole(win, 50, 50),  hole_obj2 = hole(win, 100, 50), hole_obj3 = hole(win, 150, 50),
              hole_obj4 = hole(win, 50, 100), hole_obj5 = hole(win, 100, 100), hole_obj6 = hole(win, 150, 100),
              hole_obj7 = hole(win, 50, 150), hole_obj8 = hole(win, 100, 150), hole_obj9 = hole(win, 150, 150)
}

function appear_mole()
  if not debounce then
    debounce = true
    local random_num = math.random(1, 9)
    for i, v in pairs(objs) do
      local index = string.gsub(i, 'hole_obj', '')
      if tonumber(index) == random_num then
        v:activiate()
      end
    end
    sleep(math.random(2000, 5000))
    debounce = false
  end
end
--click
function click_mole()
  for i, v in pairs(objs) do
    local picture = v:fetch_picture()
    picture.onClick = function(self)
      if v.actived then
        v:deactiviate()
        moles_whacked = moles_whacked + 1
        moles_whacked_dis.text = string.format('Moles whacked: %s', moles_whacked)
      end
    end
  end
end

--update loop
win:show()

repeat
  ui.update()
  appear_mole()
  click_mole()
until not win.visible