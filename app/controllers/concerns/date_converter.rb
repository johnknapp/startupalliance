module DateConverter
  extend ActiveSupport::Concern
  included do

    def string_to_date(string)
      if string.present?
        Time.strptime(string, '%m/%d/%Y').to_date
      end
    end

    # 'mm-dd-yyyy hh:mm' to Fri, 01 Jan 2016 00:00:00 -0800
    def string_24h_to_datetime(string)
      if string.present?
        Time.strptime(string, '%m-%d-%Y %H:%M').to_datetime
      else
        nil
      end
    end


  end
end