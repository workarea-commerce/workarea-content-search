module Workarea
  module Storefront
    module ContentSearchResults
      def multiple_result_types?
        product_total > 0 && content_total > 0
      end

      def product_total
        model.total
      end

      def result_type
        if model.template == 'content'
          'content'
        else
          super
        end
      end
    end
  end
end
