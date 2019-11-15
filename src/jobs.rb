class HelloWorld
    def perform
        "Hello World!"
    end    
end

class HelloMeJob
    def perform(first_name, last_name)
        "Hello #{first_name} #{last_name}"
    end    
end
