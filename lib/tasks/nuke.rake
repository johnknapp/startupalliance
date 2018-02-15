namespace :nuke do

  desc 'really destroy soft deleted pages'
  task zombie_pages: :environment do
    Page.only_deleted.find_each do |z|
      p z.pid
      z.really_destroy!
    end
    p '> > > > > > > > zombie pages gone!'
  end

end