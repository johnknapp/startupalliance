User.destroy_all

admin = User.new(first_name: 'Ima', last_name: 'Admin', email: 'admin@example.com', username: 'john',
                 time_zone: 'Pacific Time (US & Canada)', role: 'admin', state: 'active', plan: 'company',
                 password: 'password', password_confirmation: 'password'
              )
admin.skip_confirmation!
admin.save

associate = User.new(first_name: 'Associate', last_name: 'User', email: 'associate@example.com', username: 'ima-associate',
                time_zone: 'Eastern Time (US & Canada)', role: 'user', state: 'active', plan: 'associate',
                password: 'password', password_confirmation: 'password'
              )
associate.skip_confirmation!
associate.save

alliance = User.new(first_name: 'Alliance', last_name: 'User', email: 'alliance@example.com', username: 'ima-alliance',
                time_zone: 'Eastern Time (US & Canada)', role: 'user', state: 'active', plan: 'alliance',
                password: 'password', password_confirmation: 'password'
              )
alliance.skip_confirmation!
alliance.save

company = User.new(first_name: 'Company', last_name: 'User', email: 'company@example.com', username: 'ima-company',
                time_zone: 'Eastern Time (US & Canada)', role: 'user', state: 'active', plan: 'company',
                password: 'password', password_confirmation: 'password'
              )
company.skip_confirmation!
company.save

