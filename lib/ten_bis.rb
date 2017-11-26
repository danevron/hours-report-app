require 'capybara/poltergeist'

class TenBisCrawler

  BASE_URL = "https://www.10bis.co.il/"

  attr_reader :user_name, :password, :month, :year

  def self.create_crawler(month, year)
    new(ENV['TENBIS_USER'], ENV['TENBIS_PASSWORD'], month, year)
  end

  def initialize(user_name, password, month, year)
    @user_name, @password, @month, @year = [user_name, password, month, year]
  end

  def crawl
    login
    get_report
  end


  def login
    response = HTTParty.post("https://www.10bis.co.il/Account/LogonAjax",
      :body => {
        'timestamp' => Time.now.to_i,
        'model' => {
          'UserName' => @user_name,
          'Password' => @password,
          'SocialLoginUID' => '',
          'FacebookUserId' => nil,
          'returnUrl' => ''
        },
      }.to_json,
      :headers => { 'Content-Type' => 'application/json' } )

    @cookie = HTTParty::CookieHash.new
    response.get_fields('Set-Cookie').each { |c| @cookie.add_cookies(c) }
  end

  def get_report
    report = {}

    path = "/G10/ui/compAdmin/comp_admin_reports_viewer.aspx?action=true&form_type=report&comp_id=2278&ordersReportByDay=true&report_type=orders_per_day_by_user&orders_per_this_day_selection=by_res&chosenYear=#{year}&chosenMonth=#{month}&start_year=#{year}&start_mon=#{month}&start_day=1&end_year=#{year}&end_mon=#{month}&end_day=1"
    html = HTTParty.get("https://www.10bis.co.il/#{path}", headers: { 'Cookie' => @cookie.to_cookie_string })

    doc = Nokogiri::HTML.parse(html)
    orders = doc.css('#OrderOfUsersByDayTable')
    orders.css('tr').each do |row|
      cells = row.css('td')
      if (cells.count > 1)
        tenbis_number = cells[1].inner_text.gsub(/[ \r\n]/,'')
        tenbis_usage = cells.last.inner_text.gsub(/[ \r\n]/,'')
        report[tenbis_number] = tenbis_usage
      end
    end

    report
  end
end
