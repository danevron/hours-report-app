App.factory 'ExpenseReport', ['railsResourceFactory', (railsResourceFactory) ->

  ExpenseReportResource = railsResourceFactory
    url: '/expense_reports'
    name: 'expense_report'

]
