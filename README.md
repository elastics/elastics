[![Elastics Logo](https://raw.github.com/elastics/elastics/master/elastics-logo-200.png)](http://elastics.github.io/elastics)

[![Gem Version](https://badge.fury.io/rb/elastics-client.png)](http://badge.fury.io/rb/elastics-client)

__Elastics__ _(used as a plural noun, meaning "rubber bands")_ is a collection of ruby tools for [elasticsearch](http://elasticsearch.org). It is powerful, fast and efficient, easy to use and customize.

It covers ALL the elasticsearch API, and transparently integrates it with your app and its components, like `Rails`, `ActiveRecord`, `Mongoid`, `ActiveModel`, `will_paginate`, `kaminari`, `elasticsearch-mapper-attachments`, ...

It also implements and integrates very advanced features like chainable scopes, live-reindex, cross-model syncing, query fragment reuse, parent/child relationships, templating, self-documenting tools, detailed debugging, ...

It is composed by 6 gems: you can use them together or separately, depending on your needs:

- `elastics-client`
- `elastics-rails`
- `elastics-models`
- `elastics-scopes`
- `elastics-admin`


## Quick Start

The Elastics documentation is very complete and detailed, so starting from the right topic for you will save you time. Please, pick the starting point that better describes you below:

### For Tire Users

1. You may be interested to start from [Why you should use Elastics rather than Tire](http://elastics.github.io/elastics/doc/7-tutorials/1-Elastics-vs-Tire.html) that is a direct comparison between the two projects.

2. Depending on your elasticsearch knowledge you can read below the "Elasticsearch Beginner" or the "Elasticsearch Expert" starting point sections.

### For Flex 0.x Users

1. If you used an old flex version, please start with [How to migrate from flex 0.x](http://elastics.github.io/elastics/doc/7-tutorials/2-Migrate-from-0.x.html).

2. Depending on your elasticsearch knowledge you can read below the "Elasticsearch Beginner" or the "Elasticsearch Expert" sections.

### For Elasticsearch Beginners

1. You may want to start with the [Index and Search External Data](http://elastics.github.io/elastics/doc/7-tutorials/4-Index-and-Search-External-Data.html) tutorial, since it practically doesn't require any elasticsearch knowledge. It will show you how to build your own search application with just a few lines of code. You will crawl a site, extract its content and build a simple user interface to search it with elasticsearch.

2. Then you may want to read the [Usage Overview](http://elastics.github.io/elastics/doc/1-elastics/2-Usage-Overview.html) page. Follow the links from there in order to dig into the topics that interest you.

3. You will probably like the [elastics-scopes](http://elastics.github.io/elastics/doc/3-elastics-scopes) that allows you to easy search, chain toghether and reuse searching scopes in pure ruby.

### For Elasticsearch Experts

1. Elastics provides the full elasticsearch APIs as ready to use methods. Just take a look at the [API Metods](http://elastics.github.io/elastics/doc/2-elastics-client/2-API-Methods.html) page to appreciate its completeness.

2. Then you may want to read the [Usage Overview](http://elastics.github.io/elastics/doc/1-elastics/2-Usage-Overview.html) page. Follow the links from there in order to dig into the topics that interest you.

3. If you are used to create complex searching logic, you will certainly appreciate the [Templating System](http://elastics.github.io/elastics/doc/2-elastics-client/3-Templating/1-Templates.html) that gives you real power with great simplicity.

4. As an elasticsearch expert, you will certainly appreciate the [Live-Reindex](http://elastics.github.io/elastics/doc/6-elastics-admin/2-Live-Reindex.html) feature: it encapsulates the solution to a quite complex problem in just one method call.

## Links

- __Project Documentation__
  - [Elastics Project](http://elastics.github.io/elastics)
- __Gem-Specific Documentation__
  - [elastics-client](http://elastics.github.io/elastics/doc/2-elastics-client)
  - [elastics-rails](http://elastics.github.io/elastics/doc/5-elastics-rails)
  - [elastics-models](http://elastics.github.io/elastics/doc/4-elastics-models)
  - [elastics-scopes](http://elastics.github.io/elastics/doc/3-elastics-scopes)
  - [elastics-admin](http://elastics.github.io/elastics/doc/6-elastics-admin)
- __[Issues](https://github.com/elastics/elastics/issues)__
- __[Pull Requests](https://github.com/elastics/elastics/pulls)__

## Branches

The `master` branch reflects the last published gems. The `dev` branch is the development branch and may get rebased or force-pushed.

## Credits

Special thanks for their sponsorship to [Escalate Media](http://www.escalatemedia.com) and [Barquin International](http://www.barquin.com).

## Copyright

Copyright (c) 2012-2013 by [Domizio Demichelis](mailto://dd.nexus@gmail.com)<br>
See [LICENSE](https://github.com/elastics/elastics/blob/master/LICENSE) for details.
