# TODO https://robots.thoughtbot.com/optimizing-full-text-search-with-postgres-tsvector-columns-and-triggers

PgSearch.multisearch_options = {
    using:  { tsearch: { dictionary: 'english' },
              trigram: {}
            },
    ignoring: [:accents]
}