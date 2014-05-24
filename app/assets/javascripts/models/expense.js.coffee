App.factory "Expense", ['RailsResource',
  (RailsResource) ->
    class Expense extends RailsResource
      @configure
        url: "/api/v1/expenses",
        name: "expense"

      total: ->
        @amount * @quantity

]
