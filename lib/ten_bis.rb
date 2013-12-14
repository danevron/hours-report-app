require 'capybara/poltergeist'

class TenBisCrawler

  include Capybara::DSL

  BASE_URL = "http://www.10bis.co.il/"

  attr_reader :user_name, :password, :month, :year

  def self.create_crawler(month, year)
    new(ENV['TENBIS_USER'], ENV['TENBIS_PASSWORD'], month, year)
  end

  def initialize(user_name, password, month, year)
    @user_name, @password, @month, @year = [user_name, password, month, year]
    Capybara.run_server = false
    Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {
          :js_errors => false,
          :timeout => 120
        })
    end
    Capybara.current_driver = :poltergeist
    Capybara.app_host = BASE_URL
  end

  def crawl
    login
    get_report_and_logout
  end

  private

  def get_report_and_logout
    visit BASE_URL + "/G10/ui/compAdmin/comp_admin_reports_viewer.aspx?action=true&form_type=report&comp_id=2278&ordersReportByDay=true&report_type=orders_per_day_by_user&orders_per_this_day_selection=by_res&chosenYear=#{year}&chosenMonth=#{month}&start_year=#{year}&start_mon=#{month}&start_day=1&end_year=#{year}&end_mon=#{month}&end_day=1"
    sleep 8
    html = begin
             page.evaluate_script('document.getElementById("OrderOfUsersByDayTable").innerText')
           rescue Exception => e
             page.evaluate_script('document.getElementById("OrderOfUsersByDayTable").innerText')
           end
    report = html.each_line.map{|s| row = s.split(/\t/); {row.first => row.last.to_f} }.inject{|memo, el| memo.merge( el ){|k, old_v, new_v| old_v + new_v}}
    logout
    report.shift
    downcased_keys_hash(report)
  end

  def login
    visit BASE_URL
    find('[data-home-page-logon-button]').click
    find('.HomePageHeaderTd [data-logon-email]').set(user_name)
    find('.HomePageHeaderTd [data-logon-popup-form-password-input]').set(password)
    find('.HomePageHeaderTd .submitButton').click
    sleep 8
  end

  def logout
    visit BASE_URL + "/Account/LogOff"
  end

  def downcased_keys_hash(h)
    Hash[h.map{|k,v| v.class == Array ? [k,v.map{|r| f r}.to_a] : [k.downcase,v]}]
  end
end
