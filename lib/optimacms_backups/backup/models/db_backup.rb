# encoding: utf-8

###


Model.new(:db_backup, 'Backup DB of Rails app') do
  database MySQL, :gex do |db|
    db.name           = $db_config['db'] || $db_config['db_name']
    db.host           = $db_config['db_host']
    db.username       = $db_config['db_user']
    db.password       = $db_config['db_password']

  end





  #### Storages

  $backup_config['storages'].each do |b|
    if b['type']=='scp'
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

    elsif b['type']=='local'
      ##
      # Local (Copy)
      #
      store_with Local do |local|
        build_storage_local(local, b)
      end
    end
  end



  ##
  # Gzip [Compressor]
  #
  compress_with Gzip



  ### notify

  if $backup_config['notify']['mail']

    notify_by Mail do |mail|
      c = $smtp_config

    end
  end

  if $backup_config['notify']['slack']
    notify_by Slack do |slack|

    end
  end


end
