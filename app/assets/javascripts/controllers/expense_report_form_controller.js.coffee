@ExpenseReportFormController = ($scope, $routeParams, ExpenseReport, Expense) ->

  $scope.newExpenseReport = new ExpenseReport()

  $scope.addExpense = ->
    $scope.newExpenseReport.addExpense()

  $scope.$watch("newExpenseReport.endTime - newExpenseReport.startTime", ->
    $scope.newExpenseReport.updatePerDiumExpense()
  )
