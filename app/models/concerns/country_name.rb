module CountryName
  extend ActiveSupport::Concern
  included do

    def country_name
      country = ISO3166::Country[self.country_code]
      country.translations[I18n.locale.to_s] || country.name
    end

  end
end