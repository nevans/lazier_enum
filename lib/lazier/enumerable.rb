require "forwardable"

module Lazier

  # A clone of ruby stdlib's `Enumerable` module, except that even more methods are
  # "lazy".  Methods like `#reduce` or `find` will return proxy objects that need to
  # be forced (with `#force` or `#to_a`, etc) before they are evaluated.
  #
  # This can allow construction of complex queries with delayed evaluation of
  # expensive operations (e.g. IO, HTTP requests, DB queries).
  #
  # The kicker methods (methods that immediately evaluate, instead of returning a
  # lazy proxy or lazy enum) are whitelisted:
  #  * `#first`
  #  * `#force`
  #  * `#to_a`, `#to_h`, `#to_*`
  #
  #
  #
  #
  #
  # Also includes defaults for e.g. to_h and to_a
  #
  # This should be safe to include into:
  #  * simple single HTTP endpoint resources
  #  * combined multi HTTP endpoint resources
  #  * proxy resources (fields, etc)
  #
  # The including module defines +#force+, which returns an object that:
  #  * responds to each, fetch, and []
  #  * can be coerced with Array() and Hash()
  #
  # The including module should also override #each, #[], and #fetch, if it can
  # be lazier or more efficient than calling #force.
  #
  # All methods in these modules should follow the laziness rules:
  #  * Immediately evaluated:
  #    * force, first, fetch, each, and sometimes []
  #    * coercion methods (starting with "to_")
  #    * predicate methods (ending in "?")
  #    * bang methods (ending in "!")
  #  * Lazily evaluated
  #    * slice and sometimes [] (TODO)
  #    * all other methods
  #
  module Enumerable
    extend Forwardable

    delegate lazy: :to_enum
    delegate to_a:  :lazy

    ## enumerations (lazily evaluated)

    delegate map:        :lazy
    delegate flat_map:   :lazy
    delegate collect:    :lazy
    delegate select:     :lazy
    delegate reject:     :lazy
    delegate grep:       :lazy
    delegate grep_v:     :lazy
    delegate take:       :lazy
    delegate take_while: :lazy

    # predicates (immediately evaluated)

    delegate any?:     :lazy
    delegate all?:     :lazy
    delegate include?: :lazy
    delegate none?:    :lazy
    delegate one?:     :lazy

    # scalar values (immediately evaluated)

    delegate first:    :lazy

    # TODO: scalar queries (lazily evaluated)
    # e.g. find, min, max, minmax, reduce/inject

  end

end
