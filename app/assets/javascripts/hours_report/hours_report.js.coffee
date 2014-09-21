#= require_self
#= require_tree .

@App = angular.module("ExpenseReportApp", ["rails", "ngRoute", "ngAnimate", "mgcrea.ngStrap", "cc", "ui.bootstrap.showErrors"])

@App.config ["$httpProvider", 'RailsResourceProvider', (provider, railsResourceProvider) ->
  railsResourceProvider.updateMethod('patch')
  provider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'
  provider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
]

window.HoursReport =
  configs:
    turbolinks: true # True to use initjs with Turbolinks by default.
    pjax: false # True to use initjs with pjax by default.
    respond_with: # To not use respond_with, just set false.
      'Create': 'New' # Respond the Create action with the New.
      'Update': 'Edit' # Respond the Update action with the Edit.

  initPage: ->
    # If you're using the Turbolinks or pjax and you need run a code once, put something here.
    # if you're not using the turbolinks or pjax, there's no difference between init and initPage.

  init: ->
    # Something here. This is called in every page.
    $(".fa-question").popover()

    currentTimesheetEndingTime = $(".current-timesheet-ending-time")
    if currentTimesheetEndingTime.length > 0
      $('.time-left-to-submit-timesheet').countdown
        until: new Date(currentTimesheetEndingTime.text())
        layout: "You have {dn} {dl}, {hn} {hl}, {mn} {ml}, and {sn} {sl} to submit your timesheet"

  modules: -> []
    # Some modules that will be used on every page.
