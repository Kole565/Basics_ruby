class Station

    def initialize(name)
        @name = name

        @trains = []
    end

    def to_s
        return "#{name}"
    end

    def info
        ret = "Станция #{name}\n"
        if trains.size == 0
            return ret
        end
        ret += "Поезда:\n"
        ret += trains.select{ |train| train.to_s }.join("\n")
        ret
    end
    
    # Getters
    def name
        @name
    end

    def trains
        @trains
    end
    
    def trains_types
        ret = "Trains on #{name} station:\n"

        cargo = trains.select { |train| train.type == "cargo" }.count
        passanger = trains.select { |train| train.type == "passanger" }.count
        ret += "  Cargo: #{cargo}\n" if cargo != 0
        ret += "  Passanger: #{passanger}\n" if passanger != 0

        ret += "\n"

        ret
    end

    # Logic
    def receive_train(train)
        if @trains.include?(train)
            # puts "Train already at station."
            return
        end

        @trains << train
    end

    def launch_train(train)
        if !train.next_station
            # puts "Log: Train can't be launched. No next station."
            return
        end

        train.to_next_station
        delete_train(train)
    end

    def delete_train(train)
        @trains.delete(train)
    end

end
