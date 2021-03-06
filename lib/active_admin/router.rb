module ActiveAdmin
  class Router

    def initialize(application)
      @application = application
    end

    # Creates all the necessary routes for the ActiveAdmin configurations
    #
    # Use this within the routes.rb file:
    #
    #   Application.routes.draw do |map|
    #     ActiveAdmin.routes(self)
    #   end
    #
    def apply(router)
      # Define any necessary dashboard routes
      router.instance_exec(@application.namespaces.values) do |namespaces|
        namespaces.each do |namespace|
          if namespace.root?
            match '/' => 'dashboard#index', :as => 'dashboard'
          else
            name = namespace.name
            match name.to_s => "#{name}/dashboard#index", :as => "#{name.to_s}_dashboard"
            match "/#{name}/preview" => "#{name}/dashboard#preview", as: :preview
          end
        end
      end

      # Now define the routes for each resource
      router.instance_exec(@application.namespaces) do |namespaces|
        resources = namespaces.values.collect{|n| n.resources.resources }.flatten
        resources.each do |config|

          # Define the block the will get eval'd within the namespace
          route_definition_block = Proc.new do
            case config
            when Resource
              resources config.resource_name.route_key do
                # Define any member actions
                member do
                  config.member_actions.each do |action|
                    # eg: get :comment
                    send(action.http_verb, action.name)
                  end
                end

                # Define any collection actions
                collection do
                  config.collection_actions.each do |action|
                    send(action.http_verb, action.name)
                  end

                  post :batch_action
                end
              end
            when Page

              match "/#{config.resource_name.singular}" => "#{config.resource_name.singular}#index"
              config.page_actions.each do |action|
                match "/#{config.underscored_resource_name}/#{action.name}" => "#{config.underscored_resource_name}##{action.name}", :via => action.http_verb
              end
            else
              raise "Unsupported config class: #{config.class}"
            end
          end

          # Add in the parent if it exists
          if config.belongs_to?
            routes_for_belongs_to = route_definition_block.dup
            route_definition_block = Proc.new do
              # If its optional, make the normal resource routes
              instance_eval &routes_for_belongs_to if config.belongs_to_config.optional?

              # Make the nested belongs_to routes
              # :only is set to nothing so that we don't clobber any existing routes on the resource
              resources config.belongs_to_config.target.resource_name.plural, :only => [] do
                instance_eval &routes_for_belongs_to
              end
            end
          end

          # Add on the namespace if required
          if !config.namespace.root?
            routes_in_namespace = route_definition_block.dup
            route_definition_block = Proc.new do
              namespace config.namespace.name do
                instance_eval(&routes_in_namespace)
              end
            end
          end

          instance_eval &route_definition_block
        end
      end
    end

  end
end
