require 'test_helper'

module Workarea
  class BulkIndexContentTest < Workarea::TestCase
    def test_peform
      Workarea::Search::Storefront.reset_indexes!

      Sidekiq::Callbacks.disable(IndexContent) do
        content = Array.new(2) { create_content(contentable: create_page) }
        content << create_content

        assert_equal(0, Search::Storefront.count)
        BulkIndexContent.new.perform(content.map(&:id))
        assert_equal(2, Search::Storefront.count)
      end
    end
  end
end
