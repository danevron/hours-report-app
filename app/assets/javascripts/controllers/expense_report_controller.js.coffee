@ExpenseReportController = ($scope, $routeParams, ExpenseReport) ->
  ExpenseReport.get(user_id: $routeParams.user_id, id: $routeParams.id).then (expenseReport) ->
    $scope.expenseReport = expenseReport
