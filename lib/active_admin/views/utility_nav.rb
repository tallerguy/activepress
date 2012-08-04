module ActiveAdmin
  module Views
    class UtilityNav < Component
      def tag_name
        "ul"
      end

      def build(namespace)
        super(:id => "utility_nav", :class => "nav pull-right")
        @namespace = namespace

        if current_active_admin_user?
          li class: 'dropdown' do
            build_current_user
            build_logout_link
          end
        end
      end

      private

      def build_current_user
        a class: 'dropdown-toggle', 'data-toggle' => 'dropdown', 'href' => '#' do
          display_name(current_active_admin_user)
        end
      end

      def build_logout_link
        if @namespace.logout_link_path
          ul class: 'dropdown-menu' do
            li do
              text_node helpers.link_to(I18n.t('active_admin.logout'), active_admin_logout_path, :method => logout_method)
            end
          end
        end
      end

      # Returns the logout path from the application settings
      def active_admin_logout_path
        helpers.render_or_call_method_or_proc_on(self, @namespace.logout_link_path)
      end

      def logout_method
        @namespace.logout_link_method || :get
      end

    end
  end
end
