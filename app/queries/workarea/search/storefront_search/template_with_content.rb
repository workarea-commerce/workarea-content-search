module Workarea
  module Search
    class StorefrontSearch
      class TemplateWithContent
        include Middleware

        def call(response)
          if response.has_filters?
            yield
            return
          end

          if response.total.zero? && response.content_total.zero?
            response.template = 'no_results'
          elsif response.params[:type].present?
            response.template = response.params[:type]
          elsif response.params[:sort].present?
            response.template = 'show'
          elsif response.content_total > response.total
            response.template = 'content'
          else
            yield
          end
        end
      end
    end
  end
end
