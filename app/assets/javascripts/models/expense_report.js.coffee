App.factory "ExpenseReport", ['RailsResource', 'railsSerializer',
  (RailsResource, railsSerializer) ->
    class ExpenseReport extends RailsResource
      @configure
        url: "/api/v1/expense_reports",
        name: "expense_report",
        serializer: railsSerializer( ->
          @resource('expenses', 'Expense')
        )

      total: ->
        sum = 0
        sum += expense.total() for expense in @expenses
        sum
]
