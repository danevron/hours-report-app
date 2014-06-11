App.factory "Expense", ['RailsResource',
  (RailsResource) ->
    class Expense extends RailsResource
      @configure
        url: "/api/v1/expenses",
        name: "expense"

      availableCurrencies: ->
        [
          { id: "ILS", name: "Israeli Sheqel" },
          { id: "USD", name: "United States Dollars" },
          { id: "GBP", name: "United Kingdom Pounds" },
          { id: "JPY", name: "Japan Yen" },
          { id: "EUR", name: "Euro" },
          { id: "AUD", name: "Australia Dollars" },
          { id: "CAD", name: "Canada Dollars" },
          { id: "DKK", name: "Denmark Kroner" },
          { id: "NOK", name: "Norway Kroner" },
          { id: "ZAR", name: "South Africa Rand" },
          { id: "SEK", name: "Sweden Krona" },
          { id: "CHF", name: "Switzerland Francs" }
        ]

      total: ->
        @localTotal() * (@exchangeRate)

      localTotal: ->
        @amount * @quantity
]
