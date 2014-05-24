@ExpenseReportsController = ($scope, $routeParams, ExpenseReport) ->
  ExpenseReport.query(user_id: $routeParams.user_id).then (results) ->
    $scope.reports = results
