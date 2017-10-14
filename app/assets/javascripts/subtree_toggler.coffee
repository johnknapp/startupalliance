$(document).ready ->
  $('.subtree-toggle').click (event) ->
    pid = $(event.target).data('commentPid')
    $("#subtree-toggle-#{pid}").toggle 100
    return
  return