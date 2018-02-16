$(document).ready ->
  $('.subtree-toggle').click (event) ->
    pid = $(event.target).data('postPid')
    $("#subtree-toggle-#{pid}").toggle 100
    return
  return