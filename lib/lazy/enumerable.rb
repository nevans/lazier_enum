require "lazier_enum"

module Lazy

  # A clone of ruby stdlib's `Enumerable` module, except that all of the methods use
  # the version from `Enumerator::Lazy` instead.  You provide a normal `#each` and
  # you automatically get lazy versions of `#map`, `#select`, `#reject`, `#take`,
  # etc.  This simply delegates the methods to an `Enumerator::Lazy`, so methods
  # like e.g. `#reduce` will force evaluation.
  #
  # TODO: *everything!*
  module Enumerable

  end

end
