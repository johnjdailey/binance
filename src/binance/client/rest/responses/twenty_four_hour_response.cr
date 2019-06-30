module Binance::Responses
  # Example Server Response:
  #     [
  #       {
  #         "symbol": "BNBBTC",
  #         "priceChange": "-94.99999800",
  #         "priceChangePercent": "-95.960",
  #         "weightedAvgPrice": "0.29628482",
  #         "prevClosePrice": "0.10002000",
  #         "lastPrice": "4.00000200",
  #         "lastQty": "200.00000000",
  #         "bidPrice": "4.00000000",
  #         "askPrice": "4.00000200",
  #         "openPrice": "99.00000000",
  #         "highPrice": "100.00000000",
  #         "lowPrice": "0.10000000",
  #         "volume": "8913.30000000",
  #         "quoteVolume": "15.30000000",
  #         "openTime": 1499783499040,
  #         "closeTime": 1499869899040,
  #         "firstId": 28385,
  #         "lastId": 28460, 
  #         "count": 76
  #       }
  #     ]
  #
  #   OR 
  #
  #     {
  #       "symbol": "BNBBTC",
  #       "priceChange": "-94.99999800",
  #       "priceChangePercent": "-95.960",
  #       "weightedAvgPrice": "0.29628482",
  #       "prevClosePrice": "0.10002000",
  #       "lastPrice": "4.00000200",
  #       "lastQty": "200.00000000",
  #       "bidPrice": "4.00000000",
  #       "askPrice": "4.00000200",
  #       "openPrice": "99.00000000",
  #       "highPrice": "100.00000000",
  #       "lowPrice": "0.10000000",
  #       "volume": "8913.30000000",
  #       "quoteVolume": "15.30000000",
  #       "openTime": 1499783499040,
  #       "closeTime": 1499869899040,
  #       "firstId": 28385,
  #       "lastId": 28460, 
  #       "count": 76
  #     }
  class TwentyFourHourResponse < Responses::ServerResponse
    property tickers : Array(TwentyFourHourEntry) = [] of TwentyFourHourEntry

    def self.from_json(json)
      pull = JSON::PullParser.new(json)
      TwentyFourHourResponse.new.tap do |resp|
        if pull.kind == :begin_array
          resp.tickers = Array(TwentyFourHourEntry).new(pull)
        else
          resp.tickers << TwentyFourHourEntry.new(pull)
        end
      end
    end

  end
end