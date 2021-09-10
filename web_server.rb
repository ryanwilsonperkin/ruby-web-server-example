require 'socket'

class WebServer
  HOST = '127.0.0.1'
  PORT = 8000
  MAX_REQUEST_SIZE = 1024

  def initialize
    @server = TCPServer.new HOST, PORT
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
  def response
    response_body = 'Hello World!'
    <<~EOF
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: #{response_body.length}

      #{response_body}
    EOF
  end

  def serve
    puts "[INFO] Accepting connections at http://#{HOST}:#{PORT}"
    puts '[INFO] Exit this program with CTRL-C'

    loop do
      connection = @server.accept
      request = connection.recv MAX_REQUEST_SIZE
      puts request
      connection.puts response
      connection.close
    end
  end
end

WebServer.new.serve
