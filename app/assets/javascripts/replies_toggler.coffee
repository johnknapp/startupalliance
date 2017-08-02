$(document).ready ->
  $('.reply-toggle').click (event) ->
    pid = $(event.target).data('postPid')
    $("#replies-post-pid-#{pid}").toggle 100
    return
  return