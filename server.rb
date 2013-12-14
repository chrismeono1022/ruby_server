require 'socket'
require 'uri' 

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

def find_file(request)
  
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

  # test response
  response = "Hello World!\n"

  # a response is composed of a protocol/status code, content-type, content-length informing the client the size and type of data expected. HTTP is whitespace sensitive, and expects a new line "\r\n" at the end of each header
  socket.print "HTTP/1.1 200 OK\r\n" + 
                "Content-Type: text/pain\r\n" +
                "content-Length: #{response.bytesize}\r\n"
                "Connection: close\r\n"
                
  socket.print "\r\n" 
  # add new line to separate header from response body as required by HTTP

  # print response
  socket.print response

  # terminate connection
  socket.close

end