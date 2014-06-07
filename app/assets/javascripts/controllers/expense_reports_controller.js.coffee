@ExpenseReportsController = ($scope, $routeParams, ExpenseReport, ccCurrencySymbol, rateService) ->
  $scope.currencySymbol = ccCurrencySymbol
  ExpenseReport.query(user_id: $routeParams.user_id).then (results) ->
    $scope.reports = results
