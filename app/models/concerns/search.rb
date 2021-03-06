# TODO https://robots.thoughtbot.com/optimizing-full-text-search-with-postgres-tsvector-columns-and-triggers
# https://github.com/Casecommons/pg_search
# https://blog.pivotal.io/labs/labs/pg-search-how-i-learned-to-stop-worrying-and-love-postgresql-full-text-search
# https://www.youtube.com/watch?v=n41F29Qln5E

module Search
  extend ActiveSupport::Concern
  included do

    include PgSearch

    pg_search_scope :page_trisearch_search,
      against:  {title: 'B', content: 'A'},
      using:    { tsearch: { dictionary: 'english' },
                  trigram: {}
                },
      ignoring: [:accents]

    def self.page_trisearch(query)
      if query.present?
        page_trisearch_search(query)
      end
    end

    pg_search_scope :page_tsearch_search,
      against:  {title: 'B', content: 'A'},
      using:    { tsearch: { dictionary: 'english' } },
      ignoring: [:accents]

    def self.page_tsearch(query)
      if query.present?
        page_tsearch_search(query)
      end
    end

    pg_search_scope :alliance_tsearch_search,
      against:  {name: 'A', mission: 'A'},
      using:    { tsearch: { dictionary: 'english' } },
      ignoring: [:accents]

    def self.alliance_tsearch(query)
      if query.present?
        alliance_tsearch_search(query)
      end
    end

    pg_search_scope :quark_tsearch_search,
      against:  {text: 'A'},
      using:    { tsearch: { dictionary: 'english' } },
      ignoring: [:accents]

    def self.quark_tsearch(query)
      if query.present?
        quark_tsearch_search(query)
      end
    end

    pg_search_scope :classified_tsearch_search,
      against:  {title: 'B', body: 'A'},
      using:    { tsearch: { dictionary: 'english' } },
      ignoring: [:accents]

    def self.classified_tsearch(query)
      if query.present?
        classified_tsearch_search(query)
      end
    end

    pg_search_scope :event_tsearch_search,
      against:  {title: 'B', description: 'A'},
      using:    { tsearch: { dictionary: 'english' } },
      ignoring: [:accents]

    def self.event_tsearch(query)
      if query.present?
        event_tsearch_search(query)
      end
    end

  end
end