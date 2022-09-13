module InstanceCounter
    @@instances = 0

    def register_instance
        @@instances += 1
    end
end
