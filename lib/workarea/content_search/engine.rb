module Workarea
  module ContentSearch
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::ContentSearch

      config.to_prepare do
        Storefront::SearchViewModel.send(
          :include,
          Storefront::ContentSearchResults
        )
      end
    end
  end
end
