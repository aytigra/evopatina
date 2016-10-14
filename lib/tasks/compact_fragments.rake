namespace :db do
  desc 'Compact fragments older than 100 days.'
  task compact_fragments: :environment do
    Fragment.compact_old_fragments
  end
end
