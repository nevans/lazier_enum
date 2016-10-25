require "forwardable"
require "lazier/enumerable"
require "lazier/schema"

module Lazier


  # Modules in Forced expect their including class to implement `#force`, and
  # may have further expectations on the (duck)type of the value returned from
  # `#force`.
  #
  # At the very least, they all implement `#each` to `force` (it is okay for
  # including classes to override).
  module Forced

    # This will immediately forward `#[]`, `#fetch`, `#each`, and `#to_a`.
    #
    # It will lazily proxy `#slice`, `#dig`, and `#field`
    module Indexable
      include Enumerable

      extend Forwardable
      delegate each: :force
      def_delegators :force, :fetch

      # predicates
      def_delegators :force, :empty?


      # TODO: make slice-style calls lazy
      delegate "[]" => :force

      def field(name, **opts)
        dig(name, **opts)
      end

      def dig(*path, type: nil)
        type ||= Proxy::Indexed
        type.new(self, *path)
      end

    end

    # Pretend that scalar values are a one-or-zero member list
    # This can be used in similar way as the Maybe monad.
    module Scalar
      extend Forwardable
      include Enumerable
      def to_a; [force] end
      delegate each: :to_a
      def_delegators :force, :to_i, :to_f, :to_s

      def empty?
        value = force
        if value.nil?; true
        elsif value.respond_to?(:empty?); value.empty?
        else false
        end
      end

    end

    # Hashes are autovivified: nil converts to {}
    # The forced value must be nil or hash-like (implement `#to_hash`)
    module Hash
      extend Forwardable
      include Indexable
      def self.included(mod) mod.extend(Schema) end
      def force; (super || {}).to_hash end
      def_delegator :self, :force, :to_hash
      def_delegator :self, :force, :to_h
    end

    # Arrays are autovivified: nil converts to []
    # The forced value must be nil or hash-like (implement `#to_ary`)
    module Array
      extend Forwardable
      include Indexable
      def force; (super || []).to_ary end
      def_delegator :self, :force, :to_ary
      def_delegator :self, :force, :to_a
    end

    # Strings are not autovivified; force may return nil.
    # The forced value must be nil or string-like (implement `#to_str`).
    # But if force returns nil, `#to_str` will crash.
    module String
      extend Forwardable
      include Scalar
      def force; (data = super).nil? ? data.to_str : nil end
      def_delegators :force, :to_str, :to_s
    end

  end

end
