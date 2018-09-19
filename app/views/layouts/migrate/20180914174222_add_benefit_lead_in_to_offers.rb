class AddBenefitLeadInToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :benefit_lead_in, :string
  end
end
