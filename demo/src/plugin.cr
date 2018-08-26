abstract class Plugin
    abstract def act(registry : Ecs::Registry)
end

class MammalIntroductions < Plugin
    def act(registry)
        props = Set { Pet, Mammal }

        registry.having(props).each do |e|
            pet = e.component(Pet)
            mammal = e.component(Mammal)

            pet_name = pet.pet_name()
            mammal_noise = mammal.noise()

            puts "#{pet_name} says #{mammal_noise}"
        end
    end
end

PLUGINS = [ MammalIntroductions.new ]
