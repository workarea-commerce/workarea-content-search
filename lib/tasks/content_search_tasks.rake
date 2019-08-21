# desc "Explaining what the task does"
# task :content_search do
#   # Task goes here
# end

Rake::Task['workarea:search_index:storefront'].enhance do
  Workarea::BulkIndexContent.perform
end
