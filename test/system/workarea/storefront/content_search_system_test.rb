require 'test_helper'

module Workarea
  module Storefront
    class ContentSearchSystemTest < Workarea::SystemTest
      setup :set_products
      setup :index_products
      setup :set_search_settings

      def set_products
        @products = [
          create_product(
            name: 'Test Product 1',
            details: { 'Material' => 'Cotton' },
            filters: { 'Size' => %w(Large Medium), 'Color' => 'Red', 'Test' => 'true' },
            created_at: Time.now - 1.hour,
            variants: [{ sku: 'SKU1', regular: 10.to_m }]
          ),
          create_product(
            name: 'Test Product 2',
            details: { 'Material' => 'Wool' },
            filters: { 'Size' => %w(Medium Small), 'Color' => 'Red' },
            variants: [
              { sku: 'SKU2', regular: 5.to_m },
              { sku: 'SKU3', regular: 7.to_m }
            ]
          )
        ]
      end

      def index_products
        @products.each { |p| IndexProduct.perform(p) }
      end

      def set_search_settings
        update_search_settings
      end

      def test_searching_content
        create_page(name: 'Content Test')
        create_page(name: 'Content Test 2')
        create_page(name: 'Content Test 3')

        visit storefront.search_path(q: 'content')
        assert(page.has_content?('3 results'))
        assert(page.has_ordered_text?('Content Test', 'Content Test 2', 'Content Test 3'))

        select('Newest', from: 'sort_top')
        assert(page.has_ordered_text?('Content Test 3', 'Content Test 2', 'Content Test'))

        visit storefront.search_path(q: 'test')
        assert(page.has_content?('2 product results'))
        assert(page.has_content?('3 content result'))
        assert(page.has_content?('Content Test'))

        click_link '2 product results'
        assert(page.has_ordered_text?('Test Product 1', 'Test Product 2'))

        select('Newest', from: 'sort_top')
        assert(page.has_content?('Test Product'))
        assert(page.has_ordered_text?('Test Product 2', 'Test Product 1'))
      end

      def test_searching_content_when_a_product_spelling_correction_exists
        create_page(name: 'Content Text')
        visit storefront.search_path(q: 'text')
        assert(page.has_content?('Content Text'))
      end

      def test_filtering_product_search_below_number_of_content_results
        create_page(name: 'Content Test')
        create_page(name: 'Page Test')

        visit storefront.search_path(q: 'test')

        Capybara.match = :first
        click_link 'Large (1)'

        assert(page.has_content?('Test Product 1'))
        assert(page.has_no_content?('Test Product 2'))
        assert(page.has_no_content?('Content Test'))
        assert(page.has_no_content?('Page Test'))
      end

      def test_search_custom_content
        create_page(name: 'Content Test')
        create_page(name: 'Content Test 2')

        customization = create_search_customization(id: 'content')
        content = Content.for(customization)
        content.blocks.build(
          area: :above_results,
          type_id: :html,
          data: { html: '<p>Test Custom Content</p>' }
        )
        content.save!

        visit storefront.search_path(q: 'content')
        assert(page.has_content?('Test Custom Content'))
      end
    end
  end
end
