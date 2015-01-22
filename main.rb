#!/usr/bin/ruby
# encoding: UTF-8

require 'rubygems'
require 'yaml'
require 'httparty'
require 'csv'

# Updates user notification settings in the Canvas-LMS
class NotificationSetter
  include HTTParty
  # debug_output

  def initialize
    @config = YAML.load_file('config.yml')
    @host = @config['host']
    @auth_token = @config['admin_token']
    @headers = {'Authorization' => "Bearer #{@auth_token}"}
  end

  def update_users_notification_preferences(uid, email)
    options = {
      :query => {
        'notification_preferences' => {
          'frequency' => 'immediately'
        }
      },
      :headers => @headers
    }
    conversation_created_request_path = "#{@host}/api/v1/users/self/communication_channels/email/#{email}/notification_preferences/conversation_created?as_user_id=sis_login_id:#{uid}"
    announcement_created_by_you_request_path = "#{@host}/api/v1/users/self/communication_channels/email/#{email}/notification_preferences/announcement_created_by_you?as_user_id=sis_login_id:#{uid}"
    conversation_created_result = self.class.put(conversation_created_request_path, options)
    announcement_created_result = self.class.put(announcement_created_by_you_request_path, options)
    puts "Updated UID: #{uid} - #{email}"
  end

  def load_user_ids
    @users = []
    CSV.foreach('reports/' + @config['users_csv'], :headers => :first_row) do |user|
      @users << {'uid' => user['uid'], 'email' => user['email']}
    end
    puts "Users Loaded from CSV for processing: #{@users.inspect}\n\n\n"
    @users
  end

  def update_users
    load_user_ids
    @users.each do |user|
      update_users_notification_preferences(user['uid'], user['email'])
    end
    puts "---------------------------"
    puts "User Updates Completed"
    puts "---------------------------"
  end
end

proxy = NotificationSetter.new
proxy.update_users

