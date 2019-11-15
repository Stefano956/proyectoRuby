require 'socket'

class Client
    def initialize(socket)
        @socket = socket
        @request = send_request
        @response = listen_response

        @request.join
        @response.join
    end

    private
    def send_request

        system("clear") || system("cls")

        puts "*** Connected to localhost 2345 ***\n\n"
        puts "Commands:"
        puts "perform_now jobName param1 param2"
        puts "perform_later jobName param1 param2"
        puts "perform_in time(seconds) jobName param1 param2"
        puts "\nJOBS: HelloWorld() || HelloMeJob(first_name, last_name)"
        puts"\n****************************************\n\n"
        Thread.new do
            loop {                
                comando = $stdin.gets.chomp
                @socket.puts comando
            }
        end
    end

    private
    def listen_response       
        Thread.new do
            loop {
                response = @socket.gets.chomp
                puts "\nServer => #{response}\n\n"
            }
        end        
    end

end

socket = TCPSocket.open("localhost", 2345)
Client.new(socket)