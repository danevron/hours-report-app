HoursReport.Reports ?= {}

HoursReport.Reports.New =
  init: ->
    $(".datepicker").datepicker
      format: "dd/mm/yyyy"
      todayHighlight: true
      todayBtn: "linked"
      autoclose: true

    modules: -> []
