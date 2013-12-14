require 'socket' 


# listen on localhost on port 2345
server = TCPServer.new('localhost', 2345)


# continous loop to process connections
loop do 
  socket = server.accept
end