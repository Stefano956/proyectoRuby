require 'socket'
load 'server.rb'

MiServidor = Server.new('localhost',2345)

MiServidor.Start()
MiServidor.Listen()

puts "End - executeServer.rb"