module Workarea
  class IndexContent
    include Sidekiq::Worker
    include Sidekiq::CallbacksWorker

    sidekiq_options(
      enqueue_on: {
        Content => [:save, :destroy],
        Content::Block => [:save, :destroy],
        with: -> { respond_to?(:content) ? content.id : id }
      },
      unique: :until_executing
    )

    class << self
      def perform(content)
        search_model = Search::Storefront::Content.new(content)

        if content.persisted? && search_model.should_be_indexed?
          search_model.save
        else
          begin
            search_model.try(:destroy)
          rescue
            nil # It's OK if it doesn't exist
          end
        end
      end

      # Test whether this content model should be indexed.
      #
      # @param [Workarea::Content] content - Model to be tested
      # @return [Boolean] +true+ if the model should skip the index.
      # @deprecated Use +Workarea::Search::Storefront::Content#should_be_indexed?+
      #             instead.
      def skip_index?(content)
        !Search::Storefront::Content.new(content).should_be_indexed?
      end
    end

    def perform(id)
      model = Content.find_or_initialize_by(id: id)
      self.class.perform(model)
    end
  end
end
