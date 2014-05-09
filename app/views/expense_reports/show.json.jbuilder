json.expense_report do
  json.start_time @expense_report.start_time
  json.end_time @expense_report.end_time
  json.country @expense_report.country
  json.currency @expense_report.currency
  json.expenses @expense_report.expenses, :id, :description, :quantity, :amount, :currency
end
