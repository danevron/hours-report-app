App.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode(true)

  $routeProvider
    .when("/users/:user_id/expense_reports", {templateUrl: "/assets/expense_reports.html"})
    .when("/users/:user_id/expense_reports/:id", {
      templateUrl: "/assets/expense_report.html",
      controller: "ExpenseReportController"
    })
