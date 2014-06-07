App.service 'rateService', ['$http', ($http) ->

  @maximumRateBetween = (currency, startTime, endTime) ->

    start = moment(startTime).format("YYYYMMDD")
    ending = moment(endTime).format("YYYYMMDD")

    parameters = "?start_date=" + start + "&end_date=" + ending + "&currency=" + currency
    $http
      method: "GET"
      url: "/api/v1/rates" + parameters

  @
]
