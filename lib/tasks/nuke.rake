namespace :nuke do

  desc 'really destroy soft deleted pages'
  task zombie_pages: :environment do
    Page.only_deleted.find_each do |z|
      p z.pid
      z.really_destroy!
    end
    p '> > > > > > > > zombie pages gone!'
  end

  desc 'destroy orphan audits'
  task orphan_audits: :environment do
    Audit.where(auditable_id: nil).destroy_all
    p '> > > > > > > > orphan audits gone!'
  end

end