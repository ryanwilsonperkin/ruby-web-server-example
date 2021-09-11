class WebApplication

  class Request
    def initialize(request_hash)
      @request_hash = request_hash
    end

    def version
      @request_hash['version'].freeze
    end

    def method
      @request_hash['method'].freeze
    end

    def path
      @request_hash['path'].freeze
    end

    def headers
      @request_hash['headers'].freeze
    end

    def body
      @request_hash['body'].freeze
    end

    def to_s
      <<~EOF
        Version: #{version}
        Method: #{method}
        Path: #{path}
        Headers: #{headers}
        Body: #{body}
      EOF
    end
  end

  class Response
    attr_reader :body, :status

    def initialize(body, status: 200)
      @body = body
      @status = status
    end

    def headers
      {
        'Content-Length' => @body.length,
        'Content-Type' => 'text/plain'
      }
    end

    def to_ary
      [status, headers, body]
    end
  end

  # Receive a request from the WebServer and route it appropriately
  # Based on the path that was received, we'll forward to one of our
  # *_route methods which will respond with a specific format.
  #
  # Both our WebServer and WebApplication have to agree on the shape
  # of the request and response objects. We've defined the request
  # object (a hash with specific keys) in the WebServer. Now we'll
  # define the response format here which will be an array with three
  # values: an integer status code, a hash of headers, and a string body.
  def process(request_hash)
    request = Request.new(request_hash)
    case request.path
    when '/'
      index_route(request)
    when %r{^/sleep/\d+$}
      sleep_route(request)
    else
      Response.new(
        "No route found for #{request.path}. Try '/' or '/sleep/3'.",
        status: 404
      )
    end
  end

  def index_route(request)
    Response.new("Hello World!\n#{request}")
  end

  def sleep_route(request)
    seconds = request.path.delete_prefix('/sleep/').to_i
    sleep seconds
    Response.new("It took #{seconds}s to respond to this request!")
  end
end
