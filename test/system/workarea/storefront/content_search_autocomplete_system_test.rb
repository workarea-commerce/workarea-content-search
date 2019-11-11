require 'test_helper'

module Workarea
  if Plugin.installed?(:search_autocomplete)
    module Storefront
      class ContentSearchAutocompleteSystemTest < Workarea::SystemTest
        def test_content_appears_in_autocomplete
          create_page(name: 'Content Test One')
          create_page(name: 'Content Test Two')
          create_page(name: 'Content Test Three')
          create_product(name: 'Test One')
          create_product(name: 'Test Two')
          create_search_by_week(query_string: 'test one', searches: 5, total_results: 5)
          create_search_by_week(query_string: 'test two', searches: 10, total_results: 5)

          visit storefront.root_path

          fill_in :q, with: 'te'

          within '#search_autocomplete' do
            assert_text(
              t(
                'workarea.storefront.search_autocomplete.content_heading',
                term: 'test two'
              )
            )
            assert_text('Content Test One')
            assert_text('Content Test Two')
            assert_text('Content Test Three')
          end
        end
      end
    end
  end
end
