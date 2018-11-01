class User < ApplicationRecord
  
    def self.find_or_create_from_auth(auth)
        provider = auth[:provider]
        uid = auth[:uid]
        auth_name = auth[:info][:name]
        auth_nickname = auth[:info][:name]
        image_url = auth[:info][:image]

        self.find_or_create_by(provider: provider, uid: uid) do |user|
            user.auth_name = auth_name
            user.auth_nickname = auth_nickname
            user.image_url = image_url
        end
    end
end
