module Optimacms
  module AdminMenu
    class AdminMenu
      include Optimacms::Concerns::AdminMenu::AdminMenu

      def self.get_menu_custom
        [
            {
                title: 'Backups', route: nil,
                submenu: [
                    {title: 'Backups', url: Optimacms.admin_namespace+'/backups' },
                ]
            }



        ]
      end

    end
  end
end
