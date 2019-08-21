module Workarea
  module Storefront
    class ContentSearchViewModel < ApplicationViewModel
      include Pagination
      include SearchCustomizationContent
      include ContentSearchResults

      ContentResult = Struct.new(:name, :resource_name, :summary, :to_param)

      def search_query
        content_query
      end

      def content
        @content ||=
          begin
            results = content_query.results.map do |result|
              ContentResult.new(
                result['content']['name'],
                result['cache']['resource_name'],
                result['content']['summary'],
                result['slug']
              )
            end

            PagedArray.from(results, page, per_page, total)
          end
      end

      def query_suggestions
        @query_suggestions ||=
          begin
            all = Recommendation::Searches.find(options[:q]) +
                  model.query_suggestions

            all.take(3)
          end
      end

      def sort
        content_query.class.available_sorts.find(options[:sort])
      end

      def sorts
        content_query.class.available_sorts.map { |s| [s.name, s.slug] }
      end
    end
  end
end
