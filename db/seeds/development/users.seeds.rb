User.destroy_all

admin = User.new(first_name: 'Ima', last_name: 'Admin', email: 'admin@example.com', username: 'ima-admin', time_zone: 'Pacific Time (US & Canada)', role: 'john', state: 'active', password: 'password', password_confirmation: 'password')
admin.skip_confirmation!
admin.save

user = User.new(first_name: 'Ima', last_name: 'User', email: 'user@example.com', username: 'ima-user', time_zone: 'Eastern Time (US & Canada)', role: 'user', state: 'active', password: 'password', password_confirmation: 'password')
user.skip_confirmation!
user.save

