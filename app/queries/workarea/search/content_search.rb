module Workarea
  module Search
    class ContentSearch
      include Query
      include QuerySuggestions
      include Pagination

      document Search::Storefront

      def self.available_sorts
        Sort::Collection.new(Sort.relevance, Sort.newest)
      end

      def customization
        @customization ||= Customization.find_by_query(params[:q])
      end

      def rewritten_query
        if customization.rewrite?
          customization.rewrite
        else
          query_string.sanitized
        end
      end

      def query
        if params[:q].present? && !query_string.all?
          {
            multi_match: {
              query: rewritten_query,
              type: 'cross_fields',
              fields: %w(content.name^2 content.text^0.75),
              tie_breaker: Workarea.config.search_dismax_tie_breaker
            }
          }
        else
          super
        end
      end

      def post_filter
        filters = super
        filters[:bool] ||= {}
        filters[:bool][:must] ||= []
        filters[:bool][:must] << { term: { type: 'content' } }
        filters
      end

      def sort
        result = []
        selected_sort = self.class.available_sorts.find(params[:sort])

        if selected_sort.field.present?
          result << { selected_sort.field => selected_sort.direction }
        else
          result << {
            'sorts.has_text' => {
              order: 'desc',
              missing: '_last',
              unmapped_type: 'float'
            }
          }
          result << { _score: :desc }
        end

        result
      end

      def results
        @results ||=
          begin
            tmp = response['hits']['hits'].map do |result|
              result['_source']
            end

            PagedArray.from(
              tmp,
              page,
              per_page,
              total
            )
          end
      end

      # (sadpanda) QuerySuggestions looks to product display rules for
      # conditions to use when generating suggestions. We need content search
      # to respond to the method to prevent any issues with suggestions for
      # content.
      #
      # TODO: for v4, rework QuerySuggestions to not depend on another module
      def product_display_query_clauses
        []
      end
    end
  end
end
