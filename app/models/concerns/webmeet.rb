module Webmeet
  extend ActiveSupport::Concern
  included do

    before_validation(on: :create) do
      update_attribute(:webmeet_code, Generator.code(6))
    end

  end
end