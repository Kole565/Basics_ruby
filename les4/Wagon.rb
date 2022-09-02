class Wagon

    def initialize(id, type)
        @id = id
        @type = type
    end

    def to_s
        "#{id}"
    end

    # Getters
    def id
        @id
    end

    def type
        @type
    end

end
