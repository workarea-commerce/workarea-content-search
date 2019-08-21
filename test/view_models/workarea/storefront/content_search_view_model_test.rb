require 'test_helper'

module Workarea
  module Storefront
    class ContentSearchViewModelTest < TestCase
      include SearchIndexing
      include PaginationViewModelTest

      def create_search_response(options = {})
        attributes = { params: {} }.merge(options)

        result = Search::StorefrontSearch::Response.new(attributes)
        result.query = attributes[:query] if attributes[:query]
        result.content_query = attributes[:content_query] if attributes[:content_query]
        result
      end

      def view_model_class
        ContentSearchViewModel
      end
      alias pagination_view_model_class view_model_class
      alias search_content_view_model_class view_model_class

      def test_wraps_results_with_a_struct
        page = create_page(name: 'Foo')
        IndexContent.perform(Content.for(page))

        content_query = Search::ContentSearch.new(q: 'foo')
        response = create_search_response(content_query: content_query)

        view_model = ContentSearchViewModel.new(response)

        assert(
          view_model
            .content
            .first
            .instance_of?(ContentSearchViewModel::ContentResult)
        )

        assert_equal('Foo', view_model.content.first.name)
        assert_equal('page', view_model.content.first.resource_name)
        assert_equal(page.to_param, view_model.content.first.to_param)
      end

      def test_sorts
        view_model = ContentSearchViewModel.new(create_search_response)
        assert_equal(['Relevance', :relevance], view_model.sorts.first)
      end

      def test_query_suggestions
        response = create_search_response

        Recommendation::Searches.expects(:find).returns(%w(one))

        response.query.expects(:query_suggestions).returns(%w(two))
        response.content_query.expects(:query_suggestions).returns(%w(three))

        view_model = ContentSearchViewModel.new(response)
        assert_equal(%w(one two three), view_model.query_suggestions)
      end
    end
  end
end
