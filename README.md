# crystal-ecs

This is a simple Entity Component System (ECS) for the Crystal language.

It allows you to define Entities with arbitrary behaviours and/or properties, and to lookup
Entities later which have any given combination of behaviours and properties.

A common use-case is in game engines, where you might want to define, say, animals, and have
one thread find all birds and perform bird-like behaviour, even if, say, a person has been
temporarily transformed into a bird, and is not defined in terms of a Bird class hierarchy.

A more complex example might be to create a new spell, action, or special move in a game engine,
which turns off all lights fueled by kerosene.  This might involve querying all entities that
share the Lightsource and FueledBy Components, querying which FueledBy components are kerosene,
and calling the `switch_off` method on the associated lightsource components.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  ecs:
    github: lee-b/crystal-ecs
```

## Usage

See the included demo

## Development

Improvements welcome.


## Contributing

1. Fork it (<https://github.com/your-github-user/ecs/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [lee-b](https://github.com/lee-b) Lee Braiden - creator, maintainer
