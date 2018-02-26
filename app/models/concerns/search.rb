# https://github.com/Casecommons/pg_search
# https://blog.pivotal.io/labs/labs/pg-search-how-i-learned-to-stop-worrying-and-love-postgresql-full-text-search
# https://www.youtube.com/watch?v=n41F29Qln5E

module Search
  extend ActiveSupport::Concern
  included do

    include PgSearch

    pg_search_scope :trigram_search,
      against:  {title: 'B', content: 'A'},
      using:    { tsearch: { dictionary: 'english' },
                  trigram: {}
                },
      ignoring: [:accents]

    def self.trigram_page_search(query)
      if query.present?
        trigram_search(query)
      end
    end

    pg_search_scope :tsearch_search,
      against:  {title: 'B', content: 'A'},
      using:    { tsearch: { dictionary: 'english' } },
      ignoring: [:accents]

    def self.tsearch_page_search(query)
      if query.present?
        tsearch_search(query)
      end
    end

  end
end