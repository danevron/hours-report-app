class Expense < ActiveRecord::Base
  belongs_to :expence_report

  private

  def self.new_default
    new(
         :description => "Per Dium",
         :amount => ENV['PER_DIUM_AMOUNT'],
         :quantity => 1,
         :currency => ENV['DEFAULT_CURRENCY']
       )
  end
end
