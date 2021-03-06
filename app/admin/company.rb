ActiveAdmin.register Company do

  permit_params :id, :pid, :webmeet_code, :name, :mission, :member_cap, :primary_market, :sakpi_index, :phases, :url, :country_code, :time_zone, :founded, :recruiting, :creator_id, :is_unlisted, :state

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :pid
    column :name
    column :mission
    column :member_cap
    column :primary_market
    column :site do |company|
      link_to company.url, company.url
    end
    column :is_unlisted
    column :state
    column :recruiting
    column :creator
    actions
  end

end