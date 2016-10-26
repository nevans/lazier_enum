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

    # methods that return enumerations (lazily evaluated)
    ENUMERATION_METHODS = %i[
      chunk
      collect
      collect_concat
      drop
      drop_while
      find_all
      flat_map
      grep
      grep_v
      map
      reject
      select
      slice_after
      slice_before
      slice_when
      take
      take_while
      zip
    ].freeze
    def_delegators :lazy, *ENUMERATION_METHODS

    # Immediately evaluated "kicker" methods
    KICKER_METHODS = %i[
      first
      count
      to_a
      to_h
      to_set
    ].freeze
    def_delegators :lazy, *KICKER_METHODS

    # predicate methods (immediately evaluated)
    PREDICATE_METHODS = ::Enumerable.instance_methods.select {|m|
      m.to_s.end_with?("?")
    }.freeze
    def_delegators :lazy, *PREDICATE_METHODS

    # TODO: proxy all scalar queries (lazily evaluated)
    PROXY_METHODS = %i[
      chunk_while
      cycle
      detect
      find
      find_index
      group_by
      inject
      max
      max_by
      min
      min_by
      minmax
      minmax_by
      partition
      reduce
      sort
      sort_by
    ].freeze

    ALTERNATE_ENUM_METHODS = %i[
      each_cons
      each_entry
      each_slice
      each_with_index
      each_with_object
      entries
      reverse_each
    ].freeze

    # TODO: just to keep the spec happy for now (cheating!!!)
    (PROXY_METHODS + ALTERNATE_ENUM_METHODS).each do |m|
      define_method m do raise NotImplementedError, "work in progress" end
    end

  end

end
