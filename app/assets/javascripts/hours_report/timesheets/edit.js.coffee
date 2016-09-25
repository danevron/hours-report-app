HoursReport.Timesheets ?= {}

HoursReport.Timesheets.Edit =
  init: ->
    $(".day-type").change ->
      classes = "workday weekend holiday sickness vacation army leave_of_absence"
      valueInput = $(@).parent().next().children(".day-value")
      commentInput = $(@).parent().next().next().children("input")

      $(@).removeClass(classes).addClass(@.value)
      valueInput.removeClass(classes).addClass(@.value)
      commentInput.removeClass(classes).addClass(@.value)

      if @.value == "workday"
        valueInput.val(9)
        valueInput.prop('disabled', false)
      if @.value == "sickness" or @.value == "vacation" or @.value == "army" or @.value == "leave_of_absence"
        valueInput.val(1)
        valueInput.prop('disabled', false)
      if @.value == "weekend" or @.value == "holiday"
        valueInput.val(0)
        valueInput.prop('disabled', true)

    $("#prefill-working-days").click ->
      for day in $(".edit_timesheet fieldset")
        dayType = $(day).find(".day-type").val()
        $(day).find(".day-value").val(9) if dayType == "workday"
      $(".edit_timesheet").submit()

    $("#extract-calendar-events").click ->
      window.extractCalendarEventsClicked = true
      $("#timesheet_calendar_events").attr("checked", true)

    $("form.edit_timesheet").submit (event) ->
      totalHours = 0
      for day in $(".edit_timesheet fieldset")
        dayType = $(day).find(".day-type").val()
        totalHours += parseFloat($(day).find(".day-value").val()) if dayType == "workday"

      needToConfirm = true
      if window.extractCalendarEventsClicked
        needToConfirm = false
        delete window.extractCalendarEventsClicked

      if totalHours == 0 and needToConfirm and !confirm("There are no hours in the timesheet, are you sure you want to continue?")
        event.preventDefault()



    modules: -> []
