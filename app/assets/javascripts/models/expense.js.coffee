App.factory "Expense", ['RailsResource',
  (RailsResource) ->
    class Expense extends RailsResource
      @configure
        url: "/api/v1/expenses",
        name: "expense"

      availableCurrencies: ->
        [
          { id: "usd", name: "USD United States Dollars" },
          { id: "gbp", name: "GBP United Kingdom Pounds" },
          { id: "jpy", name: "JPY Japan Yen" },
          { id: "eur", name: "EUR Euro" },
          { id: "aud", name: "AUD Australia Dollars" },
          { id: "cad", name: "CAD Canada Dollars" },
          { id: "dkk", name: "DKK Denmark Kroner" },
          { id: "nok", name: "NOK Norway Kroner" },
          { id: "zar", name: "ZAR South Africa Rand" },
          { id: "sek", name: "SEK Sweden Krona" },
          { id: "chf", name: "CHF Switzerland Francs" }
        ]

      total: ->
        @amount * @quantity

]
