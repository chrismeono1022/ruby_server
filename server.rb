require 'socket'

# all files server from only this dir
ROOT = './public'

CONTENT_TYPE = {
  'html' => 'text/html',
  'txt' => 'text/plain',
  'png' => 'image/png',
  'jpg' => 'image/jpeg'
}

# parse path and find content type; 'application/octet-stream' default for files without an extension (treated as binary) 
def content_type(path)
  extension = path.split(".").last
  type = CONTENT_TYPE[extension] ||= 'application/octet-stream'
end

# takes request - 'GET /anything HTTP/1.1' and parses it for file requested, then creates file path by adding './public'
def requested_file(request)
  file = request.split(" ")[1]
  File.join(ROOT, file)
end

# listen on localhost on port 2345
server = TCPServer.new('localhost', 2345)

# server ready to accept connections
STDERR.puts 'Server up and running'

# continous loop to process connections
loop do

  socket = server.accept

  # read request info
  request = socket.gets

  # print to console
  STDERR.puts request

  path = requested_file(request)

  # check if file exists and isn't a directory before opening it
  if File.exists?(path) && !File.directory?(path)
    File.open(path, 'rb') do |file|
      # a response is composed of a protocol/status code, content-type, content-length informing the client the size and type of data expected. HTTP is whitespace sensitive, and expects a new line "\r\n" at the end of each header
      socket.print "HTTP/1.1 200 OK\r\n" + 
                "Content-Type: text/pain\r\n" +
                "content-Length: #{file.size}\r\n"
                "Connection: close\r\n"
                
      # add new line to separate header from response body as required by HTTP
      socket.print "\r\n"

      # write file contents to socket
      IO.copy_stream(file, socket)
    end
  else
    message = "File not found\n"

    # response with 404
    socket.print "HTTP/1.1 404 Not Found\r\n" + 
                "Content-Type: text/pain\r\n" +
                "content-Length: #{message.bytesize}\r\n"
                "Connection: close\r\n"

    socket.print "\r\n"

    socket.print message
  end

  # terminate connection
  socket.close

end