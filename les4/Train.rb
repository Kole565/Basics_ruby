class Train
    
    def initialize(id, type, wagons_amount)
        @id = id
        @type = type
        @wagons_amount = wagons_amount
        
        @speed = 0
    end

    # Getters
    def id
        @id
    end
    
    def type
        @type
    end
    
    def wagons_amount
        @wagons_amount
    end
    
    def speed
        @speed
    end

    def route
        @route
    end
    
    def previous_station
        if !route
            return
        elsif current_station == route.first
            return
        end

        route.previous_station_from(current_station)
    end
    
    def current_station
        @current_station
    end

    def next_station
        if !route
            return
        elsif current_station == route.last
            return
        end

        route.next_station_from(current_station)
    end

    # Setters
    def wagons_amount=(amount)
        if amount < 0
            @wagons_amount = 0
        else
            @wagons_amount = amount.to_i
        end
    end

    def speed=(speed)
        if speed < 0
            @speed = 0
        else
            @speed = speed
        end
    end
    
    def route=(route)
        @route = route
        self.current_station = route.first
    end

    def route_reset
        @route = nil
    end

    def current_station=(station)
        @current_station = station
        station.receive_train(self)
    end
    
    # Logic
    def accelerate(inc)
        if inc <= 0
            # puts "Log: Don't use 'accelerate' method with negative increment. Use 'brake' instead."
            return
        end
        
        self.speed += inc
    end

    def brake(dec)
        self.speed -= dec
    end

    def join_wagon
        if speed != 0
            return
        end

        self.wagons_amount += 1
    end

    def unjoin_wagon
        if speed != 0
            return
        end

        self.wagons_amount -= 1
    end

    def to_previous_station
        if !route
            return
        elsif current_station == route.first
            return
        end
        
        accelerate(100)
        self.current_station = route.previous_station_from(current_station)
        brake(1000)
    end

    def to_next_station
        if !route
            return
        elsif current_station == route.last
            return
        end

        if current_station.trains.include? self
            current_station.delete_train self
        end
        
        accelerate(100)
        self.current_station = route.next_station_from(current_station)
        brake(1000)

        if current_station == route.last
            route_ended
        end
    end

    def route_ended
        puts "Train #{id} achieve last station."
        route_reset
    end

    # Formatters
    def format_id
        if id
            "Train id: #{id}"
        end
    end

    def format_speed
        if speed != 0
            "Current speed: #{speed} km/h."
        else
            "Train idle."
        end
    end

    def format_wagons_amount
        if wagons_amount != 0
            "Train have #{wagons_amount} wagon(s)."
        else
            "Train don't have wagons."
        end
    end

    def format_previous_station
        if previous_station
            "Previous station is: #{previous_station.name}"
        end
    end

    def format_current_station
        if current_station
            "Current station is: #{current_station.name}."
        end
    end

    def format_next_station
        if next_station
            "Next station is: #{next_station.name}."
        end
    end

end
