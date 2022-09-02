require_relative "Station"
require_relative "CargoTrain"
require_relative "PassangerTrain"
require_relative "Route"
require_relative "CargoWagon"
require_relative "PassangerWagon"


@stations = [
    Station.new("TS1"),
    Station.new("TS2"),
]
@trains = [
    CargoTrain.new("TCargo"),
    PassangerTrain.new("TPassanger"),
]
@routes = []
@wagons = []


@options_station = {
    "Просмотреть поезда на станции": lambda { |station| print_list(station.trains) },
    "Удалить станцию": lambda { |station| @stations.delete station },
    "Информация": lambda { |station| puts station.info },
}

@options_route = {
    "Добавить станцию к маршруту": lambda { |route| route_add_station(route) },
    "Удалить станцию из маршрута": lambda { |route| route_del_station(route) },
    "Удалить маршрут": lambda { |route| @routes.delete route },
    "Информация": lambda { |route| puts route.info },
}

@options_train = {
    "Назначить маршрут": lambda { |train| assign_route(train) },
    "Добавить вагон": lambda { |train| join_wagon(train) },
    "Удалить вагон": lambda { |train| unjoin_wagon(train) },
    "Переместить": lambda { |train| move(train) },
    "Удалить поезд": lambda { |train| @trains.delete train },
    "Информация": lambda { |train| puts train.info },
}

@options_menu = {
    "Создать станцию": lambda { create_station },
    "Создать маршрут": lambda { create_route },
    "Создать поезд": lambda { create_train },
    "Создать вагон": lambda { create_wagon },
    "Управлять станциями": lambda { manage(@stations, @options_station, "станция", "станции") },
    "Управлять маршрутами": lambda { manage(@routes, @options_route, "маршрут", "маршруты") },
    "Управлять поездами": lambda { manage(@trains, @options_train, "поезд", "поезда") },
    "Управлять вагонами": lambda { manage(@wagons, nil, "вагон", "вагоны", with_options=false) },
}


def create_station
    name = ask(["имя"])[0]
    if !name
        return
    end

    @stations.append(Station.new(name))
end

def create_route
    name = ask(["имя"])[0]
    print_list(@stations, "Станции (1)")
    first = ask_for_list(@stations, "номер станции", with_index=true)
    print_list(@stations, "Станции (2)")
    last = ask_for_list(@stations, "номер станции", with_index=true)
    
    route = Route.new(name, first, last)
    @routes.append(route)
end

def create_train
    name, type = ask(["имя", "тип"])
    case type.downcase
    when "cargo"
        train = CargoTrain.new(name)
    when "passanger"
        train = PassangerTrain.new(name)
    else
        return
    end

    @trains.append(train)
end

def create_wagon
    name, type = ask(["имя", "тип"])
    case type.downcase
    when "cargo"
        wagon = CargoWagon.new(name)
    when "passanger"
        wagon = PassangerWagon.new(name)
    else
        return
    end
    
    @wagons.append(wagon)
end


def manage(list, options, name, name_mult, with_options=true)
    if list.size == 0
        puts "#{name_mult.capitalize} отсутствуют"
        return
    end

    print_list(list, "Доступные #{name_mult.downcase}", with_index=true)
    obj = ask_for_list(list, "номер #{name.downcase}(а)")
    if !obj
        puts "Неверный индекс"
        return
    end

    if with_options
        print_options(options, [obj], cycled=false)
    end
end

def print_list(list, name=nil, with_index=false)
    if list.size == 0
        puts "Обьекты отсутствуют"
        return
    end

    if name
        puts "#{name}:"
    end

    if with_index
        list.each_with_index do | el, ind |
            puts "#{ind}. #{el.to_s}"
        end
    else
        list.each do | el |
            puts el.to_s
        end
    end
end

def ask_for_list(list, name)
    if list.size == 0
        return
    end

    ind = ask([name])
    if ind.nil? || ind[0].empty?
        return
    end
    if ind[0].to_i < 0 || ind[0].to_i >= list.size
        return
    end

    return list[ind[0].to_i]
end

def ask(names)
    arguments = []

    names.each do | name |
        puts "Введите #{name}:"
        inp = gets.chomp
        if ["end", "exit", "q", "quit"].include? inp.downcase
            return
        end
        
        arguments.append(inp)
    end
    
    arguments
end

def print_options(options, args=[], cycled=true)
    def print_options_iter(options, args)
        puts "Выберите действие:"
        options.each_with_index do | (desc, func), ind |
            puts "#{ind}. #{desc}"
        end

        func = ask_for_list(options.values, "действие")
        if func
            func.call(*args)
        end
    end

    if cycled
        while true
            if print_options_iter(options, args) == 1
                break
            end
        end
    else
        print_options_iter(options, args)
    end
end

def route_add_station(route)
    stations = @stations.select { |station| !route.stations.include? station}
    if stations.size == 0
        puts "Нет подходящих станций"
        return
    end

    print_list(stations, "Доступные станции", with_index=true)
    station = ask_for_list(stations, "номер станции")

    route.add_intermediate station
end

def route_del_station(route)
    if route.mid.size == 0
        puts "Нельзя удалить начальную или конечную станцию. Вместо этого удалите маршрут."
        return
    end

    print_list(route.mid, "Доступные станции", with_index=true)
    station = ask_for_list(route.mid, "номер станции")

    route.del_intermediate station
end

def assign_route(train)
    if @routes.size == 0
        puts "Нет маршрутов"
        return
    end

    print_list(@routes, "Маршруты", with_index=true)
    route = ask_for_list(@routes, "номер маршрута")
    if !route
        return
    end

    train.route = route
end

def join_wagon(train)
    wagons = @wagons.select { |wagon| wagon.type == train.type }
    if wagons.size == 0
        puts "Нет подходящих вагонов"
        return
    end
    print_list(wagons, "Вагоны", with_index=true)
    wagon = ask_for_list(wagons, "номер вагона")
    if !wagon
        return
    end

    train.join_wagon wagon
    @wagons.delete wagon
end

def unjoin_wagon(train)
    if train.wagons.size == 0
        puts "Нет вагонов"
        return
    end
    print_list(train.wagons, "Вагоны", with_index=true)
    wagon = ask_for_list(train.wagons, "номер вагона")
    if !wagon
        return
    end

    train.unjoin_wagon wagon
    @wagons.delete << wagon
end

def move(train)
    if train.route.nil?
        puts "На поезде не установлен маршрут"
        return
    end

    direction = ask(["Направление (1 - назад, 2 - вперед)"])[0]
    case direction
    when "1"
        train.to_previous_station
    when "2"
        train.to_next_station
    else
        puts "Неверное направление"
    end
end


if __FILE__ == $0
    print_options(@options_menu)
end
