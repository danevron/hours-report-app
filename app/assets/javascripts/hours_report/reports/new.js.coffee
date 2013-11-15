HoursReport.Reports ?= {}

HoursReport.Reports.New =
  init: ->
    $('.datepicker').datepicker()
  modules: -> []
