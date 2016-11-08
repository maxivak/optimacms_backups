
namespace :optimacms_backups do

  # install backup
  task :install => :environment do
    # backup/ folder
    Dir.mkdir("backup") unless Dir.exists?("backup")
    Dir.mkdir("backup/models") unless Dir.exists?("backup/models")

    #directory "optimacms_backups/backup"
    #directory "optimacms_backups/backup/models"

    # copy folder
    files = [
        'config.rb',
        'init.rb',
        'models/app_files_backup.rb',
        'models/user_files_backup.rb',
        'models/db_backup.rb'
    ]

    files.each do |f|
      source = File.join(Gem.loaded_specs["optimacms_backups"].full_gem_path, "lib/optimacms_backups/backup", f)
      target = File.join(Rails.root, "backup", f)

      FileUtils.cp_r source, target
    end

    #file 'my_gem' => ['otherdata']
    #file 'backup' do
    #  cp Dir['backup/**/*'], 'backup'
    #end

  end
end
