# Binance

This is an unofficial Crystal wrapper for the Binance exchange REST and WebSocket APIs.

* [Source Documentation](https://mwlang.github.io/binance/)
* [Examples](https://github.com/mwlang/binance/tree/master/examples)
* [Official Binance API Documentation](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md)

## TL;DR

Run this:

```crystal
require "binance"

api_key = "vmPUZE6mv9SD5VNHk4HlWFsOr6aKE2zvsw0MuIgwCIPy6utIco14y7Ju91duEh8A"
api_secret = "NhqPtmdSJYdKjVHjA7PZj4Mge3R5YNiP1e3UZjInClVN65XAbvqqM6A7H5fATj0j"

signed_client = Binance::REST.new(api_key: api_key, secret_key: api_secret)

symbol = "BNBUSDC"
current_price = signed_client.price(symbol).tickers[0].price

puts "current price for #{symbol} is %0.6f" % current_price

puts "placing limit SELL order..."

response = signed_client.new_order(
  symbol: symbol,
  side: "SELL", 
  order_type: "LIMIT", 
  time_in_force: "GTC", 
  quantity: 1.0, 
  price: (current_price * 1.1).round(4)
)

puts "Order placed successfully? #{response.success}"

if response.success
  order = response.orders[0]
  puts "Order #{order.order_id} placed.  Status: #{order.status}"
  puts "canceling the order..."
  response = signed_client.cancel_order(
    symbol: symbol,
    order_id: order.order_id
  )
  if response.success
    puts "order cancelled successfully"
  else
    puts "order was NOT canceled!"
    puts "#{response.error_code}: #{response.error_message}"
  end
else
  puts "#{response.error_code}: #{response.error_message}"
end

puts "That's all folks!"
```

Get This:

```text
>> crystal run examples/orders.cr
current price for BNBUSDC is 32.633600
placing limit SELL order...
Order placed successfully? true
Order 20556246 placed.  Status: NEW
canceling the order...
order cancelled successfully
That's all folks!
```
## Features

Current

  * Basic implementation of REST API
    * Easy to use authentication
    * Methods return `Binance::Responses::ServerResponse` objects with JSON already deserialized
    * No need to generate signatures

Coming Soon!

  * Basic implementation of WebSocket API
    * Pass procs or lambdas to event handlers
    * Single and multiple streams supported

## REST Endpoints
  
### PUBLIC (NONE)
- [x] `ping` [ping](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#test-connectivity) Test connectivity to the Rest API.
- [x] `time` [time](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#check-server-time) Test connectivity to the Rest API and get the current server time.
- [x] `exchange_info` [exchangeInfo](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#exchange-information) Current exchange trading rules and symbol information
- [x] `depth` [depth (order book)](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#order-book) Get Order book depth info.
- [x] `trades` [trades](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#recent-trades-list) Get recent trades (up to last 500).
- [x] `agg_trades` [aggTrades](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#compressedaggregate-trades-list) Get compressed, aggregate trades.
- [x] `klines` [klines](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#klinecandlestick-data) Kline/candlestick bars for a symbol. Klines are uniquely identified by their open time.
- [x] `avg_price` [avgPrice](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#current-average-price) Current average price for a symbol.
- [x] `twenty_four_hour` [ticker/24hr](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#24hr-ticker-price-change-statistics) 24 hour rolling window price change statistics.
- [x] `price` [ticker/price](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#symbol-price-ticker) Latest price for a symbol or symbols.
- [x] `book_ticker` [ticker/bookTicker](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#symbol-order-book-ticker) Best price/qty on the order book for a symbol or symbols.

### MARKET_DATA (API_KEY required)
- [x] `historical_trades` [historicalTrades](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#old-trade-lookup-market_data) Get older trades.

### SIGNED (API_KEY and signed with SECRET_KEY required)
- [x] `account` [account](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#account-information-user_data) Get current account information.
- [x] `get_order` [GET order (query)](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#query-order-user_data) Check an order's status.
- [x] `open_orders` [GET openOrders](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#current-open-orders-user_data) Get all open orders on a symbol.
- [x] `all_orders` [GET allOrders](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#all-orders-user_data) Get all account orders; active, canceled, or filled.
- [x] `new_order` [POST order (new order)](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#new-order--trade) Send in a new order.
- [x] `new_test_order` [POST order/test (test new order)](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#test-new-order-trade) Creates and validates a new order but does not send it into the matching engine.
- [x] `cancel_order` [DELETE order (cancel order)](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#cancel-order-trade) Cancel an active order.
- [x] `my_trades` [myTrades](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#account-trade-list-user_data) Get trades for a specific account and symbol.

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  binance:
    github: mwlang/binance
```

2. Run `shards install`

## Getting Started

### REST client

```crystal
require "binance"

client = Binance::REST.new

puts client.ping.pong.inspect => true

client.klines(symbol: "BNBBTC", interval: "5m", limit: 5).klines.each do |kline|
  puts "#{kline.open_time} O: #{"%0.6f" % kline.open_price} C: #{"%0.6f" % kline.close_price}"
end

# => 
# 2019-07-02 15:35:00 UTC O: 0.003031 C: 0.003035
# 2019-07-02 15:40:00 UTC O: 0.003035 C: 0.003023
# 2019-07-02 15:45:00 UTC O: 0.003023 C: 0.003031
# 2019-07-02 15:50:00 UTC O: 0.003033 C: 0.003032
# 2019-07-02 15:55:00 UTC O: 0.003032 C: 0.003010

api_key = "vmPUZE6mv9SD5VNHk4HlWFsOr6aKE2zvsw0MuIgwCIPy6utIco14y7Ju91duEh8A"
api_secret = "NhqPtmdSJYdKjVHjA7PZj4Mge3R5YNiP1e3UZjInClVN65XAbvqqM6A7H5fATj0j"

signed_client = Binance::REST.new api_key: api_key, secret_key: api_secret
signed_client.historical_trades("BTCUSDC", 5).trades.each do |trade|
  puts "#{trade.time} #{"%0.6f" % trade.price} #{"%0.6f" % trade.quantity}"
end

# => 
# 2019-07-02 16:08:07 UTC 10465.560000 0.001689
# 2019-07-02 16:08:09 UTC 10465.650000 1.000000
# 2019-07-02 16:08:09 UTC 10465.650000 0.034570
# 2019-07-02 16:08:09 UTC 10465.650000 0.017813
# 2019-07-02 16:08:09 UTC 10471.390000 0.049130
```

Initializing the REST client:

If you only plan on touching public API endpoints, you can forgo any arguments.  
Any of the public (NONE) api endpoints will work without an API key.

```crystal
client = Binance::REST.new
```

Otherwise provide an api_key and secret_key as keyword arguments

```crystal
client = Binance::REST.new api_key: "x", secret_key: "y"
```

#### Anatomy of a `Binance::Responses::ServerResponse`

Every API endpoint call results in a ServerResponse that deserializes the JSON data retrieved from the server.

A ServerResponse is either a successful call and loaded with data or in an error state.  Exceptions
from connection fails or the server returning error codes are captured.  It is up to you to check
for errors before attempting to access the properties of the ServerResponses

When accessing the properties of the JSON responses, Generally speaking: 
  * camel-cased JSON keys become downcased and underscored.
  * abbreviations are spelled out (e.g. qty => quantity).
  * If an API can return one or more, it's always an Array property on the `ServerResponse` object.

```crystal
require "binance"

client = Binance::REST.new

puts client.ping.inspect

# => #<Binance::Responses::PingResponse:0x10d40c280 
#   @success=true, 
#   @error_code=nil, 
#   @error_message=nil, 
#   @response=#<Cossack::Response:0x10d3fe5a0 @status=200, 
#     @headers=HTTP::Headers{
#       "Content-Type" => "application/json;charset=utf-8", 
#       "Transfer-Encoding" => "chunked", 
#       "Connection" => "keep-alive", 
#       "Date" => "Tue, 02 Jul 2019 15:26:47 GMT", 
#       "Server" => "nginx", 
#       "Vary" => "Accept-Encoding", 
#       "X-MBX-USED-WEIGHT" => "3", 
#       "Strict-Transport-Security" => 
#       "max-age=31536000; includeSubdomains", 
#       "X-Frame-Options" => "SAMEORIGIN", 
#       "X-Xss-Protection" => "1; mode=block",
#       "X-Content-Type-Options" => "nosniff", 
#       "Content-Security-Policy" => "default-src 'self'", 
#       "X-Content-Security-Policy" => "default-src 'self'", 
#       "X-WebKit-CSP" => "default-src 'self'", 
#       "Cache-Control" => "no-cache, no-store, must-revalidate", 
#       "Pragma" => "no-cache", 
#       "Expires" => "0", 
#       "Content-Encoding" => "gzip", 
#       "X-Cache" => "Miss from cloudfront", 
#       "Via" => "1.1 f5d17f65245ed818b0a01bb46646051c.cloudfront.net (CloudFront)", 
#       "X-Amz-Cf-Pop" => "ATL50-C1", 
#       "X-Amz-Cf-Id" => "-lcrDlHfRIAYp7ULZLmEqNzDMCU8U4q5LnS60csCxtYe-SRY3qqqTQ=="
#       }, 
#     @body="{}">, 
#   @exception=nil>
```
The raw JSON returned is accessible via the #body property of the `ServerResponse`

```crystal
require "binance"

client = Binance::REST.new

puts client.time.body
# => {"serverTime":1562224025253}

puts client.time.server_time.inspect
# => 2019-07-04 07:07:06.009000000 UTC
```

The weight used on the API call is returned in the response headers as "X-MBX-USED-WEIGHT".
This is conveniently accessible via `#used_weight` property of the `ServerResponse`

```crystal
require "binance"

client = Binance::REST.new

response = client.twenty_four_hour
puts "WEIGHT %i" % response.used_weight
puts "TICKERS %i" % response.tickers.size

response.tickers[0,5].each do |ticker|
  puts [
      ticker.symbol,
      "bid: %0.6f" % ticker.bid_price,
      "ask: %0.6f" % ticker.ask_price,
      "change: %0.3f" % ticker.price_change_percent,
      "high: %0.6f" % ticker.high_price,
      "low: %0.6f" % ticker.low_price
    ].join(" ")
end
```

```text
WEIGHT 40
TICKERS 558
ETHBTC bid: 0.025352 ask: 0.025362 change: -2.282 high: 0.026600 low: 0.025004
LTCBTC bid: 0.010711 ask: 0.010717 change: 1.046 high: 0.010872 low: 0.009991
BNBBTC bid: 0.002767 ask: 0.002768 change: -3.726 high: 0.002969 low: 0.002705
NEOBTC bid: 0.001521 ask: 0.001522 change: -2.311 high: 0.001589 low: 0.001484
QTUMETH bid: 0.017040 ask: 0.017126 change: -0.719 high: 0.017617 low: 0.016782
```

NOTE: used_weight is cumulative
Each endpoint has it's own Response object derived from the ServerResponse object and, consequentially, the specific properties that are mapped to the JSON.  For example,
the [time](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#check-server-time) endpoint returns a `TimeResponse` with one additional property value, the "serverTime", accessible as follows:

```crystal
require "binance"

client = Binance::REST.new

puts client.time.server_time.inspect

# => 2019-07-03 18:41:45.491000000 UTC
```

## Testing

Testing is done primarily with webmock and stubbing server responses.  To make testing
easier, a mini-[VCR style record and playback](https://github.com/vcr/vcr) set of helpers
was implemented.  

However, only PUBLIC API VCR cassettes are committed to the repo.  To test SIGNED/VERIFIED
API calls, you'll have to setup your private API credentials.

## Development

All API's are TDD and have specs.  If you find a bug or want to contribute, then your 
contributions is expected to have specs exercising your code changes.

API calls are captured with so-called VCR cassettes, which is a [small library](https://github.com/mwlang/binance/blob/master/spec/support/vcr.cr) built upon Webmock for capturing and playing back a server interaction with one caveat:  signed APIs (those requiring API key) are not checked
into the repository.  As a consequence, you'll have to set up your API key and record your own
cassettes locally to get specs passing.  Signed exchanges are necessarily kept somewhat generic, but read the specs for prerequisites to actions you much take on Binance manually to prepare
to capture your signed cassettes. 

NOTE: Signed exchanges are saved to ./spec/fixtures/vcr_cassettes/signed and this folder is excluded in the .gitignore file.

To set up your API key for test environment, rename ./spec/test.yml.example to ./spec/test.yml
and replace values in the file with your own API key.  This file is likewise excluded via .gitignore.

From time to time, Binance silently releases changes to their API, adding new and undocumented fields.  For example, the ```account``` api presently returns a accountType with value "MARGIN",
but this field is not yet documented nor are the ENUM values known at this time.  When noticed,
these fields may be added and parsed without issue.

## Contributing

Pull Requests welcomed.  Fully spec'd PR's are likely to get merged!

1. Fork it (<https://github.com/mwlang/binance/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## TODO

TODO: extend the VCR functionality to obsfucate SIGNED calls to avoid revealing api keys.
TODO: build Websocket wrappers

## Contributors

- [mwlang](https://github.com/mwlang) - creator and maintainer
