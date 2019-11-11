Workarea.append_partials(
  'storefront.above_search_results',
  'workarea/storefront/searches/search_type_toggle'
)

if Workarea::Plugin.installed?(:search_autocomplete)
  Workarea.append_stylesheets(
    'storefront.components',
    'workarea/storefront/content_search/components/search_autocomplete'
  )

  Workarea.append_partials(
    'storefront.search_autocomplete_under_searches',
    'workarea/storefront/searches/autocomplete_content'
  )
end
