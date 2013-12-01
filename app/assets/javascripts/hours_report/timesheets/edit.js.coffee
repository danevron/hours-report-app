HoursReport.Timesheets ?= {}

HoursReport.Timesheets.Edit =
  init: ->
    $(".day-type").change ->
      $(@).parent().next().children(".day-value").val(0) unless @.value == "workday"

    $("#prefill-working-days").click ->
      for day in $(".edit_timesheet fieldset")
        dayType = $(day).find(".day-type").val()
        $(day).find(".day-value").val(9) if dayType == "workday"

    modules: -> []
