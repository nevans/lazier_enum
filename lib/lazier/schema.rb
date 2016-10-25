
module Lazier

  # Extend your class with `field` declarations, to create attribute accessors
  # for specific fields.
  #
  # TODO: teach #field, #fetch, and #[] to honor schema (types)
  module Schema

    def field!(*args, **opts)
      field(*args, **opts, lazy: false)
    end

    def field(name, type=Proxy::Indexed, field_name: name, lazy: true)
      raise ArgumentError unless type <= Proxy::Indexed
      if lazy
        define_method name do
          field(field_name, type: type)
        end
      else
        define_method name do
          force[field_name]
        end
      end
    end

  end

end
