module DateConverter
  extend ActiveSupport::Concern
  included do

    def string_to_date(string)
      if string.present?
        Time.strptime(string, '%m/%d/%Y').to_date
      end
    end

  end
end