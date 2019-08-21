require 'test_helper'

module Workarea
  class CleanContentTest < TestCase
    include TestCase::SearchIndexing

    def test_perform
      page = create_page(name: 'Foo')

      Content.for(page).save
      CleanContent.new.perform(page.id.to_s, page.class.name)
      assert_equal(1, Search::Storefront::Content.count)

      page.update(active: false)
      CleanContent.new.perform(page.id.to_s, page.class.name)
      assert_equal(0, Search::Storefront::Content.count)

      page.update(active: true)
      CleanContent.new.perform(page.id.to_s, page.class.name)
      assert_equal(1, Search::Storefront::Content.count)

      page.destroy
      CleanContent.new.perform(page.id.to_s, page.class.name)
      assert_equal(0, Search::Storefront::Content.count)
    end

    def test_index_exclusion
      Workarea.with_config do |config|
        config.exclude_from_content_search_index << 'Workarea::Catalog::Product'
        product = create_product

        Workarea::Content.for(product).tap do |c|
          c.blocks.create!(type: :html, data: { 'html' => '<p>foo</p>' })
        end

        assert_no_difference -> { Search::Storefront::Content.count } do
          CleanContent.new.perform(product.id.to_s, product.class.name)
        end
      end
    end
  end
end
