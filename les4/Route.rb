class Route

    def initialize(first, last)
        @first = first
        @last = last

        @mid = []
    end

    # Getters
    def first
        @first
    end

    def last
        @last
    end

    def stations
        ret = @mid.clone
        
        ret.unshift(@first)
        ret.push(@last)

        ret
    end
    
    # Logic
    def add_intermediate(station)
        if stations.include?(station)
            return
        end

        @mid << station
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

        stations.each do |station|
            ret += "Name: #{station.name}\n"
        end

        ret
    end

end
