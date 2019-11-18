load 'client.rb'

socket = TCPSocket.open("localhost", 2345)
Client.new(socket)

puts "End - executeClient.rb"