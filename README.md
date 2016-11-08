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



## Add optimacms_backups to your project

Gemfile:
```
gem 'optimacms_backups'
```

bundle:
```
bundle install
```

* install

```
RAILS_ENV=development rake optimacms_backups:install
```

this will copy folder `backup/` to the Rails project.



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
 


## Config



* edit backup config for each environment

```
# config/backup/development.yml
```


* base dir for local storage

```
# config/backup/ __env__. yml

dir_backups_base: '/path/to/backups/myapp/' 


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

* you can perform backups from admin area of CMS or peform backups using backup gem


## Perform backups manually

```
app_env=production backup perform -t files_backup --root-path backup
app_env=production backup perform -t db_backup --root-path backup
```


## Run backups with cron and whenever gem



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





