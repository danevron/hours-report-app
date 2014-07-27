$ ->
  class ExpenseReports
    constructor: ->
      $(".datepicker").pickadate
        format: 'mmmm dd, yyyy'
        editable: true
        selectYears: true
        selectMonths: true

      $("tr").click ->
        href = $(@).find("a").attr("href")
        window.location = href if href

  new ExpenseReports()
