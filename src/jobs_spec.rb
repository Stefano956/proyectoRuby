require 'rspec'
require './jobs.rb'


describe "HelloWorld" do
    
    subject {HelloWorld.new}

    describe "#perform" do
        it "Devuelve un String: Hello World" do            
            expect(subject.perform).to eq("Hello World!")
        end
    end
end

describe "HelloMeJob" do    
    context "creating" do
        it "Al crear una instancia" do              
            job = HelloMeJob.new("a", "b")
            expect(job).to have_attributes(:first_name => "a", :last_name => "b")    
        end
    end

    describe "#perform" do
        it "Devuelve un String con un saludo personalizado segun los parametros de entrada" do                  
            job = HelloMeJob.new("a","b")
            expect(job.perform()).to eq("Hello a b")
        end
    end
end