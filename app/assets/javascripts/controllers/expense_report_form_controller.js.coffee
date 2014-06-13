@ExpenseReportFormController = ($scope, $routeParams, ExpenseReport, Expense, $location, flashService) ->

  $scope.newExpenseReport = new ExpenseReport
    userId: $routeParams.user_id
    status: "open"

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
    $scope.newExpenseReport.updatePerDiemExpense()
    for exp in $scope.newExpenseReport.expenses
      $scope.updateRate(exp) if $scope.newExpenseReport.endTime and $scope.newExpenseReport.startTime
  )

  $scope.submitReport = ->
    $scope.newExpenseReport.create().then ((expenseReport) ->
      $scope.newExpenseReport = ""
      flashService.flash("success", "Expense report created")
      $location.path("/users/#{expenseReport.userId}/expense_reports")
    ), (error) ->
      flashService.flash("danger", "Expense report was not saved due to errors")

