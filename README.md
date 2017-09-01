# Backups module for OptimaCMS

Manage backups:
* perform backups from Admin area
* view backups
* download backup
* delete backup


It uses gem [backup](https://github.com/backup/backup) to perform backups.


# Install

* install backup gem first
Note: do not add backup gem to Gemfile

```
gem install backup
```



* Gemfile:

```
gem 'backup'
gem 'backup-remote'
gem 'optimacms_backups'
```

bundle:
```
bundle install
```

* install

```
rake optimacms_backups:install
```

this will copy folder `backup/` to the Rails project.
Usually you do not need to touch files in `backup/` directory. Edit config files in `config/backup/` directory.




* routes:
```
# config/routes.rb

  # optimaCMS modules
  mount OptimacmsBackups::Engine => "/", :as => "cms_backups"

```

* Add links to Admin area menu:
 
```
# lib/optimacms/admin_menu/admin_menu.rb

module Optimacms
  module AdminMenu
    class AdminMenu
      include Optimacms::Concerns::AdminMenu::AdminMenu

      def self.get_menu_custom
        [
            {
              title: 'Backups', route: nil,
              submenu: [
                  {title: 'Backups', url: '/'+Optimacms.admin_namespace+'/backups' },
              ]
            }
        ]    
      end

    end
  end
end
            
```
 
## Backups

What to backup:
* database - backup database (Mysql). Config is stored in backup/models/db_backup.rb  
* user files - backup user files like public/uploads, etc. Config is stored in backup/models/user_files_backup.rb
* app files - backup app files with app/, lib/ folders, etc without user files. Config is stored in backup/models/app_files_backup.rb


## Config

* edit backup config for each environment in `config/backup/ __env__ .yml` 

for example,
```
config/backup/development.yml
```


* base dir for local storage

```
# config/backup/ __env__. yml

dir_backups_base: '/path/to/backups/myapp/' 


```

## Config for backups


### Backup app files
* Directories to include/exclude in app files backup in addition to base directories

```
# config/backup/ __env__ .yml

backup:
  app_files:
    include:
      - app
      - lib
    
    exclude:
      - app/assets
      - .idea
      - .git
      - backup
      - log
      - tmp
      - public/img
      - public/cache
      
```

* Directories to include to user files backup. ONLY these directories will be included.

If directory starts from `/` it will be added as is otherwise the directory is considered as relative to the Rails application path. 


### Backup user files

```
# config/backup/ __env__ .yml

backup:
  user_files:
    include:
      - public/uploads
      - public/images
      - /path/to/another/folder
    
    exclude:
      - public/cache
      - tmp
      - log
      
            
```


## Storages

It supports storages from backup gem:
* local
* remote server using scp
* s3
* rsync


enter storages for your backups in `config/backup/ __env__. yml`:

```
storages:
  -
    type: "local"
    path: "/my/path/backups/myapp"

  -
    type: "scp"
    username: "username"
    password: 'pwd'
    ip: 'mybackup.mysite.com'
    port: 22
    path: '/backups/api-main'

  -
    type: "s3"
    region: "us-west-2"
    bucket: "my-backups"
    path: "/myapp"
    
```


## Notify by email

* edit 'config/backup/ <env> .yml'

```
notify:
  mail:
    from: noreply@mysite.com
    to: myemail@mysite.com
    reply_to: myemail@mysite.com
```


## SMTP settings

it expects the following keys in secrets.yml to be set:

```
# config/secrets.yml

development:

  smtp:
    address: "youraddress.com"
    port: 587
    domain: "yoursite.iom"
    authentication: 'plain'
    user_name: "uuu"
    password: "ppppp"
    enable_starttls_auto: true
    
    
```


## Notify by Slack

* 'config/backup/ <env> .yml'

```
notify:
 slack:
     webhook_url: "https://hooks.slack.com/webhook_url"
     channel: "#your_channel"
     username: "your_user"
     success: true
     warning: true
     failure: true
```





## Amazon S3

* edit 'config/backup/ <env> .yml'

```
s3:
  access_key_id: "xxx"
  secret_access_key: "yyy"
  region: "region"
  bucket: "my-backups"
```



# Examples of config

* `config/backup/ __env__ /yml`

it will 
* store backups locally, upload to remote server with scp, store on S3 storage
* notify by email after backup complete


```
dir_backups_base: "/path/to/backups/myapp/"


backup:
  app_files:
    exclude:
      - public/system
      - public/uploads
      - data
      - db


  user_files:
    include:
      - public/uploads
      - public/images

      
      
notify:
  mail:
    from: noreply@mysite.com
    to: myemail@mysite.com
    reply_to: myemail@mysite.com



s3:
  access_key_id: "xxx"
  secret_access_key: "xxxxxx"
  region: "us-west-1"
  bucket: "my-backups"
  #path: "/myapp"



storages:
  -
    type: "local"
    path: "/disk3/backups/myapp"


  -
    type: "scp"
    username: "user"
    password: 'pwd'
    ip: '11.22.33.44'
    port: 22
    path: '/disk2/backups/myapp'

  -
    type: "s3"
    region: "us-west-2"
    bucket: "my-backups"
    path: "/myapp"

```

# Perform backups

* you can perform backups from admin area of CMS or perform backups using backup gem


## Perform backups manually

```
cd /project/path
app_env=production bundle exec backup perform -t app_files_backup --root-path backup
app_env=production bundle exec backup perform -t user_files_backup --root-path backup
app_env=production bundle exec backup perform -t db_backup --root-path backup
```


## Run backups with cron and whenever gem

* use gem whenever to schedule backups

```
wheneverize
```

* edit `config/schedule.rb`

```
# add

app_env = ENV['app_env'] || ENV['RAILS_ENV']

app_dir = File.expand_path("../../", __FILE__)+'/'


every 4.hours do
  command "app_env=#{app_env} backup perform -t db_backup --root-path #{app_dir}backup"
end

every 4.hours do
  command "app_env=#{app_env} backup perform -t app_files_backup --root-path #{app_dir}backup"
end

every 1.day, :at => '5:30 am' do
  command "app_env=#{app_env} backup perform -t user_files_backup --root-path #{app_dir}backup"
end


```

* install cron with whenever

```
rvmsudo app_env=production whenever --update-crontab
```


* check crontab

```
sudo crontab -l
```

 
# Customize

* copy folder backup from gem to your app

* edit files





