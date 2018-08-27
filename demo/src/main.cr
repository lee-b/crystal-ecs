# Demonstrates the use of crystal-ecs to create a pet dog, and
# activate it via a plugin which doesn't directly know about
# dogs.

require "ecs"
require "./plugin"

# Simple Pet Component, with a name
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

# Defines an Component from which all Mammals
# derive, with abstract, shared behaviours
abstract class Mammal < Ecs::Component
    def component()
        Mammal
    end

    abstract def noise() : String
end

# Implements Canine-specific Mammal behaviour
class Canine < Mammal
    def noise()
        "Bark"
    end
end


# Constructs the world, registering Entities and
# Components
def build_world(): Ecs::ComponentRegistry
    registry = Ecs::ComponentRegistry.new
	
    fido = Ecs::Entity.new

    fidos_petability = Pet.new "Fido"
    fidos_wolfiness = Canine.new

    registry.attach(fido, fidos_petability)
    registry.attach(fido, fidos_wolfiness)

    registry
end

# Main program entry point; builds the world,
# then runs all plugins which interact with
# that world
def main()
    registry = build_world()

    PLUGINS.each do |p|
        p.act(registry)
    end
end

main()
