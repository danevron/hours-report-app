@ExpenseReportFormController = ($scope, $routeParams, ExpenseReport, Expense) ->

  $scope.newExpenseReport = new ExpenseReport()

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
