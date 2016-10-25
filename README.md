# LazierEnum

_Lazier Enumerable and other mixins and helper classes to keep code lazy._

Ruby enumerations are great, and we should use them anywhere we can!  Lazy
enumerations are usually even better, because they avoid common performance
problems like loading entire files into memory for processing.

_*This library is a pre-release work in progress.  API is subject to change, and
some of the features described in this (aspirational) README file may not be
implemented yet.*_

## Overview

 * `Lazy::Enumerable` - a mixin like stdlib `Enumerable` but uses
   `Enumerator::Lazy`, so all of the methods that return enumerators are lazy.
 * `Lazier::Enumerable` - a mixin like `Lazy::Enumerable`, but returns lazy proxies for
   most non-enumerator returning methods.  Only a few methods (e.g. `first`,
   `force`, `to_a`, and predicates) are "kickers".
 * `Lazier::Forced::*` - mixins for classes that return an enumerable object
   from `#force`.
 * `Lazier::Proxy::*` - proxy classes for delayed execution.
 * `Lazier::Schema::*` - Attribute DSL for proxied objects (especially hashes).

See the rdoc for more details.

## Usage and quick example

_TODO: Write some quick examples_

## TODO

* add all methods that exist in stdlib `Enumerable`
* rename library?
* rdoc, examples
* Pipes - Treat lazy enums as pipes or streams.  API sugar: chain methods with
  enums as input and output.  Can also provide buffering and back-pressure.
* Monads - once you've delayed evaluation of everything, you've basically
  reinvented monads... so why not?
* Async/Promises/Futures - perhaps integrate the proxies classes with a simple
  promise library (e.g. `promise.rb`).  Allow for easy integration with
  EventMachine and concurrent-ruby.
* AST building => query-planning; allow for introspection on chained queries to
  construct e.g. SQL, concurrent HTTP requests, instead of pure-ruby
  enumeration..

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org].

## Contributing

Bug reports and pull requests are welcome on the [GitHub project page]. This
project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the [Contributor Covenant] code of
conduct.

## License

The gem is available as open source under the terms of the [MIT License].


[rubygems.org]: https://rubygems.org
[GitHub project page]: https://github.com/nevans/lazier_enum
[Contributor Covenant]: http://contributor-covenant.org
[MIT License]: http://opensource.org/licenses/MIT
