window.initializeDatePicker = ->
  # http://www.daterangepicker.com/#options
  $('[data-bootstrap-datepicker]').each ->
    if $(this).data().bootstrapDatepicker == "datetime"
      format = 'DD-MMM-YYYY h:mm A'
      timePicker = true
    else if $(this).data().bootstrapDatepicker != true
      format = $(this).data().bootstrapDatepicker
    else
      format = 'DD-MMM-YYYY'
    if $(this).data().bootstrapDatepickerTimepicker
      timePicker = true
    $(this).daterangepicker(
      autoApply: true,
      singleDatePicker: true
      timePicker: timePicker
      locale:
        format: format,
    )
    console.log "adding daterangepicker #{format}"

window.initializeDateRangePicker = ->
  # http://www.daterangepicker.com/#options
  $('[data-date-range-picker]').each ->
    window.addDateRangePicker($(this))

window.addDateRangePicker = ($input) ->
  # http://www.daterangepicker.com/#options
  if $input.data("dateRange") == "datetime"
    format = 'DD-MMM-YYYY h:mm A'
    timePicker = true
  else
    format = 'DD-MMM-YYYY'
  if $input.data("predefinedRanges")
    ranges = $input.data("predefinedRanges")
    showCustomRangeLabel = true
  $input.daterangepicker(
    autoApply: true,
    timePicker: timePicker
    locale:
      format: format
    ranges: ranges
    showCustomRangeLabel: showCustomRangeLabel
    opens: 'left'
    autoUpdateInput: false # we need to disable since it will use todays value,
    # we want initially empty (so we populate on events)
  ).on('apply.daterangepicker', (ev, picker) ->
    $input.val(picker.startDate.format(format) + ' - ' +
                       picker.endDate.format(format)).change()
  )

