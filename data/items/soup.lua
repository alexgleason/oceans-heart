local item = ...
local game = item:get_game()

function item:on_created()
  self:set_can_disappear(true)
  self:set_brandish_when_picked(true)
end

function item:on_started()
  item:set_savegame_variable("possession_soup")       --variable
  item:set_amount_savegame_variable("amount_soup")    --amount variable
  item:set_max_amount(999)
  item:set_assignable(true)
end

--obtained
function item:on_obtaining(variant, savegame_variable)
  self:add_amount(1)
end

--used
function item:on_using()
  if self:get_amount() > 0 then
    game:add_life(10)              --health amount!
    self:remove_amount(1)
  end
  item:set_finished()
end