class Route

    def initialize(first, last)
        @first = first
        @last = last

        @mid = []
    end

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

    def format_stations
        ret = ""

        stations.each do |station|
            ret += "Name: #{station.name}\n"
        end

        ret
    end

    def add_intermediate(station)
        if stations.include?(station)
            # puts "Log: Station already used."
            return
        end

        @mid << station
    end

    def previous_station_from(station)
        if station == @first
            return
        end
        
        stations[stations.index(station)-1]
    end

    def next_station_from(station)
        if station == @last
            return
        end
        
        stations[stations.index(station)+1]
    end

end
