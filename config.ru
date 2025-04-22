require "rack"

app = lambda do |env|
  req = Rack::Request.new(env)

  body = \
    if req.post?
      sleep 5
      "<h1>Post Response</h1>"
    else
      <<-HTML
        <!DOCTYPE html>
        <html>
        <body>
          <form method="POST" action="/">
            <input type="submit" value="Submit" />
          </form>
        </body>
        </html>
      HTML
    end

  [200, { "Content-Type" => "text/html" }, [body]]
end

run app
