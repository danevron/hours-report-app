class Api::V1::RatesController < Api::V1::ApiController

  def index
    render :json => get_rates(params[:currency].downcase.to_sym, Date.parse(params[:start_date]), Date.parse(params[:end_date]))
  end

  private

  def get_rates(currency, start_date, end_date)
    rates = []
    start_date.upto(end_date) do |date|
      begin
        returned_rates_data = BankOfIsrael.rates(date)
        rates << (returned_rates_data[currency][:rate].to_d / returned_rates_data[currency][:unit].to_d)
      rescue RuntimeError
      end
    end

    { rate: rates.max }
  end
end
