ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    columns do
      column do
        panel "Recent Users" do
          ul do
            User.last(20).reverse.map do |user|
              li link_to user.username, admin_user_path(user.pid)
            end
          end
        end
      end
      column do
        panel "Recent Companies" do
          ul do
            Company.last(20).reverse.map do |company|
              li link_to company.name, admin_company_path(company.pid)
            end
          end
        end
      end
      column do
        panel "Recent Alliances" do
          ul do
            Alliance.last(20).reverse.map do |alliance|
              li link_to alliance.name, admin_alliance_path(alliance.pid)
            end
          end
        end
      end
    end
    columns do
      column do
        panel 'Recent KB Pages' do
          ul do
            Page.last(20).reverse.map do |page|
              li link_to page.title, admin_page_path(page.pid)
            end
          end
        end
      end
      column do
        panel 'Recent Forum Topics' do
          ul do
            Topic.last(20).reverse.map do |topic|
              li link_to truncate(topic.name, length: 48), admin_topic_path(topic.pid)
            end
          end
        end
      end
      column do
        panel 'Recent Forum Posts' do
          ul do
            Post.last(20).reverse.map do |post|
              li link_to truncate(post.body, length: 72), admin_post_path(post.pid)
            end
          end
        end
      end
    end
    columns do
      column do
        panel 'Recent Events' do
          ul do
            Event.last(20).reverse.map do |event|
              li link_to event.title, events_path(query: event.title)
            end
          end
        end
      end
      column do
        panel 'Recent Classified ads' do
          ul do
            Classified.last(20).reverse.map do |classified|
              li link_to classified.title, classifieds_path(query: classified.title)
            end
          end
        end
      end
    end


    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
