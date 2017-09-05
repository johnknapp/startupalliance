ActiveAdmin.register Okr do

  permit_params :id, :objective, :key_result_1, :key_result_2, :key_result_3, :kr1_score, :kr2_score, :kr3_score, :postmortem, :okr_duration, :okr_units, :okr_start, :status, :score, :owner_id, :company_id, :pid

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :pid
    column :objective
    column :duration do |okr|
      "#{okr.okr_duration} #{okr.okr_units}"
    end
    column :mid_score
    column :final_score
    column :postmortem
    column :company
    actions
  end

end