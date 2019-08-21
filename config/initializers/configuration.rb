Workarea.configure do |config|
  config.storefront_search_middleware.swap(
    'Workarea::Search::StorefrontSearch::Template',
    'Workarea::Search::StorefrontSearch::TemplateWithContent'
  )

  config.storefront_search_middleware.swap(
    'Workarea::Search::StorefrontSearch::SpellingCorrection',
    'Workarea::Search::StorefrontSearch::SpellingCorrectionWithContent'
  )

  # Exclude content related to the list of classes from being index for
  # search. They will not show up in content search results.
  config.exclude_from_content_search_index = %w(
    Workarea::Catalog::Category
    Workarea::Search::Customization
    Workarea::Navigation::Menu
  )
end
