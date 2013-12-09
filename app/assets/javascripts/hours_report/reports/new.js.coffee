HoursReport.Reports ?= {}

HoursReport.Reports.New =
  init: ->
    $(".datepicker").datepicker
      format: "dd/mm/yyyy"
      todayHighlight: true
      todayBtn: "linked"
      autoclose: true

    $(".month-datepicker").datepicker
      format: "mm/yyyy"
      autoclose: true
      viewMode: 1
      minViewMode: 1

    modules: -> []
