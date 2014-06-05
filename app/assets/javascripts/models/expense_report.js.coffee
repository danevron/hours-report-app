App.factory "ExpenseReport", ['RailsResource', 'railsSerializer', 'Expense',
  (RailsResource, railsSerializer, Expense) ->
    class ExpenseReport extends RailsResource
      @configure
        url: "/api/v1/expense_reports",
        name: "expense_report",
        serializer: railsSerializer( ->
          @resource('expenses', 'Expense')
        )

      @defaults =
        description: ""
        amount: 0
        quantity: 1
        currency: ""
        exchangeRate: 1

      defaultPerDiumAmount: ->
        86

      availableCountries: ->
        [ "USA", "Great Britain", "Japan", "European Union", "Australia", "Canada",
          "Denmark", "Norway", "South Africa", "Sweden", "Switzerland" ]

      total: ->
        sum = 0
        if @expenses
          sum += expense.total() for expense in @expenses
        sum

      addExpense: (expense = "") ->
        expense = new Expense(ExpenseReport.defaults) unless expense
        unless @expenses
          @expenses = []
        @expenses.push(expense)

      removeExpense: (expenseToRemove) ->
        @expenses = (item for item in @expenses when item != expenseToRemove)
        @perDium = "" if expenseToRemove == @perDium

      updatePerDiumExpense: ->
        if @perDium
          @perDium.quantity = @numberOfDays()
        else
          @addPerDiumExpense()

      addPerDiumExpense: ->
        @perDium = new Expense({
          description: "Per Dium",
          amount: @defaultPerDiumAmount(),
          quantity: @numberOfDays(),
          currency: "usd"
        })
        @addExpense(@perDium)

      numberOfDays: ->
        if @startTime and @endTime
          moment.duration(@endTime - @startTime).days()
        else
          0
]
