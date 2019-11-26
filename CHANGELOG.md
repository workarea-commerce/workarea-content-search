Workarea Content Search 1.0.9 (2019-10-30)
--------------------------------------------------------------------------------

*   Update checking for SearchSuggestion content to ensure decoration loading

    CONTSEARCH-2
    Matt Duffy



Workarea Content Search 1.0.8 (2019-07-09)
--------------------------------------------------------------------------------

*   Open Source!


Workarea Content Search 1.0.7 (2019-07-09)
--------------------------------------------------------------------------------

*   Choose Default Search Response Template When Sorting Without Type

    When no `:type` is given, and search results are being sorted, assume
    that this sort was triggered from the "default" product search and not
    content search, and render the default search results template rather
    than the one for content search. This prevents a bug whereby a customer
    was not able to sort product results if more content results were found
    than products, because the search page would always render the content
    template rather than the products search template.

    CONTSEARCH-12
    Tom Scott



Workarea Content Search 1.0.6 (2019-05-28)
--------------------------------------------------------------------------------

*   Ensure BulkIndexContent documents array does not contain nil objects

    CONTSEARCH-15
    Matt Duffy



Workarea Content Search 1.0.5 (2019-05-14)
--------------------------------------------------------------------------------

*   Fix Models Excluded From Index Appearing in Content Search

    Refactor the `IndexContent.skip_index?` method as
    `Search::Storefront::Content#should_be_indexed?`, a core feature that
    allows Elasticsearch documents to control whether they can be indexed or
    not. In the `Search::Storefront` base document class, this method returns
    `true`, but here in `Workarea::ContentSearch` it should be dependent on
    the configuration. Update the `CleanContent` and `IndexContent` jobs to
    call this method before attempting to save a piece of content into the
    index.

    CONTSEARCH-13
    Tom Scott

*   Allows sort submission to return to the current search type

    CONTSEARCH-12
    Lucas Boyd



Workarea Content Search 1.0.4 (2019-02-05)
--------------------------------------------------------------------------------

*   Update indexing behavior for storefront content

    Trigger indexing of content when blocks are changed and
    allow contentable changes to trigger a reindex of the content

    CONTSEARCH-8
    Matt Duffy

*   Update for workarea v3.4 compatibility

    CONTSEARCH-11
    Matt Duffy

*   Remove content from search index when Contentable is deleted

    CleanContent can sometimes be passed an BSON::ObjectId as a string,
    causing the lookup of the content to fail. Querying for the id as
    either an BSON::ObjectId or String.

    CONTSEARCH-7
    Matt Duffy

*   Remove Content From Search Index When Contentable is Removed

    When a `Contentable` object is removed from the search index for
    whatever reason, ensure that its content is also removed from the index.
    Prevents 404s on the storefront when clicking links to contentables that
    either no longer exist, or are no longer active.

    CONTSEARCH-7
    Tom Scott



Workarea Content Search 1.0.3 (2018-07-10)
--------------------------------------------------------------------------------

*   Fix Gemfile

    Curt Howard

*   Remove use of .percolate method for es index

    CONTSEARCH-6
    Matt Duffy

*   Leverage Workarea Changelog task

    ECOMMERCE-5355
    Curt Howard



Workarea Content Search 1.0.1 (2017-05-30)
--------------------------------------------------------------------------------

*   Initialization clean up, exclude content from search suggestions

    CONTSEARCH-4
    Matt Duffy

*   Decorate core test to update assertions affected by content search

    CONTSEARCH-4
    Matt Duffy


Workarea Content Search 1.0.0 (2017-05-04)
--------------------------------------------------------------------------------

