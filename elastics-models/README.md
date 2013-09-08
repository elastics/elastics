# elastics-models

[![Gem Version](https://badge.fury.io/rb/elastics-models.png)](http://badge.fury.io/rb/elastics-models)

Transparently integrates your models with one or more elasticsearch indices:

* Automatic integration with your `ActiveRecord` and `Mongoid` models
* Direct management of indices throught `ActiveModel`
   * Validations and callbacks
   * Typecasting
   * Attribute defaults
   * Persistent storage with optimistic lock update
   * integration with the `elasticsearch-mapper-attachment` plugin
   * finders, chainable scopes etc. {% see 4.3 %}
* Automatic generation of elasticsearch mappings based on your models
* Parent/Child Relationships
* Bulk import
* Real-time indexing and search capabilities

## Links

- __Gem-Specific Documentation__
  - [elastics-models](http://elastics.github.io/elastics/doc/4-elastics-models)

## Credits

Special thanks for their sponsorship to [Escalate Media](http://www.escalatemedia.com) and [Barquin International](http://www.barquin.com).

## Copyright

Copyright (c) 2012-2013 by [Domizio Demichelis](mailto://dd.nexus@gmail.com)<br>
See [LICENSE](https://github.com/elastics/elastics/blob/master/elastics/LICENSE) for details.
