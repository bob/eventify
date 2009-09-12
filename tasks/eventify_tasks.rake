namespace :eventify do                                       
  desc "Sync extra files from eventify plugin."
  task :sync do
    system "rsync -ruv vendor/plugins/eventify/db/migrate db"
    system "rsync -ruv vendor/plugins/eventify/app ."
    system "rsync -ruv vendor/plugins/eventify/config ."
    system "rsync -ruv vendor/plugins/eventify/public/stylesheets public"    
    system "rsync -ruv vendor/plugins/eventify/spec ."    
  end
end