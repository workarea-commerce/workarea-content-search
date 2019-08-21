require 'test_helper'

module Workarea
  module Search
    class Storefront
      class ContentTest < Workarea::IntegrationTest
        def test_should_be_indexed
          Workarea.with_config do |config|
            config.exclude_from_content_search_index << 'Workarea::Catalog::Product'
            product = create_product
            content = Workarea::Content.for(product).tap do |c|
              c.blocks.create!(type: :html, data: { 'html' => '<p>foo</p>' })
            end
            product_content_search_model = Content.new(content)
            page = create_page
            content = Workarea::Content.for(page).tap do |c|
              c.blocks.create!(type: :html, data: { 'html' => '<p>foo</p>' })
            end
            page_content_search_model = Content.new(content)

            refute(product_content_search_model.should_be_indexed?)
            assert(page_content_search_model.should_be_indexed?)
          end
        end
      end
    end
  end
end
