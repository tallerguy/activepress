module ActiveAdmin
  class Resource
    module Naming
      # Returns the name to call this resource such as "Bank Account"
      def resource_name
        @resource_name ||= @options[:as]
        @resource_name ||= singular_resource_name
      end

      # Returns the plural version of this resource such as "Bank Accounts"
      def plural_resource_name
        @plural_resource_name ||= @options[:as].pluralize if @options[:as]
        @plural_resource_name ||= resource_name.pluralize
      end

      # A name used internally to uniquely identify this resource
      def resource_key
        camelized_resource_name
      end

      # A camelized safe representation for this resource
      def camelized_resource_name
        resource_name.titleize.gsub(' ', '')
      end

      def plural_camelized_resource_name
        plural_resource_name.titleize.gsub(' ', '')
      end

      # An underscored safe representation internally for this resource
      def underscored_resource_name
        camelized_resource_name.underscore
      end

      # Returns the plural and underscored version of this resource. Useful for element id's.
      def plural_underscored_resource_name
        plural_camelized_resource_name.underscore
      end

      # @return [String] Titleized human name via ActiveRecord I18n or nil
      def singular_human_name
        if resource_class.respond_to?(:model_name)
          resource_class.model_name.human.titleize
        end
      end
      
      def singular_resource_name
        if resource_class.respond_to?(:model_name)
          resource_class.model_name.titleize
        else
          resource_class.name.gsub('::',' ')
        end
      end
      
      # @return [String] Titleized plural human name via ActiveRecord I18n or nil
      def plural_human_name
        resource_class.model_name.human.pluralize.titleize
      end
    end
  end
end
