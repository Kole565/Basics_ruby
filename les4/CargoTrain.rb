require_relative "Train"


class CargoTrain < Train

    def initialize(id)
        super(id, "Cargo")
    end

end
