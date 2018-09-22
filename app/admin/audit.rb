ActiveAdmin.register Audit do

  menu parent: 'JK only'

  index do
    selectable_column
    column :page do |audit|
      if audit.auditable
        link_to audit.auditable.title, page_path(audit.auditable), target: '_blank'
      else
        'gone!'
      end
    end
    column :user
    column :version
    column :action
    column :audited_changes do |audit|
      truncate(audit.audited_changes['content'].to_s,length: 120)
    end
    column :created_at
    actions
  end

  filter :user
  filter :action
  filter :version
  filter :created_at

  end