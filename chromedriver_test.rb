require "net/http"
require "json"
require "uri"
require "benchmark"

# Start session
response = Net::HTTP.post \
  URI.parse("http://localhost:9515/session"),
  {
    capabilities: {
      firstMatch: [
        {
          "goog:chromeOptions": {
            args: ["--headless=new"]
          }
        }
      ]
    }
  }.to_json,
  "Content-Type" => "application/json"

session_id = JSON.parse(response.body)["value"]["sessionId"]

# Visit URL
URL = "https://chromedriver-test2-68b14b07e585.herokuapp.com/"

response = Net::HTTP.post \
  URI.parse("http://localhost:9515/session/#{session_id}/url"),
  {
    "url": URL
  }.to_json,
  "Content-Type" => "application/json"

# Find submit button
response = Net::HTTP.post \
  URI.parse("http://localhost:9515/session/#{session_id}/element"),
  {
    "using": "css selector",
    "value": "input[type=submit]"
  }.to_json,
  "Content-Type" => "application/json"

element_id = JSON.parse(response.body)["value"].values.first

# Click submit button
time = Benchmark.measure do
  response = Net::HTTP.post \
    URI.parse("http://localhost:9515/session/#{session_id}/element/#{element_id}/click"),
    {}.to_json,
    "Content-Type" => "application/json"
end

puts time
