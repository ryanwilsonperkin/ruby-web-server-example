require 'socket'

class WebServer
  HOST = '127.0.0.1'
  PORT = 8000
  MAX_REQUEST_SIZE = 1024

  def initialize
    @server = TCPServer.new HOST, PORT
  end

  # We'll convert the raw HTTP string into a series of lines
  # The first line will be considered the "Request Line" which
  # includes the method (eg. GET/POST), path, and HTTP version.
  #
  # Next comes the (optional) header lines with the key and value
  # separated by a colon.
  #
  # After the headers, there comes a single blank line as a delimeter.
  # In our parsing function, we use the presence of that line to find
  # the end of our headers, and the start of our body.
  #
  # After that, comes the body of the message itself.
  def parse_request(request_http)
    lines = request_http.split("\n")

    request_line = lines.shift
    method, path, version = request_line.split

    headers = {}
    loop do
      line = lines.shift
      break if line =~ /^\s*$/

      key, value = line.split(':', 2)
      headers[key] = value.strip
    end

    body = lines.join("\n")

    {
      'method' => method,
      'path' => path,
      'version' => version,
      'headers' => headers,
      'body' => body,
    }
  end

  # Our response must comply with the HTTP Spec
  # https://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html
  #
  # This says that our first line, the "status line", should consist
  # of the HTTP version number, followed by the status code.
  #
  # Subsequent lines are (optional) header lines, with the key and
  # value separated by a colon.
  #
  # After the headers, there comes a single blank line as a delimeter.
  #
  # After that, comes the body of the message itself.
  #
  # Most browsers will simply print this body out if it is text,
  # which is what we use in this example. HTML and other formats can
  # also be used here by setting the appropriate Content-Type header.
  def prepare_response(request)
    response_body = "Hello World!\n#{request}"
    <<~EOF
      HTTP/1.1 200 OK
      Content-Type: text/plain
      Content-Length: #{response_body.length}

      #{response_body}
    EOF
  end

  def serve
    puts "[INFO] Accepting connections at http://#{HOST}:#{PORT}"
    puts '[INFO] Exit this program with CTRL-C'

    loop do
      connection = @server.accept
      request_http = connection.recv MAX_REQUEST_SIZE
      request = parse_request(request_http)
      puts request
      connection.puts prepare_response(request)
      connection.close
    end
  end
end

WebServer.new.serve
