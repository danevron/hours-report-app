@ExpenseReportFormController = ($scope, $routeParams, ExpenseReport, Expense, $location) ->

  $scope.newExpenseReport = new ExpenseReport
    userId: $routeParams.userId

  $scope.addExpense = ->
    $scope.newExpenseReport.addExpense()

  $scope.updateRate = (expense) ->
    $scope.showSpinner()
    $scope.newExpenseReport.updateRate(expense, $scope.hideSpinner)

  $scope.showSpinner = ->
    $("body").spin()
    $("body").block
      fadeIn: 250
      message: ''
      overlayCSS:
        opacity: 0.35

  $scope.hideSpinner = ->
    $("body").unblock
      fadeOut: 250
      onUnblock: ->
        $("body").spin(false)

  $scope.$watch("newExpenseReport.endTime - newExpenseReport.startTime", ->
    $scope.newExpenseReport.updatePerDiumExpense()
    for exp in $scope.newExpenseReport.expenses
      $scope.updateRate(exp) if $scope.newExpenseReport.endTime and $scope.newExpenseReport.startTime
  )

  $scope.submitReport = ->
    $scope.newExpenseReport.create().then (expenseReport) ->
      debugger
      $location.path("/users/#{expenseReport.userId}/expense_reports/#{expenseReport.id}")

