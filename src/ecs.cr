module Ecs
    VERSION = "0.1.0"

    class Entity
        @components = Hash(Component.class, Component).new

	    def component(subclass : Component.class) : Component
	        subinstance = @components[subclass].downcast()
            subclass.cast subinstance
   	    end
    end

    abstract class Component
        abstract def component : Component.class

        def downcast()
            component_type = self.component()
            component_type.cast self
        end
    end

    class HashSetQuery(K, V)
        @result = Set(V).new

        def initialize(@registry : Hash(K, Set(V)))
            # start with all possible values as the matching result
            @result = @registry.reduce(Set(V).new) { |reg, (k, v)| reg | v }
        end

        def having(property_ids : Set(V))
            # filter result by the given properties
            property_ids.each do |property_id|
                @result &= @registry[property_id]
            end
        end

        def all()
            @result
        end
    end

    class ComponentRegistry
        @@registry = {} of Component.class => Set(Entity)

        def register(component_class : Component.class)
            if ! @@registry.has_key?(component_class)
		        @@registry[component_class] = Set(Entity).new
            end
        end

        def query(): HashSetQuery(Component, Entity)
            HashSetQuery.new (@@registry)
        end

        def having(components : Set(Component.class)) : Set(Entity)
            query = HashSetQuery(Component.class, Entity).new @@registry
            query.all()
        end

        def attach(entity : Entity, component : Component)
            component_class = component.component()
            self.register(component_class)

            real_component = component.downcast()

            @@registry[component_class] << entity

            entity.@components[component_class] = real_component
        end
    end

end
