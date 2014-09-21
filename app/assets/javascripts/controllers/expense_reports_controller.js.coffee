@ExpenseReportsController = ($scope, $routeParams, ExpenseReport, ccCurrencySymbol, rateService, $location) ->
  $scope.currencySymbol = ccCurrencySymbol
  ExpenseReport.query(user_id: $routeParams.user_id).then (reports) ->
    $scope.expenseReports = reports

  $scope.redirectTo = (expenseReport) ->
    $location.path("/users/#{expenseReport.userId}/expense_reports/#{expenseReport.id}/edit")

  $scope.removeExpenseReport = ($event, expenseReport) ->
    $event.stopPropagation()
    $scope.expenseReports = (report for report in $scope.expenseReports when report != expenseReport)
    expenseReport.delete()

@ExpenseReportsController.$inject = ['$scope', '$routeParams', 'ExpenseReport', 'ccCurrencySymbol', 'rateService', '$location']
