class TenbisWorker
  include Sidekiq::Worker

  def perform(month, year)
    usage = TenBisCrawler.create_crawler(month, year).crawl
    Tenbis.create(:date => Date.new(year, month), :usage => usage)
  end
end
