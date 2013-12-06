require 'capybara/poltergeist'

class TenBisCrawler

  include Capybara::DSL

  BASE_URL = "http://www.10bis.co.il/"

  attr_reader :user_name, :password

  def self.create_crawler
    new(ENV['TENBIS_USER'], ENV['TENBIS_PASSWORD'])
  end

  def initialize(user_name, password)
    @user_name, @password = [user_name, password]
    Capybara.run_server = false
    Capybara.current_driver = :poltergeist
    Capybara.app_host = BASE_URL
  end

  def crawl
    login
    get_report
  end

  private

  def get_report
    visit BASE_URL + '/G10/ui/compAdmin/comp_admin_reports_viewer.aspx?action=true&form_type=report&comp_id=2278&ordersReportByDay=true&report_type=orders_per_day_by_user&orders_per_this_day_selection=by_res&chosenYear=2013&chosenMonth=10&start_year=2013&start_mon=10&start_day=1&end_year=2013&end_mon=10&end_day=1'
    sleep 8
    html = begin
             page.evaluate_script('document.getElementById("OrderOfUsersByDayTable").innerText')
           rescue Exception => e
             page.evaluate_script('document.getElementById("OrderOfUsersByDayTable").innerText')
           end
    report = html.each_line.map{|s| row = s.split(/\t/); {row.first => row.last.to_f} }.inject{|memo, el| memo.merge( el ){|k, old_v, new_v| old_v + new_v}}
    report.shift
    report
  end

  def login
    visit BASE_URL
    find('[data-home-page-logon-button]').click
    find('.HomePageHeaderTd [data-logon-email]').set(user_name)
    find('.HomePageHeaderTd [data-logon-popup-form-password-input]').set(password)
    find('.HomePageHeaderTd .submitButton').click
    sleep 8
  end

end
