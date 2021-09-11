class WebApplication
  # Receive a request from the WebServer and route it appropriately
  # Based on the path that was received, we'll forward to one of our
  # *_route methods which will respond with a specific format.
  #
  # Both our WebServer and WebApplication have to agree on the shape
  # of the request and response objects. We've defined the request
  # object (a hash with specific keys) in the WebServer. Now we'll
  # define the response format here which will be an array with three
  # values: an integer status code, a hash of headers, and a string body.
  def process(request)
    case request['path']
    when '/'
      index_route(request)
    when %r{/\d+}
      number_route(request)
    else
      not_found_route(request)
    end
  end

  def index_route(request)
    status = 200
    body = "Hello World! #{request}"
    headers = { 'Content-Type': 'text/plain', 'Content-Length': body.length }
    [status, headers, body]
  end

  def number_route(request)
    number = request['path'].delete_prefix('/')
    status = 200
    body = "You asked for the number #{number}"
    headers = { 'Content-Type': 'text/plain', 'Content-Length': body.length }
    [status, headers, body]
  end

  def not_found_route(request)
    status = 404
    body = "No route found for #{request['path']}. Try '/' or a number like '/123'."
    headers = { 'Content-Type': 'text/plain', 'Content-Length': body.length }
    [status, headers, body]
  end
end
