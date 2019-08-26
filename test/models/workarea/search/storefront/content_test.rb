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

        def test_use_meta_description_for_text_when_available
          page = create_page
          model = Workarea::Content.for(page).tap do |content|
            content.blocks.create!(
              type: :html,
              data: {
                'html' => '<p>lorem ipsum dolor sit amet</p>'
              }
            )
          end
          content = Content.new(model)

          assert_equal('lorem ipsum dolor sit amet', content.text)

          model.update!(meta_description: 'foo bar baz')
          content = Content.new(model)

          assert_equal('foo bar baz', content.text)
        end
      end
    end
  end
end
