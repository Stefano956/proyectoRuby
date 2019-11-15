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

    subject {HelloMeJob.new}

    describe "#perform" do
        it "Devuelve un String con un saludo personalizado segun los parametros de entrada" do         
            expect(subject.perform("a","b")).to eq("Hello a b")
        end
    end
end