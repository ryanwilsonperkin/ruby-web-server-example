require 'socket'

class WebServer
  HOST = '127.0.0.1'
  PORT = 8000
  MAX_REQUEST_SIZE = 1024

  def serve
    # Create a new TCPServer bound to our computer on port 8000
    # This will make it accessible in the browser at http://127.0.0.1:8000
    # It _won't_ yet respond with a valid message, so the browser will
    # likely show an error message when we visit it.
    server = TCPServer.new HOST, PORT
    puts "[INFO] Accepting connections at http://#{HOST}:#{PORT}"
    puts '[INFO] Exit this program with CTRL-C'

    # This server will loop forever until you kill it with CTRL-C
    # Each pass through the loop will accept 1 web request, print
    # it out, and then close the request.
    loop do
      connection = server.accept
      request = connection.recv MAX_REQUEST_SIZE
      puts request
      connection.close
    end
  end
end

WebServer.new.serve
