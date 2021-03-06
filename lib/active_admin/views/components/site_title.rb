module ActiveAdmin
  module Views

    class SiteTitle < Component

      def tag_name
        'span'
      end

      def build(namespace)
        super(:id => "site_title")
        @namespace = namespace

        if site_title_link?
          text_node site_title_with_link
        else
          text_node site_title_content
        end
      end

      def site_title_link?
        @namespace.site_title_link.present?
      end

      def site_title_image?
        @namespace.site_title_image.present?
      end

      private

      def site_title_with_link
        helpers.link_to(site_title_content, @namespace.site_title_link)
      end

      def site_title_content
        if site_title_image?
          title_image
        else
          title_text
        end
      end

      def title_text
        link_to(@namespace.site_title, '#', :class => 'brand')
      end

      def title_image
        path = helpers.render_or_call_method_or_proc_on(self, @namespace.site_title_image)
        helpers.image_tag(path, :id => "site_title_image", :alt => @namespace.site_title)
      end

    end

  end
end
