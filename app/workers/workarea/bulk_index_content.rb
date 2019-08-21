module Workarea
  class BulkIndexContent
    include Sidekiq::Worker

    sidekiq_options unique: :until_and_while_executing

    class << self
      def perform(ids = Content.pluck(:id))
        ids.each_slice(100) do |group|
          perform_by_models(Content.in(id: group).to_a)
        end
      end

      def perform_by_models(content)
        documents = content.map do |model|
          search_model = Search::Storefront::Content.new(model)
          next unless search_model.should_be_indexed?
          search_model.as_bulk_document
        end

        Search::Storefront.bulk(documents.compact)
      end
    end

    def perform(ids)
      self.class.perform(ids)
    end
  end
end
