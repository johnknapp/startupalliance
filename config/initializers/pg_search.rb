PgSearch.multisearch_options = {
    using:  { tsearch: { dictionary: 'english' },
              trigram: {}
            },
    ignoring: [:accents]
}