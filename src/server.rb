require 'socket'
load 'jobs.rb'

class MiServer

    def initialize(dir, puerto)
        @server = TCPServer.new(dir, puerto)
        @jobs_queue = Queue.new

        Thread.start do
            processQueue()
        end

        system("clear") || system("cls")

        puts "Server online... Localhost:2345"
        main
    end

    private
    def main
        loop{            
            session = @server.accept

            Thread.start(session) do
                |cliente_Con|                                                                            
                process(cliente_Con)               
                cliente_Con.close
            end
        }
    end

    private
    def process(cliente_Con)        
        loop {                                    
            request = cliente_Con.gets.chomp unless cliente_Con.nil?        
            requestHandler(request, cliente_Con) unless request.nil? || request.empty?
        }
    end    

    private
    def requestHandler(request, client)
        
        words = request.split(" ")        

        hello_world = Proc.new { HelloWorld.new.perform }
        hello_me_job = Proc.new { |first_name, second_name| HelloMeJob.new.perform(first_name, second_name) }

        case words[0].downcase
        when "perform_now"
            case words[1].downcase
            when "helloworld"
                client.puts hello_world.call
            when "hellomejob"
                client.puts hello_me_job.call(words[2],words[3])
            else
                client.puts "Invalid Job [#{words[0].downcase}]"
            end
        when "perform_later"
            case words[1].downcase
            when "helloworld"
                action = hello_world
                enqueue(hello_world)
                client.puts hello_world.object_id
            when "hellomejob"
                action = Proc.new { HelloMeJob.new.perform(words[2], words[3])}   
                enqueue(Proc.new { HelloMeJob.new.perform(words[2], words[3])})
                client.puts action.object_id
            else
                client.puts "Invalid Job [#{words[0].downcase}]"
            end
        when "perform_in"
            time = check_number(words[1])  

            case words[2].downcase
            when "helloworld"
                sleep time                
                enqueue(hello_world)
                client.puts hello_world.object_id
            when "hellomejob"
                sleep time
                action = Proc.new { HelloMeJob.new.perform(words[2], words[3])}                
                enqueue(action)
                client.puts action.object_id
            else
                client.puts "Invalid Job [#{words[0].downcase}]"
            end            
        when "exit"
            client.close
        else
            client.puts "Command type not valid [#{words[0].downcase}]"
        end
    end

    private
    def processQueue         
        loop{            
            puts "Processed: #{@jobs_queue.pop(false).call}"
        }
    end

    private 
    def enqueue(action)
        @jobs_queue.push(action)
    end

    private 
    def check_number(string)
        Integer(string)
        rescue
            return 0
    end

end

MiServer.new('localhost', 2345)