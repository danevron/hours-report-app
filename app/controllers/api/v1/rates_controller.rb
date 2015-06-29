class Api::V1::RatesController < Api::V1::ApiController

  def index
    render :json => get_rates(Date.parse(params[:start_date]), Date.parse(params[:end_date]))
  end

  private

  def get_rates(start_date, end_date)

    start_date.upto(end_date) do |date|
      if rates_for_date_exist?(date)
        rates.map do |cur, max_rate|
          latest_rate = set_precision(bank.exchange(10000, cur, "ILS", date).to_f / 100)
          rates[cur] = latest_rate if latest_rate > rates[cur]
        end
      end
    end

    rates
  end

  def rates_for_date_exist?(date)
    bank.rates["EUR_TO_USD_#{date.strftime("%Y-%m-%d")}"]
  end

  def bank
    @bank ||= create_bank
  end

  def create_bank
    bank = EuCentralBank.new
    if !bank.rates_updated_at || bank.rates_updated_at < Time.now - 1.days
      bank.update_historical_rates
      bank.update_rates
    end
    bank
  end

  def rates
    @rates ||= {
      "ILS" => 1,
      "USD" => 0,
      "GBP" => 0,
      "JPY" => 0,
      "EUR" => 0,
      "AUD" => 0,
      "CAD" => 0,
      "DKK" => 0,
      "NOK" => 0,
      "ZAR" => 0,
      "SEK" => 0,
      "CHF" => 0,
      "HUF" => 0
    }
  end

  def set_precision(my_float)
    (my_float * 1000).round.to_f / 1000
  end
end
