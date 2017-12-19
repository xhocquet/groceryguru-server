module Coupons
  class KrogerScraper
    COUPON_URL = "https://kroger.softcoin.com/p/np/4230/Kroger/coupons?banner=King_Soopers&usource=KWL"

    def initialize
    end

    def perform
      page = Nokogiri::HTML(open(COUPON_URL))
    end
  end
end