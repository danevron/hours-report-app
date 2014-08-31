$ ->
  class ExpenseReports
    constructor: ->
      $(".datepicker").pickadate
        format: 'mmmm dd, yyyy'
        editable: true
        selectYears: true
        selectMonths: true

      $("html").on "click", "tr", (event) ->
        debugger
        href = $(@).find("a").attr("href")
        window.location = href if href

  new ExpenseReports()
