ActiveAdmin.register Discussion do

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

end