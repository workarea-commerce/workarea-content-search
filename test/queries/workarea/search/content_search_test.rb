require 'test_helper'

module Workarea
  module Search
    class ContentSearchTest < IntegrationTest
      def test_sorts_results_with_summary_text_above_those_without_if_no_sort
        one = Content.for(create_page(slug: '1'))
        two = Content.for(create_page(slug: '2'))
        three = Content.for(create_page(slug: '3'))

        two.blocks.create!(
          type: :html,
          data: { 'html' => Workarea.config.placeholder_text }
        )

        IndexContent.perform(two)

        search = ContentSearch.new(q: '*')
        assert_equal(3, search.total)
        assert_equal(two.contentable.slug, search.results.first['slug'])
        assert_equal(one.contentable.slug, search.results.second['slug'])
        assert_equal(three.contentable.slug, search.results.third['slug'])

        search = ContentSearch.new(q: '*', sort: 'newest')
        assert_equal(3, search.total)
        assert_equal(three.contentable.slug, search.results.first['slug'])
        assert_equal(two.contentable.slug, search.results.second['slug'])
        assert_equal(one.contentable.slug, search.results.third['slug'])
      end

      def test_remove_content_from_index_when_contentable_destroyed
        query = Workarea.config.placeholder_text.split(' ').first
        page = create_page
        _content = create_content(contentable: page, blocks: [
          {
            type: :html,
            data: { 'html' => Workarea.config.placeholder_text }
          }
        ])
        search = ContentSearch.new(q: query)

        refute_empty(search.results)
        assert_equal(1, search.total)
        assert_includes(search.results.first['slug'], page.slug)

        page.destroy!
        search = ContentSearch.new(q: query)

        assert_empty(search.results)
      end

      def test_remove_content_from_index_when_contentable_deactivated
        query = Workarea.config.placeholder_text.split(' ').first
        page = create_page
        _content = create_content(contentable: page, blocks: [
          {
            type: :html,
            data: { 'html' => Workarea.config.placeholder_text }
          }
        ])
        search = ContentSearch.new(q: query)

        refute_empty(search.results)
        assert_equal(1, search.total)
        assert_includes(search.results.first['slug'], page.slug)

        page.update!(active: false)
        search = ContentSearch.new(q: query)

        assert_empty(search.results)
      end
    end
  end
end
