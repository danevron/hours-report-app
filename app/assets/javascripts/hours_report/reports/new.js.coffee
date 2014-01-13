HoursReport.Reports ?= {}

HoursReport.Reports.New =
  init: ->
    $(".datepicker").pickadate
      format: 'dddd, dd mmm, yyyy'
      editable: true
      selectYears: true
      selectMonths: true

    $(".month-datepicker").pickadate
      format: 'dddd, dd mmm, yyyy'
      editable: true
      selectYears: true
      selectMonths: true

    modules: -> []
