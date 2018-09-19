class RefactorOffers < ActiveRecord::Migration[5.0]
  def change
    add_column    :offers, :box_1,            :text
    rename_column :offers, :plan_benefits,    :box_2
    add_column    :offers, :video_url,        :string
    add_column    :offers, :cta_button_text,  :string
  end
end
