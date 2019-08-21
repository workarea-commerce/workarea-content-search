module Workarea
  module Search
    class StorefrontSearch
      class SpellingCorrectionWithContent < StorefrontSearch::SpellingCorrection
        def find_spell_correction(response)
          return nil if response.has_filters? || any_results?(response)

          product_correction = response.query.query_suggestions.first
          content_correction = response.content_query.query_suggestions.first

          product_correction.presence || content_correction
        end

        def any_results?(response)
          response.total > 0 || response.content_query.total > 0
        end
      end
    end
  end
end
