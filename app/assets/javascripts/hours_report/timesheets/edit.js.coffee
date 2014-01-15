HoursReport.Timesheets ?= {}

HoursReport.Timesheets.Edit =
  init: ->
    $(".day-type").change ->
      classes = "workday weekend holiday sickness vacation army"
      valueInput = $(@).parent().next().children(".day-value")
      commentInput = $(@).parent().next().next().children("input")

      $(@).removeClass(classes).addClass(@.value)
      valueInput.removeClass(classes).addClass(@.value)
      commentInput.removeClass(classes).addClass(@.value)

      valueInput.val(0) unless @.value == "workday"

    $("#prefill-working-days").click ->
      for day in $(".edit_timesheet fieldset")
        dayType = $(day).find(".day-type").val()
        $(day).find(".day-value").val(9) if dayType == "workday"

    modules: -> []
