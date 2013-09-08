$(document).ready -> 
  window.week_idx = window.weeks.length - 1
  displayCurrentWeek()

  $('.ttip').tooltip
      'html': true,

  $('.popper').popover()

  $('.checkbox').click ->
    $(this).toggleClass('checked')

    virtue = $(this).data('virtue').toLowerCase()
    value = 1
    current_week = weeks[week_idx]
    week_start_date = new Date(current_week['start_date'] + " 12:00")
    week_start_date.setDate(week_start_date.getDate() + $(this).data('weekday'))
    day = padDigits(week_start_date.getDate(), 2) + padDigits(week_start_date.getMonth() + 1, 2) + week_start_date.getFullYear()
    if $(this).html() == ''
      $(this).html('•')
    else
      $(this).html('')
      value = 0

    $.post '/update_virtue/' + day + "/", 
      {
        virtue: virtue,
        value: value
      },
      (data) ->
        console.log data

  prevWeek = ->
    if window.week_idx <= 0
      return

    console.log "HELLO", window.week_idx
    window.week_idx = window.week_idx - 1
    displayCurrentWeek()
    false

  nextWeek = ->
    if window.week_idx >= weeks.length - 1
      return

    window.week_idx = window.week_idx + 1
    displayCurrentWeek()
    false

  $('.next_btn').click nextWeek
  $('.prev_btn').click prevWeek

row_nums = {
  'temperance': 1,
  'silence': 2,
  'order': 3,
  'resolution': 4,
  'frugality': 5,
  'industry': 6,
  'sincerity': 7,
  'justice': 8,
  'moderation': 9,
  'cleanliness': 10,
  'tranquility': 11,
  'chastity': 12,
  'humility': 13
}

displayCurrentWeek = ->
  current_week = weeks[week_idx]
  $('.checkbox').removeClass('checked').html('')

  console.log current_week
  for day in current_week['days']
    for virtue, status of day
      if virtue == 'date'
        continue
      
      if status == 1
        day_idx = new Date(day['date'] + " 12:00").getDay() + 2 # Handle indexing, extra one
        console.log day_idx, row_nums[virtue]
        $("table tr:nth-child(#{row_nums[virtue]}) td:nth-child(#{day_idx})").addClass('checked').html('•')

  $('.prev_btn').show()
  $('.next_btn').show()
  if week_idx == 0
    $('.prev_btn').hide()

  if week_idx == weeks.length - 1
    $('.next_btn').hide()

        
window.padDigits = (number, digits) ->
  Array(Math.max(digits - String(number).length + 1, 0)).join(0) + number
