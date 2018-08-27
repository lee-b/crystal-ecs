# A simple Entity Component System (ECS)
module Ecs
    VERSION = "0.1.0"

    # Defines an Entity, which can represent any object types
    # and behaviours by attaching Components as needed.
    class Entity
        @components = Hash(Component.class, Component).new

	    def component(subclass : Component.class) : Component
	        subinstance = @components[subclass].downcast()
            subclass.cast subinstance
   	    end
    end

    # Defines an abstract Component, which provides properties or
    # behaviours to an Entity
    abstract class Component
        abstract def component : Component.class

        def downcast()
            component_type = self.component()
            component_type.cast self
        end
    end

    # Helper class, which provides easy filtering/querying of multiple Sets
    # of values (V), selected by Hash keys (K).
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

    # Manager class which tracks Components and which Entities they've been
    # added to.
    class ComponentRegistry
        @@registry = {} of Component.class => Set(Entity)

        # Register a new Component class
        def register(component_class : Component.class)
            if ! @@registry.has_key?(component_class)
		        @@registry[component_class] = Set(Entity).new
            end
        end

        # Returns a HashSetQuery object for arbitrary filtering
        def query(): HashSetQuery(Component, Entity)
            HashSetQuery.new (@@registry)
        end

        # Returns an Enumerable over all Entities which have the given
        # Set of Components.
        def having(components : Set(Component.class)) : Set(Entity)
            query = HashSetQuery(Component.class, Entity).new @@registry
            query.all()
        end


        # Attaches the given Component to the given Entity.  Note that
        # multiple Entities can share a single instance of a Component,
        # which potentially allows lightweight objects with minimal
        # performance cost and memory usage.
        def attach(entity : Entity, component : Component)
            component_class = component.component()
            self.register(component_class)

            real_component = component.downcast()

            @@registry[component_class] << entity

            entity.@components[component_class] = real_component
        end
    end

end
