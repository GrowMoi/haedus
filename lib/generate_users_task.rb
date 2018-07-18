require 'csv'
require "utils/remote_fetcher"

class GenerateUsersTask
  def initialize(list_uri)
    @list_uri = list_uri
  end

  def run!
    out_uri = "generate_users_task-#{Time.now.to_s.parameterize}.csv"
    @csv_out = CSV.open(Rails.root.join("public", out_uri), "wb")
    @csv_out << ["username", "authorization_key", "name", "email"]
    users_list.each do |user_names|
      user = User.new(
        name: user_names,
        authorization_key: UserAuthorizationKeys::KEYS.sample
      )
      count = 0
      username = generate_username(user_names, count)
      email = "#{username}@growmoi.com"
      while User.exists?(username: username) || User.exists?(email: email)
        count += 1
        username = generate_username(user_names, count)
        email = "#{username}@growmoi.com"
      end
      user.email = email
      user.username = username
      user.save!
      @csv_out << [user.username, user.authorization_key, user.name, user.email]
      puts [user.username, user.authorization_key, user.name, user.email]
    end
    puts "done! open at #{out_uri}"
  end

  private

  def generate_username(user_names, count)
    split_names = user_names.split(" ")
    last_name = split_names[0]
    first_name = split_names[2]
    "#{last_name}#{first_name}#{(count == 0 ? "" : count)}".parameterize
  end

  def users_list
    fetch(@list_uri).body.split("\n")
  end

  def fetch(uri_str)
    Utils::RemoteFetcher.fetch(uri_str)
  end
end
