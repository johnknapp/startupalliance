module Pid
  extend ActiveSupport::Concern
  included do

    before_validation(on: :create) do
      update_attribute(:pid, Generator.pid(self))
    end

    def to_param
      pid
    end

  end
end