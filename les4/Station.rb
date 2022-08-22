class Station

    def initialize(name)
        @name = name

        @trains = []
    end

    def name
        @name
    end

    def receive_train(train)
        if @trains.include(train)
            print("Train already at station.")
            return
        end

        @trains << train
    end

    def trains
        @trains
    end

    def trains_types
        ret = ""

        ret += "Cargo: #{@trains.select { |train| train.type == "cargo" }.count}"
        ret += "Passanger: #{@trains.select { |train| train.type == "passanger" }.count}"

        ret
    end

    def launch_train(train)
        if train.next_station == nil
            # puts "Log: Train can't be launched. No next station."
            return
        end

        train.to_next_station
        @trains.delete(train)
    end

end
