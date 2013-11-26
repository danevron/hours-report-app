class Report < ActiveRecord::Base
  has_many :user_reports, dependent: :destroy
  has_many :users, :through => :user_reports

  validates :current, uniqueness: true, if: "current?"
  validates_datetime :start_date
  validates_date :end_date, :after => lambda { |report| report.start_date + 1.month - 2.days }

  validates_associated :user_reports
  validates :start_date, :end_date,
    :overlap => { :message_title => :overlapping,
                  :message_content => "There is an overalapping report for the given dates" }


  def self.build_report(report_data)
    report = new(report_data)
    report.user_reports = User.active.pluck(:id).map do |user_id|
      UserReport.build_report(user_id, report.start_date, report.end_date)
    end
    report
  end
end
