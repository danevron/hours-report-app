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

      defaultPerDiemAmount: ->
        86

      availableCountries: ->
        [ "USA", "Great Britain", "European Union", "Australia", "Canada",
          "Denmark", "Norway", "Sweden", "Switzerland" ]

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

      updateRates: (callback = "") ->
        if @startTime and @endTime
          promise = rateService.maximumRateBetween(@startTime, @endTime)
          promise.then (response) =>
            for exp in @expenses
              exp.exchangeRate = response.data[exp.currency]
            callback() if callback
        else
          exp.exchangeRate = 0 for exp in @expenses
          callback() if callback

      removeExpense: (expenseToRemove) ->
        @expenses = (item for item in @expenses when item != expenseToRemove)

      updatePerDiemExpense: ->
        @perDiemExpense().quantity = @numberOfDays() if @perDiemExpense()

      addPerDiemExpense: ->
        perDiem = new Expense({
          description: "Per Diem",
          amount: @defaultPerDiemAmount(),
          quantity: @numberOfDays(),
          currency: "USD"
        })
        @addExpense(perDiem)

      perDiemExpense: ->
        (expense for expense in @expenses when expense.description == "Per Diem")[0]

      numberOfDays: ->
        if @startTime and @endTime
          moment.duration(moment(@endTime) - moment(@startTime)).as("days") + 1
        else
          0
]
