ActiveAdmin.register Company do

  permit_params :id, :pid, :webmeet_url, :name, :description, :primary_market, :sakpi_index, :phases, :url, :location, :latitude, :longitude, :time_zone, :founded, :state, :creator_id

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :pid
    column :name
    column :description
    column :primary_market
    column :site do |company|
      link_to company.url, company.url
    end
    column :state
    actions
  end

end