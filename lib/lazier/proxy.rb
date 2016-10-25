require "forwardable"
require "lazier/enumerable"
require "lazier/forced"
require "lazier/schema"

module Lazier

  module Proxy

    # does nothing but delegate force to parent
    class Basic
      extend Forwardable
      include Enumerable

      attr_reader :parent
      def initialize(parent)
        @parent = parent
      end

      def force
        forced = parent.force
        forced = forced.force while forced.respond_to?(:force)
        forced
      end

    end

    # n.b. this is not thread-safe.  if you want that, use concurrent ruby's
    # promises or futures instead.
    #
    # TODO: use promise.rb to simplify (and extend) wrap/unwrap code
    class CachedCallable
      include Enumerable
      include Forced

      def initialize(callable=nil, &block)
        raise ArgumentError if callable && block
        @callable = callable || block or raise ArgumentError
      end

      def force
        @result = wrap if pending?
        unwrap
      end

      alias_method :call, :force

      def pending?; nil == @result end
      def error?; Exception === @result end
      def success?; !pending? && !error? end

      def error; error? && @result end
      def value; success? && unwrap end

      private

      NIL_RESULT = Object.new.freeze

      def wrap
        result = @callable.call
        nil == result ? NIL_RESULT : result
      rescue => ex
        ex
      end

      def unwrap
        case @result
        when NIL_RESULT; nil
        when Exception;  raise @result
        else @result
        end
      end

      # convenience class; includes Forced::Hash
      class Hash < CachedCallable
        include Forced::Hash
      end

      # convenience class; includes Forced::Array
      class Array < CachedCallable
        include Forced::Array
      end

    end

    # Digs down path from parent resource using #[]
    #
    # Resources must respond to #to_ary (Array-like) or #to_hash (Hash-like),
    # but they don't need to be an actual Array or Hash.
    class Indexed < Basic
      include Forced::Indexable

      # can be empty, which is ultimately no different than Basic
      attr_reader :path
      def initialize(parent, *path)
        super(parent)
        unless parent.respond_to?(:to_ary) || parent.respond_to?(:to_hash)
          raise TypeError
        end
        @path = path
      end

      # nils along the path will return into nil
      def force
        forced = path.inject(parent) do |field, key|
          return nil if field.nil?
          unless field.respond_to?(:to_ary) || field.respond_to?(:to_hash)
            raise TypeError
          end
          field[key]
        end
        forced = forced.force while forced.respond_to?(:force)
        forced
      end

      # overrides Indexable to stay rooted from parent resource
      def dig(*deeper, type: Indexed)
        type.new(parent, *path, *deeper)
      end

      def inspect
        "#<%s %s in %p>" % [
          self.class, path.map(&:to_s).join("."), parent,
        ]
      end

      # optimistically, always allow #to_a
      def to_a; Array(force) end
      # optimistically, always allow #to_h; but may throw TypeError
      def to_h; Hash(force) end

    end

    class Hash < Indexed
      include Forced::Hash
    end

    class Array < Indexed
      include Forced::Array
    end

    class Numeric < Basic
      delegate to_i:    :force
      delegate to_f:    :force
      delegate to_int:  :force
    end

    class Timestamp < Numeric
      def to_time
        raise NotImplementedError
      end
    end

    class TimeRFC822 < String
      def to_time
        raise NotImplementedError
      end
    end

    class TimeISO8601 < String
      def to_time
        raise NotImplementedError
      end
    end

  end

end
