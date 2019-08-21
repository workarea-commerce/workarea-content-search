require 'test_helper'

module Workarea
  class IndexContentTest < Workarea::TestCase
    include TestCase::SearchIndexing

    def test_excluding_content
      Search::Storefront.reset_indexes!

      content = [
        Content.for(create_page),
        Content.for('home_page'),
        Content.for(create_category),
        Content.for(create_search_customization)
      ]

      content.each { |c| IndexContent.perform(c) }

      assert_equal(1, Search::Storefront.count)

      results = Search::Storefront.search('*')['hits']['hits']
      assert_includes(results.first['_source']['id'], content.first.id.to_s)
    end

    def test_removing_content
      content = create_content(contentable: create_page)

      IndexContent.new.perform(content.id)
      assert_equal(Search::Storefront.count, 1)

      content.destroy!
      IndexContent.new.perform(content.id)
      assert(Search::Storefront.count.zero?)
    end

    def test_saving_from_block_changes
      content = Content.for(create_page)

      assert_equal(0, Search::Storefront.count)

      Sidekiq::Callbacks.enable(IndexContent) do
        content.blocks.create!(
          type: 'html',
          data: { html: '<p>foo bar!</p>' }
        )
      end

      assert_equal(1, Search::Storefront.count)
    end
  end
end
