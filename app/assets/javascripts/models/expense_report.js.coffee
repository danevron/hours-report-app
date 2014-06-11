App.factory "ExpenseReport", ['RailsResource', 'railsSerializer', 'Expense', 'rateService',
  (RailsResource, railsSerializer, Expense, rateService) ->
    class ExpenseReport extends RailsResource
      @configure
        url: "/api/v1/expense_reports",
        name: "expense_report",
        serializer: railsSerializer( ->
          @nestedAttribute('expenses')
          @resource('expenses', 'Expense')
        )

      @defaults =
        description: ""
        amount: 0
        quantity: 1
        currency: ""
        exchangeRate: 0

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

      updateRate: (expense, callback = "") ->
        if @startTime and @endTime
          promise = rateService.maximumRateBetween(expense.currency, @startTime, @endTime)
          promise.then (response) ->
            expense.exchangeRate = response.data.rate
            callback() if callback
        else
          expense.exchangeRate = 0
          callback() if callback

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
          description: "Per Diem",
          amount: @defaultPerDiumAmount(),
          quantity: @numberOfDays(),
          currency: "USD"
        })
        @addExpense(@perDium)

      numberOfDays: ->
        if @startTime and @endTime
          moment.duration(@endTime - @startTime).days() + 1
        else
          0
]
