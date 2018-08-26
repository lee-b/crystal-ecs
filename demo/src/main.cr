require "ecs"
require "./plugin"

class Pet < Ecs::Component
    def component()
        Pet
    end

    def initialize(@pet_name : String)
    end

    def pet_name()
        @pet_name
    end
end

abstract class Mammal < Ecs::Component
    def component()
        Mammal
    end

    abstract def noise() : String
end

class Canine < Mammal
    def noise()
        "Bark"
    end
end

def build_world(): Ecs::ComponentRegistry
    registry = Ecs::ComponentRegistry.new
	
    fido = Ecs::Entity.new

    fidos_petability = Pet.new "Fido"
    fidos_wolfiness = Canine.new

    registry.attach(fido, fidos_petability)
    registry.attach(fido, fidos_wolfiness)

    registry
end

def main()
    registry = build_world()

    PLUGINS.each do |p|
        p.act(registry)
    end
end

main()
