$ ->
  class ExpenseReports
    constructor: ->
      $(".datepicker").pickadate
        format: 'mmmm dd, yyyy'
        editable: true
        selectYears: true
        selectMonths: true


  new ExpenseReports()
