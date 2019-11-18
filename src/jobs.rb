class HelloWorld
    def perform()
        "Hello World!"
    end    
end

class HelloMeJob

    attr_accessor :first_name
    attr_accessor :last_name

    def initialize(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
    end

    def perform()
        "Hello #{@first_name} #{@last_name}"
    end
end
