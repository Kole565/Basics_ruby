class Train
    
    def initialize(id, type, wagons_amount)
        @id = id
        @type = type
        @wagons_amount = wagons_amount
        
        @speed = 0
    end

    def id
        @id
    end

    def route
        @route
    end
    
    def assign_route(route)
        @route = route
        @current_station = route.first
    end
    
    def speed
        @speed
    end

    def format_speed
        if speed != 0
            "Current speed: #{@speed} km/h."
        else
            "Train idle."
        end
    end

    def wagons_amount
        @wagons_amount
    end

    def format_wagons_amount
        if wagons_amount != 0
            "Train have #{wagons_amount} wagon(s)."
        else
            "Train don't have wagons."
        end
    end

    def accelerate(inc)
        if inc <= 0
            # puts "Log: Don't use 'accelerate' method with negative increment. Use 'brake' instead."
            return
        end

        @speed += inc
    end

    def brake(dec)
        if @speed < dec
            @speed = 0
        else
            @speed -= dec
        end
    end

    def join_wagon
        if @speed != 0
            # puts "Log: Train moving. Can't join wagon."
            return
        end

        @wagons_amount += 1
    end

    def unjoin_wagon
        if @speed != 0
            # puts "Log: Log: Train moving. Can't unjoin wagon."
            return
        elsif @wagons_amount <= 0
            # puts "Log: Log: No wagons to unjoin."
            return
        end

        @wagons_amount -= 1
    end

    def to_next_station
        if !@route
            # puts "Log: Route not defined."
            return
        elsif @current_station == @route.last
            # puts "Log: No further stations."
            return
        end
        
        accelerate(100)
        @current_station = @route.next_station_from(@current_station)
        @speed = 0

        if @current_station == @route.last
            puts "Train #{@id} acheive destination!"
        end
    end

    def to_previous_station
        if !@route
            # puts "Log: Route not defined."
            return
        elsif @current_station == @route.first
            # puts "Log: No further stations."
            return
        end
        
        accelerate(100)
        @current_station = @route.previous_station_from(@current_station)
        @speed = 0
    end

    def previous_station
        if @current_station == @route.first
            # puts "Log: No further stations."
            return
        end

        @route.previous_station_from(@current_station)
    end

    def format_previous_station
        if previous_station
            "Previous station is: #{previous_station.name}"
        end
    end

    def current_station
        @current_station
    end

    def format_current_station
        "Current station is: #{current_station.name}."
    end

    def next_station
        if @current_station == @route.last
            # puts "Log: No further stations."
            return
        end

        @route.next_station_from(@current_station)
    end

    def format_next_station
        if next_station
            "Next station is: #{next_station.name}."
        end
    end

end
