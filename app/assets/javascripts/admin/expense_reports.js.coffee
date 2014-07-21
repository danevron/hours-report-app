$ ->
  class ExpenseReports
    constructor: ->
      $('.expense_reports_filter').bind 'change', (event) =>
        @filterExpenseReports()

    filterExpenseReports: (data)->
      params = $('#expense_report_filters').serialize()
      window.location = "/expense_reports?#{params}"

  new ExpenseReports()