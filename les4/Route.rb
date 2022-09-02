class Route

    def initialize(id, first, last)
        @id = id
        @first = first
        @last = last

        @mid = []
    end

    def to_s
        "#{id}"
    end

    def info
        ret = "Маршрут '#{id}' #{first.name} - #{last.name}\n"
        ret += "Станции:\n"
        ret += format_stations
        ret += "\n"
        ret
    end

    # Getters
    def first
        @first
    end

    def last
        @last
    end

    def id
        @id
    end

    def stations
        ret = @mid.clone
        
        ret.unshift(@first)
        ret.push(@last)

        ret
    end

    def mid
        @mid
    end
    
    # Logic
    def add_intermediate(station)
        if stations.include?(station)
            return
        end

        @mid << station
    end

    def del_intermediate(station)
        if !@mid.include?(station)
            return
        end

        @mid.delete station
    end

    def previous_station_from(station)
        if !station
            return
        elsif station == first
            return
        end
        
        stations[stations.index(station)-1]
    end

    def next_station_from(station)
        if !station
            return
        elsif station == last
            return
        end
        
        stations[stations.index(station)+1]
    end
    
    # Formatters
    def format_stations
        ret = ""

        stations.each_with_index do | station, ind |
            ret += "#{ind}. #{station.name}\n"
        end

        ret
    end

end
