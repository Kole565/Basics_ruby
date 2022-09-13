require_relative "modules/Manufacture"

class Wagon
    extend Manufacture
    attr_reader :id, :type

    def initialize(id, type)
        @id = id
        @type = type
    end

    def to_s
        "#{id}"
    end
end
