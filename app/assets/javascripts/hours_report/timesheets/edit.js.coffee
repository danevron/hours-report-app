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

      if @.value == "workday"
        valueInput.val(9)
      if @.value == "sickness" or @.value == "vacation" or @.value == "army"
        valueInput.val(1)
      if @.value == "weekend" or @.value == "holiday"
        valueInput.val(0)

    $("#prefill-working-days").click ->
      for day in $(".edit_timesheet fieldset")
        dayType = $(day).find(".day-type").val()
        $(day).find(".day-value").val(9) if dayType == "workday"

    modules: -> []
