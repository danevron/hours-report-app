class Api::V1::RatesController < Api::V1::ApiController

  def index
    render :json => get_rates(Date.parse(params[:start_date]), Date.parse(params[:end_date]))
  end

  private

  def get_rates(start_date, end_date)
    start_date.upto(end_date) do |date|
      begin
        returned_rates_data = BankOfIsrael.rates(date)
        if returned_rates_data.delete(:release_date)
          returned_rates_data.each do |currency, data|
            calculated_rate = (data[:rate].to_d / data[:unit].to_d)
            rates[currency.to_s.upcase] = calculated_rate unless rates[currency.to_s.upcase] > calculated_rate
          end
        end
      rescue RuntimeError
      end
    end

    rates
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
      "JOD" => 0,
      "EGP" => 0,
      "LBP" => 0
    }
  end
end
