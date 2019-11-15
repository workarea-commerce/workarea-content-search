require 'test_helper'

module Workarea
  if Plugin.installed?(:search_autocomplete)
    module Storefront
      class SearchAutocompleteViewModelTest < Workarea::TestCase
        include TestCase::SearchIndexing

        def test_content
          query = QueryString.new('te').pretty
          search = Storefront::SearchAutocompleteViewModel.wrap(query)

          Sidekiq::Callbacks.enable do
            create_page(name: 'Content Test One')
            create_page(name: 'Content Test Two')
            create_page(name: 'Content Test Three')
            create_product(name: 'Test One')
            create_product(name: 'Test Two')
            create_search_by_week(
              query_string: 'test one',
              searches: 5,
              total_results: 5
            )
            create_search_by_week(
              query_string: 'test two',
              searches: 10,
              total_results: 5
            )
          end

          refute_empty(search.content_results)
          assert_equal(3, search.content_results.count)
        end
      end
    end
  end
end
