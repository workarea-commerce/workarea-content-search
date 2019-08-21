Workarea Content Search
================================================================================

A Workarea Commerce plugin that enables visitors of your site to use the site-wide search to find content pages.

Overview
--------------------------------------------------------------------------------

* Indexes content pages in Elasticsearch
* Enables returning both product and content search results on the storefront
* Adds the ability for visitors to toggle between content and product results

Getting Started
--------------------------------------------------------------------------------

Add the gem to your application's Gemfile:

```ruby
# ...
gem 'workarea-content_search'
# ...
```

Update your application's bundle.

```bash
cd path/to/application
bundle
```

If you are adding this to an existing site, reindex the storefront.

```bash
bin/rails workarea:search_index:storefront
```

Workarea Commerce Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea Commerce documentation.

License
--------------------------------------------------------------------------------

Workarea Content Search is released under the [Business Software License](LICENSE)
