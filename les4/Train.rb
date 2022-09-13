require_relative "modules/Manufacture"

class Train
    extend Manufacture
    attr_reader :id, :type, :wagons, :speed, :route, :current_station

    def initialize(id, type)
        @id = id
        @type = type

        @speed = 0
        @wagons = []
    end

    def to_s
        "#{id} #{type.capitalize}"
    end

    def info
        ret = "#{id} #{type.capitalize}\n"
        ret += "Маршрут #{route}\n" unless route.nil?
        ret += wagons.select { |wagon| wagon.to_s }.join("\n") if wagons_amount != 0
        ret
    end

    def wagons_amount
        wagons.size
    end

    def previous_station
        if !route
            return
        elsif current_station == route.first
            return
        end

        route.previous_station_from(current_station)
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
    def speed=(speed)
        @speed = if speed < 0
                     0
                 else
                     speed
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

    def join_wagon(wagon)
        return if speed != 0
        return if wagon.type != type

        wagons.append(wagon)
    end

    def unjoin_wagon
        return if speed != 0
        return if wagons_amount == 0

        wagons.pop
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

        current_station.delete_train self if current_station.trains.include? self

        accelerate(100)
        self.current_station = route.next_station_from(current_station)
        brake(1000)

        route_ended if current_station == route.last
    end

    def route_ended
        puts "Train #{id} achieve last station."
        route_reset
    end

    # Formatters
    def format_id
        "Train id: #{id}" if id
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
        "Previous station is: #{previous_station.name}" if previous_station
    end

    def format_current_station
        "Current station is: #{current_station.name}." if current_station
    end

    def format_next_station
        "Next station is: #{next_station.name}." if next_station
    end
end
