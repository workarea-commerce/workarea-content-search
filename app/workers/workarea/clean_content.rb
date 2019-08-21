module Workarea
  class CleanContent
    include Sidekiq::Worker
    include Sidekiq::CallbacksWorker

    sidekiq_options(
      enqueue_on: {
        Contentable => [:save, :destroy],
        with: -> { [id, self.class.name] }
      }
    )

    def perform(id, type)
      object_id = BSON::ObjectId.from_string(id.to_s) rescue nil
      content =
        if object_id.present?
          Content.where(contentable_type: type)
                 .any_of({ contentable_id: id }, { contentable_id: object_id })
        else
          Content.where(contentable_type: type, contentable_id: id)
        end

      content.each do |model|
        search_model = Search::Storefront::Content.new(model)
        contentable = model.contentable

        if contentable&.active? && search_model.should_be_indexed?
          search_model.save
        else
          search_model.destroy rescue nil
        end
      end
    end
  end
end
