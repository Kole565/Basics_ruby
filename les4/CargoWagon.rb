require_relative "Wagon"


class CargoWagon < Wagon

    def initialize(id)
        super(id, "Cargo")
    end

end
