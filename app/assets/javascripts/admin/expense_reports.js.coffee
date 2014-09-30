$ ->
  class ExpenseReports
    constructor: ->
      $(".datepicker").pickadate
        format: 'mmmm dd, yyyy'
        editable: true
        selectYears: true
        selectMonths: true

      $("html").on "click", "tr", (event) ->
        href = $(@).find("a").attr("href")
        window.location = href if href && !event.target.href

      $(".print-button").click (event) ->
        event.stopPropagation()
        report_pdf = window.open($(event.target).attr("href"))
        report_pdf.print()

  new ExpenseReports()
