module Chili
  module Overrides
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.before_filter :activate_overrides
    end

    module InstanceMethods
      def activate_overrides
        Deface::Override.all.values.map(&:values).flatten.each do |override|
          if override.railtie_class.constantize.parent.respond_to? :active?
            override.args[:disabled] = !override.railtie_class.constantize.parent.active?(self)
          end
        end
      end
    end
  end
end
