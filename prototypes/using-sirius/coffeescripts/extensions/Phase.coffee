window.sirius.Phase::defaults =
  yellow_time: 0
  red_clear_time: 0
  min_green_time: 0

window.sirius.Phase::initialize = ->
  @set('links', new window.sirius.Links)