require_relative "Station"
require_relative "Route"
require_relative "Train"


stations_names = ["Moskow", "Obninsk", "Lower New City", "Samara", "Tokio", "Naberejnaya Chelnu", "Wonderland", "Neapol", "Moon"]
stations = {}
stations_names.each do |name|
    stations[name] = Station.new(name)
end

routes = [
    Route.new(stations["Moskow"], stations["Obninsk"]),
    Route.new(stations["Samara"], stations["Naberejnaya Chelnu"]),
    Route.new(stations["Moskow"], stations["Moon"]),
    Route.new(stations["Moon"], stations["Moskow"]),
]
routes[1].add_intermediate(stations["Wonderland"])

stations.values.slice(1, stations.length-1).each do |station|
    routes[2].add_intermediate(station)
end
stations.values.reverse.slice(1, stations.length-1).each do |station|
    routes[3].add_intermediate(station)
end

trains = [
    Train.new("Smokey", "passanger", 3),
    Train.new("FastBoiii", "cargo", 500),
    Train.new("SpaceInvader3000", "cargo", 20),
]
trains[0].assign_route(routes[0])
trains[1].assign_route(routes[1])
trains[2].assign_route(routes[2])


def trains_info(trains)
    trains.each do |train|
        puts "\nTrain #{train.id}"
        puts "  #{train.format_speed}"
        puts "  #{train.format_wagons_amount}"
        puts "  Station status:"
        puts "      #{train.format_previous_station}"
        puts "      #{train.format_current_station}"
        puts "      #{train.format_next_station}"
        puts
    end
end

def trains_go(trains)
    trains.each do |train|
        train.to_next_station
    end
end

def third_train_update(trains, routes)
    if trains[2].current_station != trains[2].route.last
        return
    end

    if trains[2].route == routes[2]
        trains[2].assign_route(routes[3])
    else
        trains[2].assign_route(routes[2])
    end
end


inp = ""
while inp != "exit"
    puts "There trains info after one station step:"

    trains_go(trains)
    trains_info(trains)
    third_train_update(trains, routes)

    puts "Want another one? (type 'exit' for quit)"
    inp = gets.chomp

    if !["y", "yes", ""].include?(inp.downcase)
        break
    end
end
