require 'rspec'
require './server.rb'

describe "Server" do

    context "creating" do
        it "Al crear una instancia" do
            host = "a"
            port = 1
            aServer = Server.new(host, port)
            expect(aServer).to have_attributes(:host => "a", :port => 1)
        end      
    end

    describe "#Start" do
        it "Inicia el servidor" do 
            aServer = Server.new("localhost",2345)
            aServer.Start()
            expect(aServer.socket).to be_instance_of(TCPServer)
        end
    end

    describe "#Listen" do
    end
end

describe "ServerWorker" do

    context "creating" do
        it "Al crear una instancia" do
            worker = ServerWorker.new()
            expect(worker.serverJobsQueue).to be_instance_of(Queue)
        end 
    end

    describe "#Perform" do
        it "Ejecuta un trabajo saltandose la Queue" do
            worker = ServerWorker.new()
            expect(worker.Perform(HelloWorld.new)).to eq("Hello World!")
        end
    end

    describe "#Enqueue" do
        it "Agrega un trabajo a la Queue" do
            worker = ServerWorker.new()
            job = HelloWorld.new
            expect(worker.Enqueue(job)).to eq(job.object_id)
        end
    end

    describe "#Enqueue_In" do
        it "Agrega un trabajo a la Queue en una determinada cantidad de segundos" do
            worker = ServerWorker.new()
            job = HelloWorld.new
            expect(worker.Enqueue(job)).to eq(job.object_id)
        end
    end

    describe "#Process_Queue" do

    end
end


describe "ClientController" do

    context "creating" do
        it "Al crear una instancia" do
        end
    end

    describe "#HandleRequest" do 
        it "Recibe un request, determina el tipo de comando y ejecuta la accion correspondiente" do
            control = ClientController.new(ServerWorker.new)            
            expect(control.HandleRequest("perform_now helloworld")).to eq("Hello World!")            
        end
    end

    describe "#perform_now" do 
        it "Retorna el resultado del trabajo procesado por el serverWorker saltando la Queue" do
            control = ClientController.new(ServerWorker.new)            
            expect(control.perform_now(["perform_now","helloworld"])).to eq("Hello World!")
        end
    end

    describe "#perform_later" do 
        it "Retorna el resultado del trabajo procesado por el serverWorker siguiendo el orden de la Queue" do
            control = ClientController.new(ServerWorker.new)            
            expect(control.perform_later(["perform_now","helloworld"])).to be_instance_of(Integer)
        end
    end

    describe "#perform_in" do 
        it "Retorna el resultado del trabajo procesado por el serverWorker siguiendo el orden de la Queue en una cantidad X de segundos" do
            control = ClientController.new(ServerWorker.new)            
            expect(control.perform_in(["perform_now","1","helloworld"])).to be_instance_of(Integer)
        end
    end

    describe "#Get_Job" do 
        it "Recibe el nombre de un trabajo y sus parametros si corresponde y devuelve el objeto correspondiente al trabajo" do
            control = ClientController.new(ServerWorker.new)            
            expect(control.Get_Job("helloworld")).to be_instance_of(HelloWorld)
            expect(control.Get_Job("HelloMeJob", "a", "b")).to be_instance_of(HelloMeJob)
        end
    end

    describe "#Check_Time" do
        it "Recibe un String como argumento y devuelve un entero que lo representa. En caso de no poder convertir retorna cero" do
            control = ClientController.new(ServerWorker.new)            
            expect(control.Check_Time("10")).to eq(10)
            expect(control.Check_Time("NotANumber")).to eq(0)
        end
    end
end
