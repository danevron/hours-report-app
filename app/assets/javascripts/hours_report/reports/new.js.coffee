HoursReport.Reports ?= {}

HoursReport.Reports.New =
  init: ->
    $(".datepicker").pickadate
      format: 'mmmm dd, yyyy'
      editable: true
      selectYears: true
      selectMonths: true

    $(".month-datepicker").pickadate
      format: 'mmmm, yyyy'
      editable: true
      selectYears: true
      selectMonths: true

    modules: -> []
