require 'test_helper'

module Workarea
  module Storefront
    class ContentSearchResultsTest < TestCase
      setup :reset_index

      def reset_index
        Search::Storefront.reset_indexes!
      end

      class FooSearchViewModel < ApplicationViewModel
        include ContentSearchResults
      end

      def test_multiple_result_types
        response = Search::StorefrontSearch::Response.new
        view_model = FooSearchViewModel.new(response)

        response.expects(:total).returns(0)
        refute(view_model.multiple_result_types?)

        response.expects(:total).returns(1)
        refute(view_model.multiple_result_types?)

        response.expects(:total).returns(0)
        refute(view_model.multiple_result_types?)

        response.expects(:total).returns(1)
        response.expects(:content_total).returns(1)
        assert(view_model.multiple_result_types?)
      end
    end
  end
end
