App.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode(true)

  $routeProvider
    .when("/users/:user_id/expense_reports", {templateUrl: "/assets/expense_reports.html"})
