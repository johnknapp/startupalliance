module Webmeet
  extend ActiveSupport::Concern
  included do

    before_validation(on: :create) do
      update_attribute(:webmeet_url, link)
    end

    private

      def link
        'https://talky.io/sa-webmeet-' + Generator.code(4)
      end

  end
end