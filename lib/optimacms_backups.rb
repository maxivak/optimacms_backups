require "optimacms_backups/engine"

module OptimacmsBackups

  #mattr_accessor :backups_config
  @@backups_config = nil

  def self.backups_config
    return @@backups_config unless (@@backups_config.nil?)

    @@backups_config = YAML.load_file(File.join(Rails.root, 'config/backup', "#{Rails.env}.yml"))


    @@backups_config
  end

end
