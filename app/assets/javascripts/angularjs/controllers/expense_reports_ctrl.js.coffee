App.controller 'ExpenseReportsCtrl', ['$scope', 'ExpenseReport', '$location', ($scope, ExpenseReport, $location) ->
  $scope.message = 'Angular'

  $scope.expense_report = ExpenseReport.new
]
