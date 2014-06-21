App.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode(true)

  $routeProvider
    .when("/users/:user_id/expense_reports/new", {
      templateUrl: "/assets/expense_report_form.html",
      controller: "ExpenseReportFormController"
    })
    .when("/users/:user_id/expense_reports/:id/edit", {
      templateUrl: "/assets/expense_report_form.html",
      controller: "ExpenseReportFormController"
    })
    .when("/users/:user_id/expense_reports", {
      templateUrl: "/assets/expense_reports.html",
      controller: "ExpenseReportsController"
    })
    .when("/users/:user_id/expense_reports/:id", {
      templateUrl: "/assets/expense_report.html",
      controller: "ExpenseReportController"
    })
