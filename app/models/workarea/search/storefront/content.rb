module Workarea
  module Search
    class Storefront
      class Content < Workarea::Search::Storefront
        # TODO: rename method ensure_dynamic_mappings
        def self.percolate_null_content
          content = new(Workarea::Content.new)
          content.save

          Storefront.delete(content.id)
        end

        def content
          { name: name, text: text, summary: text }
        end

        def sorts
          { has_text: text.present? ? 1 : 0 }
        end

        def cache
          { resource_name: resource_name }
        end

        def name
          model.contentable.try(:name)
        end

        def text
          @text ||= model.meta_description || text_extracted_from_blocks
        end

        def suggestion_content
          "#{name} #{text}"
        end

        def slug
          model.contentable.try(:slug)
        end

        def resource_name
          return nil unless model.contentable_type.present?
          model.contentable_type.underscore.split('/').last
        end

        def should_be_indexed?
          !model.system? &&
            !model.contentable.class.name.in?(
              Workarea.config.exclude_from_content_search_index
            )
        end

        private

        def text_extracted_from_blocks
          ExtractContentBlockText.new(model.blocks).text
        end
      end
    end
  end
end
