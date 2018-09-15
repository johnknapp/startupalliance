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

  desc 'destroy old classifieds'
  task old_classifieds: :environment do
    Classified.where('created_at < ?', Time.now-30.days).destroy_all
    p '> > > > > > > > old classifieds gone!'
  end

end