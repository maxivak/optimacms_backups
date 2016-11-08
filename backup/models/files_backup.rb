# encoding: utf-8

###


Model.new(:files_backup, 'Backup files of Rails app') do

  archive :files do |archive|
    dir_app = $app_config[:path]


    #archive.add "/path/to/a/file.rb"
    archive.add "#{dir_app}"

    #archive.exclude "/path/to/a/excluded_file.rb"
    archive.exclude "#{dir_app}tmp"
    archive.exclude "#{dir_app}log"
    archive.exclude "#{dir_app}public/assets"
    archive.exclude "#{dir_app}public/images"
    archive.exclude "#{dir_app}public/uploads"
    archive.exclude "#{dir_app}.idea"
    archive.exclude "#{dir_app}.git"
    archive.exclude "#{dir_app}.ansible"
  end





  #### Storages

  #setup_storages


  $backup_config['storages'].each do |b|
    if b['type']=='local'
      ##
      # Local (Copy)
      #
      store_with Local do |local|
        build_storage_local(local, b)
      end

    elsif b['type']=='scp'
      store_with SCP do |server|
        build_storage_scp(server, b)
      end

    elsif b['type']=='s3'
      ##
      # Store on Amazon S3
      #
      store_with S3 do |s3|
        build_storage_s3(s3, b)
      end

    end
  end



  ##
  # Gzip [Compressor]
  #
  compress_with Gzip



  ### notify

  notify_by Mail do |mail|
    c = $smtp_config


  end

end
