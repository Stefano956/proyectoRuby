require 'socket'
load 'jobs.rb'

#Otro comentario de prueba

class Server

    attr_reader :host
    attr_reader :port
    attr_reader :socket

    def initialize(host, port)
        @host = host
        @port = port
        @serverWorker = ServerWorker.new
    end

    def Start()
        @socket = TCPServer.new(@host, @port)
        @serverWorker.Process_Queue()
    end

    #Commited again to GitHub
    def Listen()
        puts "Server listening..."
        loop do
            Thread.start(@socket.accept){ |client|
                begin
                Thread.current.abort_on_exception = true                              
                clientControl = ClientController.new(@serverWorker)
                loop do
                    request = client.gets.chomp
                    if(request == "exit")
                        break
                    else                        
                        client.puts clientControl.HandleRequest(request)
                    end
                end
                client.close
                rescue
                    puts "Client disconnected"
                end
            }            
        end
    end

end

class ServerWorker

    attr_reader :serverJobsQueue

    def initialize()
        @serverJobsQueue = Queue.new
    end    

    def Perform(action)
        return action.perform unless action.nil?
        return "Job doesn't exists!"
    end

    def Enqueue(action)
        if !action.nil?
            @serverJobsQueue.push(action)
            return action.object_id
        else
            return "Job doesn't exists!"
        end
    end

    def Enqueue_In(action, time)
        if !action.nil?
            Thread.start{
                sleep time
                @serverJobsQueue.push(action)            
            }
            return action.object_id
        else
            return "Job doesn't exists!"
        end
    end           
    
    def Process_Queue()
        Thread.start{
            loop{
                puts "Job processed: #{@serverJobsQueue.pop(false).perform}"
            }
        }
    end

end

class ClientController

    def initialize(serverWorker)
        @serverWorker = serverWorker
    end

    def HandleRequest(request)
        rWords = request.split(" ")
        commandType = rWords[0]
        
        if(respond_to?(commandType.downcase))
            send(commandType.downcase, rWords)
        else
            return "Invalid command" 
        end
    end

    def perform_now(rWords)                
        return @serverWorker.Perform(Get_Job(rWords[1], rWords[2],rWords[3]))        
    end

    def perform_later(rWords)        
        return @serverWorker.Enqueue(Get_Job(rWords[1], rWords[2],rWords[3]))
    end

    def perform_in(rWords)
        time = Check_Time(rWords[1])
        return @serverWorker.Enqueue_In(Get_Job(rWords[2], rWords[3], rWords[4]), time)
    end

    def Get_Job(jobName, *params)
        job = nil        
        case jobName.downcase
        when "helloworld"
            job = HelloWorld.new()
        when "hellomejob"
            job = HelloMeJob.new(params[0],params[1])
        end
        return job
    end

    def Check_Time(time)
        Integer(time)
        rescue
            return 0
    end

end
