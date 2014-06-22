@ExpenseReportFormController = ($scope, $routeParams, ExpenseReport, Expense, $location, flashService) ->

  if $routeParams.id
    ExpenseReport.get($routeParams.id).then (report) ->
      $scope.expenseReport = report
  else
    $scope.expenseReport = new ExpenseReport
      userId: $routeParams.user_id
      status: "open"
    $scope.expenseReport.addPerDiemExpense()

  $scope.addExpense = ->
    $scope.expenseReport.addExpense()

  $scope.updateRates = ->
    $scope.expenseReport.updatePerDiemExpense()
    $scope.showSpinner()
    $scope.expenseReport.updateRates($scope.hideSpinner)

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

  $scope.submitReport = ->
    $scope.expenseReport.save().then ((expenseReport) ->
      $scope.expenseReport = ""
      flashService.flash("success", "Expense report saved")
      $location.path("/users/#{expenseReport.userId}/expense_reports")
    ), (error) ->
      flashService.flash("danger", "Expense report was not saved due to errors")

