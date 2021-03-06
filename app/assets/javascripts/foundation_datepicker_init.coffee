# http://foundation.zurb.com/forum/posts/37141-foundation-6-date-picker

$ ->
  $('#company_founded').fdatepicker
    format: 'mm/dd/yyyy'
  return
$ ->
  $('#okr_okr_start').fdatepicker
    format: 'mm/dd/yyyy'
  return
$ ->
  start = new Date
  start.setHours 0, 0, 0, 0
  $('#event_start_time').fdatepicker
    startDate: start,
    format: 'mm/dd/yyyy hh:ii',
    minuteStep: 15,
    todayBtn: true,
    pickTime: true
  return
